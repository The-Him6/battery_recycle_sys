package com.battery.recycle.exception;

import lombok.Getter;

/**
 * 业务异常基类
 */
@Getter
public class CommonException extends RuntimeException {

    private final int code;

    public CommonException(String message) {
        super(message);
        this.code = 500;
    }

    public CommonException(String message, int code) {
        super(message);
        this.code = code;
    }
}
