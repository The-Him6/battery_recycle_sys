package com.battery.recycle.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import java.time.LocalDateTime;
/**
 * UserPointsVO视图对象
 */
@Data
public class UserPointsVO {
    private Long id;
    private Long userId;
    private Integer totalPoints;
    private Integer availablePoints;
    private Integer usedPoints;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private LocalDateTime createTime;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private LocalDateTime updateTime;
}