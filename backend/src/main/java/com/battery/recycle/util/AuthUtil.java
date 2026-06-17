package com.battery.recycle.util;

import com.battery.recycle.constant.SystemConstants;
import com.battery.recycle.exception.BusinessException;
import com.battery.recycle.vo.UserContext;

/**
 * 登录用户工具类
 */
public class AuthUtil {

    /**
     * 从ThreadLocal获取当前用户ID
     */
    public static Long getUserId() {
        return getCurrentUser().getUserId();
    }

    /**
     * 从ThreadLocal获取当前用户角色
     */
    public static Integer getRole() {
        return getCurrentUser().getRole();
    }

    /**
     * 从ThreadLocal获取当前JWT编号
     */
    public static String getJti() {
        return getCurrentUser().getJti();
    }

    /**
     * 校验当前用户是否是管理员
     */
    public static void requireAdmin() {
        if (!SystemConstants.ROLE_ADMIN.equals(getRole())) {
            throw new BusinessException(SystemConstants.ADMIN_ONLY);
        }
    }

    /**
     * 获取当前登录用户上下文
     */
    public static UserContext getCurrentUser() {
        UserContext userContext = UserHolder.get();
        if (userContext == null) {
            throw new BusinessException(401, SystemConstants.TOKEN_INVALID);
        }
        return userContext;
    }

}
