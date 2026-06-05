package com.battery.recycle.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import java.time.LocalDateTime;

/**
 * 用户信息VO（不包含密码）
 */
@Data
public class UserVO {
    
    private Long id;
    
    private String username;
    
    private String nickname;
    
    private String phone;
    
    private String email;
    
    private String avatar;
    
    private Integer role;
    
    private Integer status;
    
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private LocalDateTime createTime;
    
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private LocalDateTime updateTime;
}

