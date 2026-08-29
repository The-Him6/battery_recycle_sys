package com.battery.recycle.exception;

/**
 * 权限异常类
 */
public class ForbiddenException extends CommonException {

    public ForbiddenException(String message) {
        super(message, 403);
    }
}
