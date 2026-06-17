package com.battery.recycle.service;

import com.battery.recycle.constant.RedisConstants;
import com.battery.recycle.constant.SystemConstants;
import com.battery.recycle.entity.SeckillActivity;
import com.battery.recycle.entity.UserPoints;
import com.battery.recycle.entity.UserSeckillCoupon;
import com.battery.recycle.exception.BusinessException;
import com.battery.recycle.mapper.SeckillActivityMapper;
import com.battery.recycle.mapper.UserSeckillCouponMapper;
import com.battery.recycle.mq.producer.SeckillCouponProducer;
import com.battery.recycle.util.CacheClient;
import org.springframework.core.io.ClassPathResource;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.core.script.DefaultRedisScript;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import jakarta.annotation.Resource;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;
import java.util.concurrent.TimeUnit;

/**
 * 秒杀活动服务类
 */
@Service
public class SeckillActivityService {

    @Resource
    private SeckillActivityMapper seckillActivityMapper;

    @Resource
    private UserSeckillCouponMapper userSeckillCouponMapper;

    @Resource
    private UserPointsService userPointsService;

    @Resource
    private StringRedisTemplate stringRedisTemplate;

    @Resource
    private CacheClient cacheClient;

    @Resource
    private SeckillCouponProducer seckillCouponProducer;

    /**
     * 秒杀Lua脚本，保证Redis库存和重复抢购判断原子执行
     */
    private static final DefaultRedisScript<Long> SECKILL_SCRIPT;

    static {
        SECKILL_SCRIPT = new DefaultRedisScript<>();
        SECKILL_SCRIPT.setLocation(new ClassPathResource("seckill_coupon.lua"));
        SECKILL_SCRIPT.setResultType(Long.class);
    }

    /**
     * 根据ID查询活动，使用互斥锁缓存避免热点活动缓存击穿
     */
    public SeckillActivity getById(Long id) {
        SeckillActivity activity = cacheClient.queryWithMutex(
                RedisConstants.CACHE_SECKILL_ACTIVITY_KEY,
                id,
                SeckillActivity.class,
                seckillActivityMapper::getById,
                RedisConstants.CACHE_NORMAL_TTL,
                TimeUnit.MINUTES
        );
        if (activity == null) {
            throw new BusinessException(SystemConstants.SECKILL_ACTIVITY_NOT_FOUND);
        }
        return activity;
    }

    /**
     * 管理员查询全部活动
     */
    public List<SeckillActivity> listAll() {
        return seckillActivityMapper.listAll();
    }

    /**
     * 用户查询已上架活动
     */
    public List<SeckillActivity> listOnline() {
        return seckillActivityMapper.listOnline();
    }

    /**
     * 管理员创建活动，默认500积分、100库存、草稿状态
     */
    public void add(SeckillActivity activity, Long adminId) {
        fillDefaultValue(activity, adminId);
        validateActivityTime(activity);
        seckillActivityMapper.insert(activity);
    }

    /**
     * 管理员更新活动，同时删除活动缓存
     */
    public void update(SeckillActivity activity) {
        if (activity.getId() == null || seckillActivityMapper.getById(activity.getId()) == null) {
            throw new BusinessException(SystemConstants.SECKILL_ACTIVITY_NOT_FOUND);
        }
        validateActivityTime(activity);
        seckillActivityMapper.update(activity);
        deleteActivityCache(activity.getId());
    }

    /**
     * 管理员上架活动，上架时把库存预热到Redis
     */
    public void online(Long id) {
        SeckillActivity activity = seckillActivityMapper.getById(id);
        if (activity == null) {
            throw new BusinessException(SystemConstants.SECKILL_ACTIVITY_NOT_FOUND);
        }
        activity.setStatus(SystemConstants.SECKILL_STATUS_ONLINE);
        seckillActivityMapper.update(activity);
        preheat(id);
        deleteActivityCache(id);
    }

