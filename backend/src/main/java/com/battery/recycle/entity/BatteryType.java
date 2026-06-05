package com.battery.recycle.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 电池种类实体类
 */
@Data
public class BatteryType implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 电池种类ID
     */
    private Long id;

    /**
     * 电池种类名称
     */
    private String typeName;

    /**
     * 种类描述
     */
    private String description;

    /**
     * 图标地址
     */
    private String icon;

    /**
     * 如何识别该类型电池
     */
    private String identificationGuide;

    /**
     * 回收积分（每个电池可获得的积分）
     */
    private Integer points;

    /**
     * 状态：0-禁用，1-启用
     */
    private Integer status;

    /**
     * 创建时间
     */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private LocalDateTime createTime;

    /**
     * 更新时间
     */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private LocalDateTime updateTime;
}
