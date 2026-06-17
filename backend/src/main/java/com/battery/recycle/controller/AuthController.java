package com.battery.recycle.controller;

import com.battery.recycle.common.Result;
import com.battery.recycle.constant.SystemConstants;
import com.battery.recycle.dto.ForgotPasswordDTO;
import com.battery.recycle.dto.LoginDTO;
import com.battery.recycle.dto.RegisterDTO;
import com.battery.recycle.service.AuthService;
import com.battery.recycle.util.AuthUtil;
import com.battery.recycle.vo.LoginVO;
import jakarta.annotation.Resource;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 认证控制器
 */
@RestController
@RequestMapping("/auth")
public class AuthController {
    
    @Resource
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
     * 用户退出登录
     */
    @PostMapping("/logout")
    public Result<Void> logout() {
        authService.logout(AuthUtil.getJti());
        return Result.success(SystemConstants.USER_LOGOUT_SUCCESS, null);
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