    /**
     * 管理员下架活动，同时清理缓存和秒杀运行期Redis数据
     */
    public void offline(Long id) {
        SeckillActivity activity = seckillActivityMapper.getById(id);
        if (activity == null) {
            throw new BusinessException(SystemConstants.SECKILL_ACTIVITY_NOT_FOUND);
        }
        activity.setStatus(SystemConstants.SECKILL_STATUS_OFFLINE);
        seckillActivityMapper.update(activity);
        deleteSeckillRuntimeKeys(id);
    }

    /**
     * 手动预热活动库存到Redis，保证秒杀前Redis有库存Key
     */
    public void preheat(Long id) {
        SeckillActivity activity = seckillActivityMapper.getById(id);
        if (activity == null) {
            throw new BusinessException(SystemConstants.SECKILL_ACTIVITY_NOT_FOUND);
        }
        int remainStock = Math.max(activity.getStock() - activity.getSold(), 0);
        String stockKey = RedisConstants.SECKILL_STOCK_KEY + id;
        stringRedisTemplate.opsForValue().set(stockKey, String.valueOf(remainStock), 8, TimeUnit.DAYS);
        cacheClient.set(RedisConstants.CACHE_SECKILL_ACTIVITY_KEY + id, activity, RedisConstants.CACHE_NORMAL_TTL, TimeUnit.MINUTES);
    }

    /**
     * 用户抢券入口，先做业务校验，再交给Lua做Redis原子预扣，成功后投递RabbitMQ异步发券
     */
    public void seckill(Long activityId, Long userId) {
        SeckillActivity activity = getById(activityId);
        validateSeckillActivity(activity);
        validateUserCanSeckill(activity, userId);

        Long result = stringRedisTemplate.execute(
                SECKILL_SCRIPT,
                Arrays.asList(
                        RedisConstants.SECKILL_STOCK_KEY + activityId,
                        RedisConstants.SECKILL_USERS_KEY + activityId
                ),
                activityId.toString(),
                userId.toString()
        );
        int code = result == null ? -1 : result.intValue();
        if (code == 1) {
            throw new BusinessException(SystemConstants.SECKILL_STOCK_NOT_ENOUGH);
        }
        if (code == 2) {
            throw new BusinessException(SystemConstants.SECKILL_REPEAT_ORDER);
        }
        if (code != 0) {
            throw new BusinessException(SystemConstants.OPERATION_FAILED);
        }

        try {
            seckillCouponProducer.sendSeckillCouponMessage(activityId, userId);
        } catch (BusinessException e) {
            compensateRedis(activityId, userId);
            throw e;
        }
    }

    /**
     * Stream消费者调用的核心处理逻辑，后续换RabbitMQ时也复用这个方法
     */
    @Transactional(rollbackFor = Exception.class)
    public void handleSeckillMessage(Long activityId, Long userId) {
        SeckillActivity activity = seckillActivityMapper.getById(activityId);
        if (activity == null) {
            throw new BusinessException(SystemConstants.SECKILL_ACTIVITY_NOT_FOUND);
        }
        if (userSeckillCouponMapper.getByActivityAndUser(activityId, userId) != null) {
            return;
        }

        boolean deductSuccess = userPointsService.deductPoints(userId, activity.getPointsCost());
        if (!deductSuccess) {
            throw new BusinessException(SystemConstants.SECKILL_POINTS_NOT_ENOUGH);
        }

        int soldRows = seckillActivityMapper.increaseSold(activityId);
        if (soldRows == 0) {
            throw new BusinessException(SystemConstants.SECKILL_STOCK_NOT_ENOUGH);
        }

        UserSeckillCoupon coupon = new UserSeckillCoupon();
        coupon.setActivityId(activityId);
        coupon.setUserId(userId);
        coupon.setStatus(SystemConstants.COUPON_STATUS_UNUSED);
        coupon.setEffectiveTime(activity.getCouponStartTime());
        coupon.setExpireTime(activity.getCouponEndTime());
        userSeckillCouponMapper.insert(coupon);
        deleteActivityCache(activityId);
    }

