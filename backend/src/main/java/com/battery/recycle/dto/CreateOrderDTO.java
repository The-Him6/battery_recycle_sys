package com.battery.recycle.dto;

import lombok.Data;
import java.util.List;

/**
 * 创建订单DTO
 */
@Data
public class CreateOrderDTO {
    
    /**
     * 回收地址
     */
    private String recycleAddress;
    
    /**
     * 联系电话
     */
    private String contactPhone;
    
    /**
     * 备注
     */
    private String remark;
    
    /**
     * 订单明细列表
     */
    private List<OrderDetailDTO> details;
    
    @Data
    public static class OrderDetailDTO {
        /**
         * 电池种类ID
         */
        private Long batteryTypeId;
        
        /**
         * 电池数量
         */
        private Integer batteryCount;
    }
}

