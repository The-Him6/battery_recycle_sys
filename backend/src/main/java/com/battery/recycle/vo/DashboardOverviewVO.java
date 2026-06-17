package com.battery.recycle.vo;

import lombok.Data;

/**
 * 管理员首页数据概览VO，只承载卡片展示需要的数字。
 */
@Data
public class DashboardOverviewVO {

    /**
     * 用户总数。
     */
    private Long userCount;

    /**
     * 订单总数。
     */
    private Long orderCount;

    /**
     * 累计回收电池数量。
     */
    private Long batteryCount;

    /**
     * 今日回收电池数量。
     */
    private Long todayCount;
}
