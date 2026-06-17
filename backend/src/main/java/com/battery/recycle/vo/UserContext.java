package com.battery.recycle.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 当前登录用户上下文，只保存本次请求需要的身份信息。
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class UserContext {

    /**
     * 当前登录用户ID。
     */
    private Long userId;

    /**
     * 当前登录用户名。
     */
    private String username;

    /**
     * 当前登录用户角色。
     */
    private Integer role;

    /**
     * 当前JWT编号，用于退出登录时删除Redis登录态。
     */
    private String jti;
}
