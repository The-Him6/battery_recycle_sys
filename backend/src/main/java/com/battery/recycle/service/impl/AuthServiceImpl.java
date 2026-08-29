package com.battery.recycle.service.impl;

import com.battery.recycle.constant.SystemConstants;
import com.battery.recycle.dto.ForgotPasswordDTO;
import com.battery.recycle.dto.LoginDTO;
import com.battery.recycle.dto.RegisterDTO;
import com.battery.recycle.entity.User;
import com.battery.recycle.exception.BadRequestException;
import com.battery.recycle.exception.DbException;
import com.battery.recycle.exception.UnauthorizedException;
import com.battery.recycle.mapper.UserMapper;
import com.battery.recycle.service.IAuthService;
import com.battery.recycle.service.ILoginStateService;
import com.battery.recycle.util.JwtUtil;
import com.battery.recycle.vo.LoginVO;
import com.battery.recycle.vo.UserVO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.util.DigestUtils;

import java.nio.charset.StandardCharsets;

import java.util.UUID;

/**
 * 认证服务类
 */
@Service("authService")
@RequiredArgsConstructor
public class AuthServiceImpl implements IAuthService {
    
        private final UserMapper userMapper;

        private final JwtUtil jwtUtil;

        private final ILoginStateService loginStateService;
    
    /**
     * 用户注册
     */
    public void register(RegisterDTO dto) {
        // 检查用户名是否已存在
        User existUser = userMapper.getByUsername(dto.getUsername());
        if (existUser != null) {
            throw new BadRequestException(SystemConstants.USER_ALREADY_EXISTS);
        }
        
        // 创建用户
        User user = new User();
        user.setUsername(dto.getUsername());
        user.setPassword(DigestUtils.md5DigestAsHex(dto.getPassword().getBytes(StandardCharsets.UTF_8)));
        user.setNickname(dto.getNickname() != null ? dto.getNickname() : dto.getUsername());
        user.setPhone(dto.getPhone());
        user.setEmail(dto.getEmail());
        user.setRole(SystemConstants.ROLE_USER);
        user.setStatus(SystemConstants.STATUS_NORMAL);
        
        userMapper.insert(user);
    }
    
    /**
     * 用户登录
     */
    public LoginVO login(LoginDTO dto) {
        // 查询用户
        User user = userMapper.getByUsername(dto.getUsername());
        if (user == null) {
            throw new UnauthorizedException(SystemConstants.USER_NOT_FOUND);
        }
        
        // 验证密码
        String encryptedPassword = DigestUtils.md5DigestAsHex(dto.getPassword().getBytes(StandardCharsets.UTF_8));
        if (!encryptedPassword.equals(user.getPassword())) {
            throw new UnauthorizedException(SystemConstants.USER_PASSWORD_ERROR);
        }
        
        // 检查用户状态
        if (user.getStatus().equals(SystemConstants.STATUS_DISABLED)) {
            throw new UnauthorizedException(SystemConstants.USER_DISABLED);
        }
        
        // 构建用户信息VO
        UserVO userVO = new UserVO();
        BeanUtils.copyProperties(user, userVO);

        // 生成带jti的Token，并把jti写入Redis登录态
        String jti = UUID.randomUUID().toString();
        String token = jwtUtil.generateToken(user.getId(), user.getUsername(), user.getRole(), jti);
        loginStateService.saveLoginState(jti, userVO);
        
        return new LoginVO(token, userVO);
    }

    /**
     * 用户退出登录
     */
    public void logout(String jti) {
        loginStateService.removeLoginState(jti);
    }

    /**
     * 忘记密码
     */
    public void forgotPassword(ForgotPasswordDTO dto) {
        User user = userMapper.getByUsername(dto.getUsername());
        if (user == null) {
            throw new UnauthorizedException(SystemConstants.USER_NOT_FOUND);
        }
        if (user.getPhone() == null || !user.getPhone().equals(dto.getPhone())) {
            throw new BadRequestException(SystemConstants.USER_PHONE_MISMATCH);
        }

        int updated = userMapper.resetPasswordByUsernameAndPhone(
                dto.getUsername(),
                dto.getPhone(),
                DigestUtils.md5DigestAsHex("123456".getBytes(StandardCharsets.UTF_8))
        );
        if (updated == 0) {
            throw new DbException(SystemConstants.OPERATION_FAILED);
        }
    }
}
