package com.battery.recycle.service;

import com.battery.recycle.dto.ForgotPasswordDTO;
import com.battery.recycle.dto.LoginDTO;
import com.battery.recycle.dto.RegisterDTO;
import com.battery.recycle.vo.LoginVO;

/**
 * 认证服务接口。
 */
public interface IAuthService {

    void register(RegisterDTO dto);

    LoginVO login(LoginDTO dto);

    void logout(String jti);

    void forgotPassword(ForgotPasswordDTO dto);
}
