package com.battery.recycle.service;

import jakarta.annotation.Resource;

import com.battery.recycle.constant.SystemConstants;
import com.battery.recycle.entity.ExchangeProduct;
import com.battery.recycle.entity.ExchangeRecord;
import com.battery.recycle.exception.BusinessException;
import com.battery.recycle.mapper.ExchangeRecordMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 兑换记录服务类
 */
@Service
public class ExchangeRecordService {

    @Resource
    private ExchangeRecordMapper exchangeRecordMapper;

    @Resource
    private ExchangeProductService exchangeProductService;

    @Resource
    private UserPointsService userPointsService;

    @Resource
    private UserSeckillCouponService userSeckillCouponService;

    /**
     * 根据ID查询记录
     */
    public ExchangeRecord getById(Long id) {
        ExchangeRecord record = exchangeRecordMapper.getById(id);
        if (record == null) {
            throw new BusinessException("兑换记录不存在");
        }
        return record;
    }

    /**
     * 查询所有记录
     */
    public List<ExchangeRecord> listAll() {
        return exchangeRecordMapper.listAll();
    }

    /**
     * 根据用户ID查询记录
     */
    public List<ExchangeRecord> listByUserId(Long userId) {
        return exchangeRecordMapper.listByUserId(userId);
    }

    /**
     * 分页查询记录
     */
    public List<ExchangeRecord> listByPage(Integer page, Integer size) {
        int offset = (page - 1) * size;
        return exchangeRecordMapper.listByPage(offset, size);
    }

    /**
     * 统计记录总数
     */
    public Integer count() {
        return exchangeRecordMapper.count();
    }

    /**
     * 创建兑换记录
     */
    @Transactional(rollbackFor = Exception.class)
    public void createExchange(ExchangeRecord record) {
        // 默认兑换数量为1，避免前端漏传数量导致空指针
        if (record.getQuantity() == null || record.getQuantity() < 1) {
            record.setQuantity(1);
        }

        // 查询商品信息
        ExchangeProduct product = exchangeProductService.getById(record.getProductId());

        // 检查商品状态
        if (product.getStatus() != 1) {
            throw new BusinessException("该商品已下架");
        }

        // 检查库存
        if (product.getStock() < record.getQuantity()) {
            throw new BusinessException("库存不足");
        }

        // 秒杀券兑换走独立链路：只扣商品库存，不再扣商品所需积分
        if (SystemConstants.EXCHANGE_TYPE_SECKILL_COUPON.equals(record.getExchangeType()) || record.getCouponId() != null) {
            createExchangeByCoupon(record, product);
            return;
        }

        // 计算所需积分
        int totalPoints = product.getPointsRequired() * record.getQuantity();

        // 扣减用户积分
        boolean success = userPointsService.deductPoints(record.getUserId(), totalPoints);
        if (!success) {
            throw new BusinessException("积分不足");
        }

        // 扣减库存
        success = exchangeProductService.updateStock(product.getId(), record.getQuantity());
        if (!success) {
            throw new BusinessException("库存不足");
        }

        // 创建兑换记录
        record.setProductName(product.getProductName());
        record.setPointsUsed(totalPoints);
        record.setExchangeStatus(0); // 待发货
        record.setExchangeType(SystemConstants.EXCHANGE_TYPE_POINTS);
        exchangeRecordMapper.insert(record);
    }

    /**
     * 使用秒杀券兑换商品
     */
    private void createExchangeByCoupon(ExchangeRecord record, ExchangeProduct product) {
        if (record.getCouponId() == null) {
            throw new BusinessException(SystemConstants.SECKILL_COUPON_NOT_FOUND);
        }
        record.setQuantity(1);
        userSeckillCouponService.validateCouponForExchange(record.getCouponId(), record.getUserId());

        boolean success = exchangeProductService.updateStock(product.getId(), 1);
        if (!success) {
            throw new BusinessException("库存不足");
        }

        record.setProductName(product.getProductName());
        record.setPointsUsed(0);
        record.setExchangeStatus(0);
        record.setExchangeType(SystemConstants.EXCHANGE_TYPE_SECKILL_COUPON);
        exchangeRecordMapper.insert(record);
        userSeckillCouponService.markUsed(record.getCouponId(), product.getId(), record.getId());
    }

    /**
     * 更新兑换状态
     */
    public void updateStatus(Long id, Integer status) {
        ExchangeRecord record = exchangeRecordMapper.getById(id);
        if (record == null) {
            throw new BusinessException("兑换记录不存在");
        }
        record.setExchangeStatus(status);
        exchangeRecordMapper.update(record);
    }
}




































