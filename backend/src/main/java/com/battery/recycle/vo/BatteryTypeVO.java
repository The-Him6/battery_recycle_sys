package com.battery.recycle.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import java.time.LocalDateTime;
/**
 * BatteryTypeVO视图对象
 */
@Data
public class BatteryTypeVO {
    private Long id;
    private String typeName;
    private String description;
    private String icon;
    private String identificationGuide;
    private Integer points;
    private Integer status;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private LocalDateTime createTime;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private LocalDateTime updateTime;
}