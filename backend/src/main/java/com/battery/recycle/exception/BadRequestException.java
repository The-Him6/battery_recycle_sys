package com.battery.recycle.exception;

/**
 * 参数校验异常
 */
public class BadRequestException extends CommonException {

    public BadRequestException(String message) {
        super(message, 400);
    }
}
