package com.battery.recycle.exception;

import com.battery.recycle.common.Result;
import com.battery.recycle.constant.SystemConstants;
import lombok.extern.slf4j.Slf4j;
import org.springframework.validation.BindException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

/**
 * 全局异常处理器
 */
@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {
    
    /**
     * 业务异常处理
     */
    @ExceptionHandler(BusinessException.class)
    public Result<?> handleBusinessException(BusinessException e) {
        log.error("业务异常：{}", e.getMessage());
        return Result.error(e.getCode(), e.getMessage());
    }
    
    /**
     * 参数校验异常处理
     */
    @ExceptionHandler({MethodArgumentNotValidException.class, BindException.class})
    public Result<?> handleValidException(Exception e) {
        String message = SystemConstants.PARAM_ERROR;
        if (e instanceof MethodArgumentNotValidException) {
            MethodArgumentNotValidException ex = (MethodArgumentNotValidException) e;
            if (ex.getBindingResult().hasErrors() && ex.getBindingResult().getFieldError() != null) {
                message = ex.getBindingResult().getFieldError().getDefaultMessage();
            }
        } else if (e instanceof BindException) {
            BindException ex = (BindException) e;
            if (ex.getBindingResult().hasErrors() && ex.getBindingResult().getFieldError() != null) {
                message = ex.getBindingResult().getFieldError().getDefaultMessage();
            }
        }
        log.error("参数校验异常：{}", message);
        return Result.error(400, message);
    }
    
    /**
     * 系统异常处理
     */
    @ExceptionHandler(Exception.class)
    public Result<?> handleException(Exception e) {
        log.error("系统异常：", e);
        return Result.error(SystemConstants.SYSTEM_ERROR);
    }
}

