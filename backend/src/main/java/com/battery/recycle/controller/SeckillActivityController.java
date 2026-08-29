package com.battery.recycle.controller;

import com.battery.recycle.common.Result;
import com.battery.recycle.entity.SeckillActivity;
import com.battery.recycle.service.ISeckillActivityService;
import com.battery.recycle.util.AuthUtil;
import com.battery.recycle.vo.SeckillActivityVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.BeanUtils;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

/**
 * 秒杀活动控制器
 */
@Tag(name = "秒杀活动管理", description = "秒杀活动的创建、上下架、库存预热与用户抢券")
@RestController
@RequestMapping("/seckill")
@RequiredArgsConstructor
public class SeckillActivityController {

        private final ISeckillActivityService seckillActivityService;

    /**
     * 管理员查询全部秒杀活动
     */
    @Operation(summary = "查询全部秒杀活动", description = "仅管理员可操作")
    @GetMapping("/activity/list")
    public Result<List<SeckillActivityVO>> listAll() {
        AuthUtil.requireAdmin();
        List<SeckillActivity> list = seckillActivityService.listAll();
        List<SeckillActivityVO> voList = new ArrayList<>();
        for (SeckillActivity item : list) {
            SeckillActivityVO vo = new SeckillActivityVO();
            BeanUtils.copyProperties(item, vo);
            voList.add(vo);
        }
        return Result.success(voList);
    }

    /**
     * 用户查询已上架秒杀活动
     */
    @Operation(summary = "查询已上架秒杀活动")
    @GetMapping("/activity/online")
    public Result<List<SeckillActivityVO>> listOnline() {
        List<SeckillActivity> list = seckillActivityService.listOnline();
        List<SeckillActivityVO> voList = new ArrayList<>();
        for (SeckillActivity item : list) {
            SeckillActivityVO vo = new SeckillActivityVO();
            BeanUtils.copyProperties(item, vo);
            voList.add(vo);
        }
        return Result.success(voList);
    }

    /**
     * 根据ID查询秒杀活动
     */
    @Operation(summary = "根据ID查询秒杀活动")
    @GetMapping("/activity/{id}")
    public Result<SeckillActivityVO> getById(@PathVariable Long id) {
        SeckillActivity activity = seckillActivityService.getById(id);
        SeckillActivityVO vo = new SeckillActivityVO();
        BeanUtils.copyProperties(activity, vo);
        return Result.success(vo);
    }

    /**
     * 管理员创建秒杀活动
     */
    @Operation(summary = "创建秒杀活动", description = "仅管理员可操作")
    @PostMapping("/activity")
    public Result<Void> add(@RequestBody SeckillActivity activity) {
        AuthUtil.requireAdmin();
        seckillActivityService.add(activity, AuthUtil.getUserId());
        return Result.success("创建秒杀活动成功", null);
    }

    /**
     * 管理员更新秒杀活动
     */
    @Operation(summary = "更新秒杀活动", description = "仅管理员可操作")
    @PutMapping("/activity")
    public Result<Void> update(@RequestBody SeckillActivity activity) {
        AuthUtil.requireAdmin();
        seckillActivityService.update(activity);
        return Result.success("更新秒杀活动成功", null);
    }

    /**
     * 管理员上架活动并预热Redis库存
     */
    @Operation(summary = "上架活动并预热Redis库存", description = "仅管理员可操作")
    @PutMapping("/activity/{id}/online")
    public Result<Void> online(@PathVariable Long id) {
        AuthUtil.requireAdmin();
        seckillActivityService.online(id);
        return Result.success("活动已上架并预热库存", null);
    }

    /**
     * 管理员下架活动
     */
    @Operation(summary = "下架活动", description = "仅管理员可操作")
    @PutMapping("/activity/{id}/offline")
    public Result<Void> offline(@PathVariable Long id) {
        AuthUtil.requireAdmin();
        seckillActivityService.offline(id);
        return Result.success("活动已下架", null);
    }

    /**
     * 管理员手动预热Redis库存
     */
    @Operation(summary = "手动预热Redis库存", description = "仅管理员可操作")
    @PostMapping("/activity/{id}/preheat")
    public Result<Void> preheat(@PathVariable Long id) {
        AuthUtil.requireAdmin();
        seckillActivityService.preheat(id);
        return Result.success("预热成功", null);
    }

    /**
     * 用户抢秒杀券
     */
    @Operation(summary = "用户抢秒杀券")
    @PostMapping("/{activityId}")
    public Result<Void> seckill(@PathVariable Long activityId) {
        seckillActivityService.seckill(activityId, AuthUtil.getUserId());
        return Result.success("抢券成功，优惠券将在生效时间后可用", null);
    }
}