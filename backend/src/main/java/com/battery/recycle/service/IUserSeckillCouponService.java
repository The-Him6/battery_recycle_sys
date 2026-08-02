package com.battery.recycle.service;

import com.battery.recycle.entity.UserSeckillCoupon;

import java.util.List;

/**
 * 用户秒杀券服务接口。
 */
public interface IUserSeckillCouponService {

    UserSeckillCoupon getById(Long id);

    List<UserSeckillCoupon> listByUserId(Long userId);

    List<UserSeckillCoupon> listUsableByUserId(Long userId);

    UserSeckillCoupon validateCouponForExchange(Long couponId, Long userId);

    void markUsed(Long couponId, Long productId, Long exchangeRecordId);
}
