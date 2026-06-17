package com.battery.recycle.controller;

import com.battery.recycle.util.AuthUtil;

import jakarta.annotation.Resource;

import com.battery.recycle.common.Result;
import com.battery.recycle.constant.SystemConstants;
import com.battery.recycle.service.StatisticsService;
import com.battery.recycle.vo.DashboardOverviewVO;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 统计控制器
 */
@RestController
@RequestMapping("/statistics")
public class StatisticsController {

    @Resource
    private StatisticsService statisticsService;

    /**
     * 获取管理员首页概览数字。
     */
    @GetMapping("/dashboard")
    public Result<DashboardOverviewVO> getDashboardOverview() {
        AuthUtil.requireAdmin();
        DashboardOverviewVO data = statisticsService.getDashboardOverview();
        return Result.success(SystemConstants.STATISTICS_QUERY_SUCCESS, data);
    }

    /**
     * 统计每种电池的回收数量
     */
    @GetMapping("/battery-type")
    public Result<List<Map<String, Object>>> countByBatteryType() {
        List<Map<String, Object>> data = statisticsService.countByBatteryType();
        return Result.success(SystemConstants.STATISTICS_QUERY_SUCCESS, data);
    }

    /**
     * 统计每日回收数量
     */
    @GetMapping("/date")
    public Result<List<Map<String, Object>>> countByDate(@RequestParam(required = false) Integer days) {
        List<Map<String, Object>> data = statisticsService.countByDate(days);
        return Result.success(SystemConstants.STATISTICS_QUERY_SUCCESS, data);
    }

    /**
     * 按月统计回收数量（近12个月）
     */
    @GetMapping("/monthly")
    public Result<List<Map<String, Object>>> countByMonth() {
        List<Map<String, Object>> data = statisticsService.countByMonth();
        return Result.success(SystemConstants.STATISTICS_QUERY_SUCCESS, data);
    }

    /**
     * 按年统计回收数量（全部年份）
     */
    @GetMapping("/yearly")
    public Result<List<Map<String, Object>>> countByYear() {
        List<Map<String, Object>> data = statisticsService.countByYear();
        return Result.success(SystemConstants.STATISTICS_QUERY_SUCCESS, data);
    }

    /**
     * 统计订单状态分布
     */
    @GetMapping("/order-status")
    public Result<List<Map<String, Object>>> countByOrderStatus() {
        List<Map<String, Object>> data = statisticsService.countByOrderStatus();
        return Result.success(SystemConstants.STATISTICS_QUERY_SUCCESS, data);
    }

    /**
     * 统计地区回收排行
     */
    @GetMapping("/city-rank")
    public Result<List<Map<String, Object>>> countByCity(@RequestParam(required = false) Integer limit) {
        List<Map<String, Object>> data = statisticsService.countByCity(limit);
        return Result.success(SystemConstants.STATISTICS_QUERY_SUCCESS, data);
    }

    /**
     * 获取综合统计数据
     */
    @GetMapping("/overview")
    public Result<Map<String, Object>> getOverview() {
        Map<String, Object> overview = new HashMap<>();
        overview.put("batteryTypeStats", statisticsService.countByBatteryType());
        overview.put("dateStats", statisticsService.countByDate(7));
        overview.put("orderStatusStats", statisticsService.countByOrderStatus());
        overview.put("cityRankStats", statisticsService.countByCity(5));
        return Result.success(SystemConstants.STATISTICS_QUERY_SUCCESS, overview);
    }

}
