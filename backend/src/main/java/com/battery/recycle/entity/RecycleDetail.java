package com.battery.recycle.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 回收明细实体类
 */
@Data
public class RecycleDetail implements Serializable {
    
    private static final long serialVersionUID = 1L;
    
    /**
     * 明细ID
     */
    private Long id;
    
    /**
     * 订单ID
     */
    private Long orderId;
    
    /**
     * 电池种类ID
     */
    private Long batteryTypeId;
    
    /**
     * 电池数量
     */
    private Integer batteryCount;
    
    /**
     * 获得积分
     */
    private Integer points;
    
    /**
     * 创建时间
     */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private LocalDateTime createTime;
}

