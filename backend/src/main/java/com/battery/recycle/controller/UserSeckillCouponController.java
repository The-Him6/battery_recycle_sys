package com.battery.recycle.controller;

import jakarta.annotation.Resource;

import com.battery.recycle.common.Result;
import com.battery.recycle.entity.UserSeckillCoupon;
import com.battery.recycle.service.UserSeckillCouponService;
import com.battery.recycle.util.AuthUtil;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 用户秒杀券控制器
 */
@RestController
@RequestMapping("/seckill-coupon")
public class UserSeckillCouponController {

    @Resource
    private UserSeckillCouponService userSeckillCouponService;

    /**
     * 查询我的全部秒杀券
     */
    @GetMapping("/my")
    public Result<List<UserSeckillCoupon>> listMyCoupons() {
        return Result.success(userSeckillCouponService.listByUserId(AuthUtil.getUserId()));
    }

    /**
     * 查询我的可用秒杀券
     */
    @GetMapping("/usable")
    public Result<List<UserSeckillCoupon>> listUsableCoupons() {
        return Result.success(userSeckillCouponService.listUsableByUserId(AuthUtil.getUserId()));
    }
}
