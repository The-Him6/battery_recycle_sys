package com.battery.recycle.exception;

/**
 * 登录异常类
 */
public class UnauthorizedException extends CommonException {

    public UnauthorizedException(String message) {
        super(message, 401);
    }
}
