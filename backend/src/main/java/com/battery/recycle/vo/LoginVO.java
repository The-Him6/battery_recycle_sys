package com.battery.recycle.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 登录响应VO
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class LoginVO {
    
    /**
     * JWT Token
     */
    private String token;
    
    /**
     * 用户信息
     */
    private UserVO userInfo;
}

