package com.battery.recycle.service;

import com.battery.recycle.constant.SystemConstants;
import com.battery.recycle.dto.ForgotPasswordDTO;
import com.battery.recycle.dto.LoginDTO;
import com.battery.recycle.dto.RegisterDTO;
import com.battery.recycle.entity.User;
import com.battery.recycle.exception.BusinessException;
import com.battery.recycle.mapper.UserMapper;
import com.battery.recycle.util.JwtUtil;
import com.battery.recycle.util.Md5Util;
import com.battery.recycle.vo.LoginVO;
import com.battery.recycle.vo.UserVO;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * 认证服务类
 */
@Service
public class AuthService {
    
    @Autowired
    private UserMapper userMapper;

    @Autowired
    private JwtUtil jwtUtil;
    
    /**
     * 用户注册
     */
    public void register(RegisterDTO dto) {
        // 检查用户名是否已存在
        User existUser = userMapper.getByUsername(dto.getUsername());
        if (existUser != null) {
            throw new BusinessException(SystemConstants.USER_ALREADY_EXISTS);
        }
        
        // 创建用户
        User user = new User();
        user.setUsername(dto.getUsername());
        user.setPassword(Md5Util.encrypt(dto.getPassword()));
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
            throw new BusinessException(SystemConstants.USER_NOT_FOUND);
        }
        
        // 验证密码
        String encryptedPassword = Md5Util.encrypt(dto.getPassword());
        if (!encryptedPassword.equals(user.getPassword())) {
            throw new BusinessException(SystemConstants.USER_PASSWORD_ERROR);
        }
        
        // 检查用户状态
        if (user.getStatus().equals(SystemConstants.STATUS_DISABLED)) {
            throw new BusinessException(SystemConstants.USER_DISABLED);
        }
        
        // 生成Token
        String token = jwtUtil.generateToken(user.getId(), user.getUsername(), user.getRole());
        
        // 构建用户信息VO
        UserVO userVO = new UserVO();
        BeanUtils.copyProperties(user, userVO);
        
        return new LoginVO(token, userVO);
    }

    /**
     * 忘记密码
     */
    public void forgotPassword(ForgotPasswordDTO dto) {
        User user = userMapper.getByUsername(dto.getUsername());
        if (user == null) {
            throw new BusinessException(SystemConstants.USER_NOT_FOUND);
        }
        if (user.getPhone() == null || !user.getPhone().equals(dto.getPhone())) {
            throw new BusinessException(SystemConstants.USER_PHONE_MISMATCH);
        }

        int updated = userMapper.resetPasswordByUsernameAndPhone(
                dto.getUsername(),
                dto.getPhone(),
                Md5Util.encrypt("123456")
        );
        if (updated == 0) {
            throw new BusinessException(SystemConstants.OPERATION_FAILED);
        }
    }
}

