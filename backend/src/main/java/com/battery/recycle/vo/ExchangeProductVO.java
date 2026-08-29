package com.battery.recycle.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import java.time.LocalDateTime;
/**
 * ExchangeProductVO视图对象
 */
@Data
public class ExchangeProductVO {
    private Long id;
    private String productName;
    private String brand;
    private String batteryModel;
    private Integer pointsRequired;
    private Integer stock;
    private String imageUrl;
    private String description;
    private Integer status;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private LocalDateTime createTime;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private LocalDateTime updateTime;
}