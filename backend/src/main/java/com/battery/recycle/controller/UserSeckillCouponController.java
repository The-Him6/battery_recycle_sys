package com.battery.recycle.controller;

import com.battery.recycle.common.Result;
import com.battery.recycle.entity.UserSeckillCoupon;
import com.battery.recycle.service.IUserSeckillCouponService;
import com.battery.recycle.util.AuthUtil;
import com.battery.recycle.vo.UserSeckillCouponVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.BeanUtils;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

/**
 * 用户秒杀券控制器
 */
@Tag(name = "用户秒杀券", description = "查询当前用户的秒杀优惠券")
@RestController
@RequestMapping("/seckill-coupon")
@RequiredArgsConstructor
public class UserSeckillCouponController {

        private final IUserSeckillCouponService userSeckillCouponService;

    /**
     * 查询我的全部秒杀券
     */
    @Operation(summary = "查询我的全部秒杀券")
    @GetMapping("/my")
    public Result<List<UserSeckillCouponVO>> listMyCoupons() {
        List<UserSeckillCoupon> list = userSeckillCouponService.listByUserId(AuthUtil.getUserId());
        List<UserSeckillCouponVO> voList = new ArrayList<>();
        for (UserSeckillCoupon item : list) {
            UserSeckillCouponVO vo = new UserSeckillCouponVO();
            BeanUtils.copyProperties(item, vo);
            voList.add(vo);
        }
        return Result.success(voList);
    }

    /**
     * 查询我的可用秒杀券
     */
    @Operation(summary = "查询我的可用秒杀券")
    @GetMapping("/usable")
    public Result<List<UserSeckillCouponVO>> listUsableCoupons() {
        List<UserSeckillCoupon> list = userSeckillCouponService.listUsableByUserId(AuthUtil.getUserId());
        List<UserSeckillCouponVO> voList = new ArrayList<>();
        for (UserSeckillCoupon item : list) {
            UserSeckillCouponVO vo = new UserSeckillCouponVO();
            BeanUtils.copyProperties(item, vo);
            voList.add(vo);
        }
        return Result.success(voList);
    }
}