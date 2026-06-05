package com.battery.recycle.vo;

import com.battery.recycle.entity.RecycleDetail;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 订单详情VO
 */
@Data
public class OrderVO {
    
    private Long id;
    
    private String orderNumber;
    
    private Long userId;
    
    private Integer totalCount;
    
    private Integer totalPoints;
    
    private String recycleAddress;
    
    private String contactPhone;
    
    private Integer orderStatus;
    
    private String remark;
    
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private LocalDateTime createTime;
    
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private LocalDateTime updateTime;
    
    /**
     * 订单明细列表
     */
    private List<RecycleDetail> details;
}

