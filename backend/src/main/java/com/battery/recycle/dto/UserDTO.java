package com.battery.recycle.dto;

import lombok.Data;

/**
 * 用户信息更新DTO
 * 注意：不包含 role 字段，防止普通用户构造请求将自身提权为管理员
 */
@Data
public class UserDTO {

    /**
     * 用户ID
     */
    private Long id;

    /**
     * 密码
     */
    private String password;

    /**
     * 昵称
     */
    private String nickname;

    /**
     * 手机号
     */
    private String phone;

    /**
     * 邮箱
     */
    private String email;

    /**
     * 头像地址
     */
    private String avatar;

    /**
     * 状态：0-禁用，1-正常
     */
    private Integer status;
}
