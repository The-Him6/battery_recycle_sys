package com.battery.recycle.service;

import com.battery.recycle.constant.SystemConstants;
import com.battery.recycle.entity.UserSeckillCoupon;
import com.battery.recycle.exception.BusinessException;
import com.battery.recycle.mapper.UserSeckillCouponMapper;
import org.springframework.stereotype.Service;

import jakarta.annotation.Resource;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 用户秒杀券服务类
 */
@Service
public class UserSeckillCouponService {

    @Resource
    private UserSeckillCouponMapper userSeckillCouponMapper;

    /**
     * 根据ID查询用户券
     */
    public UserSeckillCoupon getById(Long id) {
        UserSeckillCoupon coupon = userSeckillCouponMapper.getById(id);
        if (coupon == null) {
            throw new BusinessException(SystemConstants.SECKILL_COUPON_NOT_FOUND);
        }
        refreshExpiredStatus(coupon);
        return coupon;
    }

    /**
     * 查询用户全部秒杀券，并懒更新过期状态
     */
    public List<UserSeckillCoupon> listByUserId(Long userId) {
        List<UserSeckillCoupon> list = userSeckillCouponMapper.listByUserId(userId);
        for (UserSeckillCoupon coupon : list) {
            refreshExpiredStatus(coupon);
        }
        return list;
    }

    /**
     * 查询用户可用于兑换的秒杀券
     */
    public List<UserSeckillCoupon> listUsableByUserId(Long userId) {
        return userSeckillCouponMapper.listUsableByUserId(userId);
    }

    /**
     * 校验一张券是否可以用于兑换
     */
    public UserSeckillCoupon validateCouponForExchange(Long couponId, Long userId) {
        UserSeckillCoupon coupon = getById(couponId);
        if (!coupon.getUserId().equals(userId)) {
            throw new BusinessException(SystemConstants.PERMISSION_DENIED);
        }
        if (SystemConstants.COUPON_STATUS_USED.equals(coupon.getStatus())) {
            throw new BusinessException(SystemConstants.SECKILL_COUPON_USED);
        }
        if (SystemConstants.COUPON_STATUS_EXPIRED.equals(coupon.getStatus())) {
            throw new BusinessException(SystemConstants.SECKILL_COUPON_EXPIRED);
        }
        LocalDateTime now = LocalDateTime.now();
        if (now.isBefore(coupon.getEffectiveTime())) {
            throw new BusinessException(SystemConstants.SECKILL_COUPON_NOT_EFFECTIVE);
        }
        if (now.isAfter(coupon.getExpireTime())) {
            userSeckillCouponMapper.markExpired(coupon.getId());
            coupon.setStatus(SystemConstants.COUPON_STATUS_EXPIRED);
            throw new BusinessException(SystemConstants.SECKILL_COUPON_EXPIRED);
        }
        return coupon;
    }

    /**
     * 标记秒杀券已使用
     */
    public void markUsed(Long couponId, Long productId, Long exchangeRecordId) {
        int rows = userSeckillCouponMapper.markUsed(couponId, productId, exchangeRecordId);
        if (rows == 0) {
            throw new BusinessException(SystemConstants.SECKILL_COUPON_USED);
        }
    }

    /**
     * 查询时懒更新过期券状态
     */
    private void refreshExpiredStatus(UserSeckillCoupon coupon) {
        if (SystemConstants.COUPON_STATUS_UNUSED.equals(coupon.getStatus())
                && coupon.getExpireTime() != null
                && LocalDateTime.now().isAfter(coupon.getExpireTime())) {
            userSeckillCouponMapper.markExpired(coupon.getId());
            coupon.setStatus(SystemConstants.COUPON_STATUS_EXPIRED);
        }
    }
}
