package com.battery.recycle.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 回收订单实体类
 */
@Data
public class RecycleOrder implements Serializable {
    
    private static final long serialVersionUID = 1L;
    
    /**
     * 订单ID
     */
    private Long id;
    
    /**
     * 订单编号
     */
    private String orderNumber;
    
    /**
     * 用户ID
     */
    private Long userId;
    
    /**
     * 回收电池总数量
     */
    private Integer totalCount;
    
    /**
     * 获得总积分
     */
    private Integer totalPoints;
    
    /**
     * 回收地址
     */
    private String recycleAddress;
    
    /**
     * 联系电话
     */
    private String contactPhone;
    
    /**
     * 订单状态：0-待处理，1-处理中，2-已完成，3-已取消
     */
    private Integer orderStatus;
    
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