    /**
     * 秒杀落库或消息投递失败时补偿Redis预扣库存和已抢用户Set。
     * 先删除用户Set再恢复库存，可以避免重复补偿导致库存被多加。
     */
    public void compensateRedis(Long activityId, Long userId) {
        Long removed = stringRedisTemplate.opsForSet()
                .remove(RedisConstants.SECKILL_USERS_KEY + activityId, userId.toString());
        if (removed != null && removed > 0) {
            stringRedisTemplate.opsForValue().increment(RedisConstants.SECKILL_STOCK_KEY + activityId);
        }
    }

    /**
     * 活动创建时填充默认值
     */
    private void fillDefaultValue(SeckillActivity activity, Long adminId) {
        if (activity.getStock() == null) {
            activity.setStock(100);
        }
        if (activity.getSold() == null) {
            activity.setSold(0);
        }
        if (activity.getPointsCost() == null) {
            activity.setPointsCost(500);
        }
        if (activity.getStatus() == null) {
            activity.setStatus(SystemConstants.SECKILL_STATUS_DRAFT);
        }
        activity.setCreateAdminId(adminId);
    }

    /**
     * 校验活动时间完整性
     */
    private void validateActivityTime(SeckillActivity activity) {
        if (activity.getStartTime() != null && activity.getEndTime() != null
                && !activity.getStartTime().isBefore(activity.getEndTime())) {
            throw new BusinessException("秒杀结束时间必须晚于开始时间");
        }
        if (activity.getCouponStartTime() != null && activity.getCouponEndTime() != null
                && !activity.getCouponStartTime().isBefore(activity.getCouponEndTime())) {
            throw new BusinessException("优惠券过期时间必须晚于生效时间");
        }
    }

    /**
     * 校验秒杀活动当前是否允许抢券
     */
    private void validateSeckillActivity(SeckillActivity activity) {
        if (!SystemConstants.SECKILL_STATUS_ONLINE.equals(activity.getStatus())) {
            throw new BusinessException(SystemConstants.SECKILL_ACTIVITY_OFFLINE);
        }
        LocalDateTime now = LocalDateTime.now();
        if (now.isBefore(activity.getStartTime())) {
            throw new BusinessException(SystemConstants.SECKILL_ACTIVITY_NOT_STARTED);
        }
        if (now.isAfter(activity.getEndTime())) {
            throw new BusinessException(SystemConstants.SECKILL_ACTIVITY_ENDED);
        }
    }

    /**
     * 用户抢券前做快速校验，最终仍由MySQL事务兜底
     */
    private void validateUserCanSeckill(SeckillActivity activity, Long userId) {
        if (userSeckillCouponMapper.getByActivityAndUser(activity.getId(), userId) != null) {
            throw new BusinessException(SystemConstants.SECKILL_REPEAT_ORDER);
        }
        UserPoints userPoints = userPointsService.getByUserId(userId);
        if (userPoints.getAvailablePoints() < activity.getPointsCost()) {
            throw new BusinessException(SystemConstants.SECKILL_POINTS_NOT_ENOUGH);
        }
    }

    /**
     * 删除活动缓存
     */
    private void deleteActivityCache(Long id) {
        stringRedisTemplate.delete(RedisConstants.CACHE_SECKILL_ACTIVITY_KEY + id);
    }

    /**
     * 清理秒杀活动运行期Redis数据，下架后不保留库存Key和已抢用户Set。
     */
    private void deleteSeckillRuntimeKeys(Long id) {
        stringRedisTemplate.delete(Arrays.asList(
                RedisConstants.CACHE_SECKILL_ACTIVITY_KEY + id,
                RedisConstants.SECKILL_STOCK_KEY + id,
                RedisConstants.SECKILL_USERS_KEY + id
        ));
    }
}
