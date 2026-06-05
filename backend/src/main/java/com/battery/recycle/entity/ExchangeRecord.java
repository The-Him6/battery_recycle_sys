package com.battery.recycle.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 积分兑换记录实体类
 */
@Data
public class ExchangeRecord implements Serializable {
    
    private static final long serialVersionUID = 1L;
    
    /**
     * 兑换记录ID
     */
    private Long id;
    
    /**
     * 用户ID
     */
    private Long userId;
    
    /**
     * 商品ID
     */
    private Long productId;
    
    /**
     * 商品名称
     */
    private String productName;
    
    /**
     * 使用积分
     */
    private Integer pointsUsed;
    
    /**
     * 兑换数量
     */
    private Integer quantity;
    
    /**
     * 兑换状态：0-待发货，1-已发货，2-已完成
     */
    private Integer exchangeStatus;
    
    /**
     * 收货地址
     */
    private String shippingAddress;
    
    /**
     * 联系电话
     */
    private String contactPhone;
    
    /**
     * 备注
     */
    private String remark;
    
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

