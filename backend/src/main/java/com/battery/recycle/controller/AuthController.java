package com.battery.recycle.controller;

import com.battery.recycle.common.Result;
import com.battery.recycle.constant.SystemConstants;
import com.battery.recycle.dto.ForgotPasswordDTO;
import com.battery.recycle.dto.LoginDTO;
import com.battery.recycle.dto.RegisterDTO;
import com.battery.recycle.service.AuthService;
import com.battery.recycle.vo.LoginVO;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * 认证控制器
 */
@RestController
@RequestMapping("/auth")
public class AuthController {
    
    @Autowired
    private AuthService authService;
    
    /**
     * 用户注册
     */
    @PostMapping("/register")
    public Result<Void> register(@Valid @RequestBody RegisterDTO dto) {
        authService.register(dto);
        return Result.success(SystemConstants.USER_REGISTER_SUCCESS, null);
    }
    
    /**
     * 用户登录
     */
    @PostMapping("/login")
    public Result<LoginVO> login(@Valid @RequestBody LoginDTO dto) {
        LoginVO loginVO = authService.login(dto);
        return Result.success(SystemConstants.USER_LOGIN_SUCCESS, loginVO);
    }

    /**
     * 忘记密码
     */
    @PostMapping("/forgot-password")
    public Result<Void> forgotPassword(@Valid @RequestBody ForgotPasswordDTO dto) {
        authService.forgotPassword(dto);
        return Result.success(SystemConstants.USER_PASSWORD_RESET_SUCCESS, null);
    }
}

