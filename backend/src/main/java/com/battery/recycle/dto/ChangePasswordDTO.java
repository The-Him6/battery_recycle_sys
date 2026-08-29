package com.battery.recycle.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.Data;

/**
 * 修改密码DTO
 */
@Data
public class ChangePasswordDTO {

    @NotBlank(message = "原密码不能为空")
    private String oldPassword;

    @NotBlank(message = "新密码不能为空")
    @Pattern(regexp = "^[A-Za-z0-9.!]{6,20}$", message = "密码只能包含大小写字母、数字和 . !，长度6-20位")
    private String newPassword;
}





