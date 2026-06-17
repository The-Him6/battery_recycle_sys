package com.battery.recycle.controller;

import com.battery.recycle.util.AuthUtil;

import com.battery.recycle.common.Result;
import com.battery.recycle.constant.SystemConstants;
import com.battery.recycle.entity.ExchangeRecord;
import com.battery.recycle.entity.UserPoints;
import com.battery.recycle.exception.BusinessException;
import com.battery.recycle.service.ExchangeRecordService;
import com.battery.recycle.service.UserPointsService;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 兑换记录控制器
 */
@RestController
@RequestMapping("/exchange-record")
public class ExchangeRecordController {

    @Resource
    private ExchangeRecordService exchangeRecordService;

    @Resource
    private UserPointsService userPointsService;

    /**
     * 获取用户积分信息
     */
    @GetMapping("/points")
    public Result<UserPoints> getUserPoints() {
        Long userId = AuthUtil.getUserId();
        UserPoints userPoints = userPointsService.getByUserId(userId);
        return Result.success(userPoints);
    }

    /**
     * 根据ID查询记录
     */
    @GetMapping("/{id}")
    public Result<ExchangeRecord> getById(@PathVariable Long id) {
        Long userId = AuthUtil.getUserId();
        Integer role = AuthUtil.getRole();

        ExchangeRecord record = exchangeRecordService.getById(id);

        // 普通用户只能查看自己的记录
        if (!role.equals(SystemConstants.ROLE_ADMIN) && !record.getUserId().equals(userId)) {
            throw new BusinessException(SystemConstants.PERMISSION_DENIED);
        }

        return Result.success(record);
    }

    /**
     * 查询所有记录（管理员）
     */
    @GetMapping("/list")
    public Result<List<ExchangeRecord>> listAll() {
        Integer role = AuthUtil.getRole();
        if (!role.equals(SystemConstants.ROLE_ADMIN)) {
            throw new BusinessException(SystemConstants.ADMIN_ONLY);
        }
        List<ExchangeRecord> list = exchangeRecordService.listAll();
        return Result.success(list);
    }

    /**
     * 查询我的兑换记录
     */
    @GetMapping("/my")
    public Result<List<ExchangeRecord>> listMyRecords() {
        Long userId = AuthUtil.getUserId();
        List<ExchangeRecord> list = exchangeRecordService.listByUserId(userId);
        return Result.success(list);
    }

    /**
     * 分页查询记录（管理员）
     */
    @GetMapping("/page")
    public Result<Map<String, Object>> listByPage(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size) {
        Integer role = AuthUtil.getRole();
        if (!role.equals(SystemConstants.ROLE_ADMIN)) {
            throw new BusinessException(SystemConstants.ADMIN_ONLY);
        }

        List<ExchangeRecord> list = exchangeRecordService.listByPage(page, size);
        Integer total = exchangeRecordService.count();

        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        result.put("total", total);
        result.put("page", page);
        result.put("size", size);

        return Result.success(result);
    }

    /**
     * 创建兑换记录
     */
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
    @PutMapping("/{id}/status")
    public Result<Void> updateStatus(@PathVariable Long id, @RequestBody Map<String, Integer> params) {
        Integer role = AuthUtil.getRole();
        if (!role.equals(SystemConstants.ROLE_ADMIN)) {
            throw new BusinessException(SystemConstants.ADMIN_ONLY);
        }

        Integer status = params.get("status");
        exchangeRecordService.updateStatus(id, status);
        return Result.success("更新状态成功", null);
    }
}




































