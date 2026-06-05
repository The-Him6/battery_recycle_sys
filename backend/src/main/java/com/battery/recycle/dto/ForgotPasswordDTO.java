package com.battery.recycle.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

/**
 * 忘记密码DTO
 */
@Data
public class ForgotPasswordDTO {

    @NotBlank(message = "用户名不能为空")
    private String username;

    @NotBlank(message = "手机号不能为空")
    private String phone;
}





