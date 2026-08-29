package com.battery.recycle.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import java.time.LocalDateTime;
/**
 * ExchangeRecordVO视图对象
 */
@Data
public class ExchangeRecordVO {
    private Long id;
    private Long userId;
    private Long productId;
    private String productName;
    private Integer pointsUsed;
    private Integer quantity;
    private Integer exchangeStatus;
    private String shippingAddress;
    private String contactPhone;
    private String remark;
    private Integer exchangeType;
    private Long couponId;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private LocalDateTime createTime;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private LocalDateTime updateTime;
}