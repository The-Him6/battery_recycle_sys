package com.battery.recycle.controller;

import com.battery.recycle.common.Result;
import com.battery.recycle.constant.SystemConstants;
import com.battery.recycle.entity.ExchangeRecord;
import com.battery.recycle.entity.UserPoints;
import com.battery.recycle.exception.ForbiddenException;
import com.battery.recycle.service.IExchangeRecordService;
import com.battery.recycle.service.IUserPointsService;
import com.battery.recycle.util.AuthUtil;
import com.battery.recycle.vo.ExchangeRecordVO;
import com.battery.recycle.vo.UserPointsVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.BeanUtils;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 兑换记录控制器
 */
@Tag(name = "兑换记录管理", description = "积分兑换记录查询与用户积分信息")
@RestController
@RequestMapping("/exchange-record")
@RequiredArgsConstructor
public class ExchangeRecordController {

        private final IExchangeRecordService exchangeRecordService;

        private final IUserPointsService userPointsService;

    /**
     * 获取用户积分信息
     */
    @Operation(summary = "获取用户积分信息")
    @GetMapping("/points")
    public Result<UserPointsVO> getUserPoints() {
        Long userId = AuthUtil.getUserId();
        UserPoints userPoints = userPointsService.getByUserId(userId);
        UserPointsVO vo = new UserPointsVO();
        BeanUtils.copyProperties(userPoints, vo);
        return Result.success(vo);
    }

    /**
     * 根据ID查询记录
     */
    @Operation(summary = "根据ID查询记录", description = "普通用户只能查看自己的记录")
    @GetMapping("/{id}")
    public Result<ExchangeRecordVO> getById(@PathVariable Long id) {
        Long userId = AuthUtil.getUserId();
        Integer role = AuthUtil.getRole();

        ExchangeRecord record = exchangeRecordService.getById(id);

        // 普通用户只能查看自己的记录
        if (!SystemConstants.ROLE_ADMIN.equals(role) && !record.getUserId().equals(userId)) {
            throw new ForbiddenException(SystemConstants.PERMISSION_DENIED);
        }

        ExchangeRecordVO vo = new ExchangeRecordVO();
        BeanUtils.copyProperties(record, vo);
        return Result.success(vo);
    }

    /**
     * 查询所有记录（管理员）
     */
    @Operation(summary = "查询所有记录", description = "仅管理员可操作")
    @GetMapping("/list")
    public Result<List<ExchangeRecordVO>> listAll() {
        AuthUtil.requireAdmin();
        List<ExchangeRecord> list = exchangeRecordService.listAll();
        List<ExchangeRecordVO> voList = new ArrayList<>();
        for (ExchangeRecord item : list) {
            ExchangeRecordVO vo = new ExchangeRecordVO();
            BeanUtils.copyProperties(item, vo);
            voList.add(vo);
        }
        return Result.success(voList);
    }

    /**
     * 查询我的兑换记录
     */
    @Operation(summary = "查询我的兑换记录")
    @GetMapping("/my")
    public Result<List<ExchangeRecordVO>> listMyRecords() {
        Long userId = AuthUtil.getUserId();
        List<ExchangeRecord> list = exchangeRecordService.listByUserId(userId);
        List<ExchangeRecordVO> voList = new ArrayList<>();
        for (ExchangeRecord item : list) {
            ExchangeRecordVO vo = new ExchangeRecordVO();
            BeanUtils.copyProperties(item, vo);
            voList.add(vo);
        }
        return Result.success(voList);
    }

    /**
     * 分页查询记录（管理员）
     */
    @Operation(summary = "分页查询记录", description = "仅管理员可操作")
    @GetMapping("/page")
    public Result<Map<String, Object>> listByPage(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size) {
        AuthUtil.requireAdmin();

        List<ExchangeRecord> list = exchangeRecordService.listByPage(page, size);
        List<ExchangeRecordVO> voList = new ArrayList<>();
        for (ExchangeRecord item : list) {
            ExchangeRecordVO vo = new ExchangeRecordVO();
            BeanUtils.copyProperties(item, vo);
            voList.add(vo);
        }
        Integer total = exchangeRecordService.count();

        Map<String, Object> result = new HashMap<>();
        result.put("list", voList);
        result.put("total", total);
        result.put("page", page);
        result.put("size", size);

        return Result.success(result);
    }

    /**
     * 创建兑换记录
     */
    @Operation(summary = "创建兑换记录", description = "使用当前登录用户积分进行兑换")
    @PostMapping
    public Result<Void> createExchange(@RequestBody ExchangeRecord record) {
        Long userId = AuthUtil.getUserId();
        record.setUserId(userId);
        exchangeRecordService.createExchange(record);
        return Result.success("兑换成功", null);
    }

    /**
     * 更新兑换状态（管理员）
     */
    @Operation(summary = "更新兑换状态", description = "仅管理员可操作")
    @PutMapping("/{id}/status")
    public Result<Void> updateStatus(@PathVariable Long id, @RequestBody Map<String, Integer> params) {
        AuthUtil.requireAdmin();

        Integer status = params.get("status");
        exchangeRecordService.updateStatus(id, status);
        return Result.success("更新状态成功", null);
    }
}