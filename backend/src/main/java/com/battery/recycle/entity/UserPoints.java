package com.battery.recycle.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 用户积分实体类
 */
@Data
public class UserPoints implements Serializable {
    
    private static final long serialVersionUID = 1L;
    
    /**
     * ID
     */
    private Long id;
    
    /**
     * 用户ID
     */
    private Long userId;
    
    /**
     * 总积分
     */
    private Integer totalPoints;
    
    /**
     * 可用积分
     */
    private Integer availablePoints;
    
    /**
     * 已使用积分
     */
    private Integer usedPoints;
    
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

