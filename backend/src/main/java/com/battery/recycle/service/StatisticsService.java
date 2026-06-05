package com.battery.recycle.service;

import com.battery.recycle.mapper.StatisticsMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * 统计服务类
 */
@Service
public class StatisticsService {

    @Autowired
    private StatisticsMapper statisticsMapper;

    /**
     * 统计每种电池的回收数量
     */
    public List<Map<String, Object>> countByBatteryType() {
        return statisticsMapper.countByBatteryType();
    }

    /**
     * 统计每日回收数量
     */
    public List<Map<String, Object>> countByDate(Integer days) {
        if (days == null || days <= 0) {
            days = 7; // 默认最近7天
        }
        return statisticsMapper.countByDate(days);
    }

    /**
     * 按月统计回收数量（近12个月）
     */
    public List<Map<String, Object>> countByMonth() {
        return statisticsMapper.countByMonth();
    }

    /**
     * 按年统计回收数量（全部年份）
     */
    public List<Map<String, Object>> countByYear() {
        return statisticsMapper.countByYear();
    }

    /**
     * 统计订单状态分布
     */
    public List<Map<String, Object>> countByOrderStatus() {
        return statisticsMapper.countByOrderStatus();
    }

    /**
     * 统计地区回收排行
     */
    public List<Map<String, Object>> countByCity(Integer limit) {
        if (limit == null || limit <= 0) {
            limit = 5; // 默认前5名
        }
        return statisticsMapper.countByCity(limit);
    }
}
