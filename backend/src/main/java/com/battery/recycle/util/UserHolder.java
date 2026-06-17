package com.battery.recycle.util;

import com.battery.recycle.vo.UserContext;

/**
 * 当前登录用户ThreadLocal工具类。
 */
public class UserHolder {

    /**
     * ThreadLocal保存一次请求内的登录用户信息。
     */
    private static final ThreadLocal<UserContext> USER_THREAD_LOCAL = new ThreadLocal<>();

    /**
     * 保存当前请求用户信息。
     */
    public static void save(UserContext userContext) {
        USER_THREAD_LOCAL.set(userContext);
    }

    /**
     * 获取当前请求用户信息。
     */
    public static UserContext get() {
        return USER_THREAD_LOCAL.get();
    }

    /**
     * 清理当前线程用户信息，避免Tomcat线程复用导致用户信息串请求。
     */
    public static void remove() {
        USER_THREAD_LOCAL.remove();
    }
}
