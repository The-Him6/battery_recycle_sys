package com.battery.recycle.controller;

import jakarta.annotation.Resource;

import com.battery.recycle.common.Result;
import com.battery.recycle.entity.SeckillActivity;
import com.battery.recycle.service.SeckillActivityService;
import com.battery.recycle.util.AuthUtil;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 秒杀活动控制器
 */
@RestController
@RequestMapping("/seckill")
public class SeckillActivityController {

    @Resource
    private SeckillActivityService seckillActivityService;

    /**
     * 管理员查询全部秒杀活动
     */
    @GetMapping("/activity/list")
    public Result<List<SeckillActivity>> listAll() {
        AuthUtil.requireAdmin();
        return Result.success(seckillActivityService.listAll());
    }

    /**
     * 用户查询已上架秒杀活动
     */
    @GetMapping("/activity/online")
    public Result<List<SeckillActivity>> listOnline() {
        return Result.success(seckillActivityService.listOnline());
    }

    /**
     * 根据ID查询秒杀活动
     */
    @GetMapping("/activity/{id}")
    public Result<SeckillActivity> getById(@PathVariable Long id) {
        return Result.success(seckillActivityService.getById(id));
    }

    /**
     * 管理员创建秒杀活动
     */
    @PostMapping("/activity")
    public Result<Void> add(@RequestBody SeckillActivity activity) {
        AuthUtil.requireAdmin();
        seckillActivityService.add(activity, AuthUtil.getUserId());
        return Result.success("创建秒杀活动成功", null);
    }

    /**
     * 管理员更新秒杀活动
     */
    @PutMapping("/activity")
    public Result<Void> update(@RequestBody SeckillActivity activity) {
        AuthUtil.requireAdmin();
        seckillActivityService.update(activity);
        return Result.success("更新秒杀活动成功", null);
    }

    /**
     * 管理员上架活动并预热Redis库存
     */
    @PutMapping("/activity/{id}/online")
    public Result<Void> online(@PathVariable Long id) {
        AuthUtil.requireAdmin();
        seckillActivityService.online(id);
        return Result.success("活动已上架并预热库存", null);
    }

    /**
     * 管理员下架活动
     */
    @PutMapping("/activity/{id}/offline")
    public Result<Void> offline(@PathVariable Long id) {
        AuthUtil.requireAdmin();
        seckillActivityService.offline(id);
        return Result.success("活动已下架", null);
    }

    /**
     * 管理员手动预热Redis库存
     */
    @PostMapping("/activity/{id}/preheat")
    public Result<Void> preheat(@PathVariable Long id) {
        AuthUtil.requireAdmin();
        seckillActivityService.preheat(id);
        return Result.success("预热成功", null);
    }

    /**
     * 用户抢秒杀券
     */
    @PostMapping("/{activityId}")
    public Result<Void> seckill(@PathVariable Long activityId) {
        seckillActivityService.seckill(activityId, AuthUtil.getUserId());
        return Result.success("抢券成功，优惠券将在生效时间后可用", null);
    }
}
