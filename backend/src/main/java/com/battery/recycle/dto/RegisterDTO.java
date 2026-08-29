package com.battery.recycle.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.Data;

/**
 * 用户注册DTO
 */
@Data
public class RegisterDTO {
    
    @NotBlank(message = "用户名不能为空")
    private String username;
    
    @NotBlank(message = "密码不能为空")
    @Pattern(regexp = "^[A-Za-z0-9.!]{6,20}$", message = "密码只能包含大小写字母、数字和 . !，长度6-20位")
    private String password;
    
    private String nickname;
    
    @NotBlank(message = "手机号不能为空")
    private String phone;
    
    private String email;
}

