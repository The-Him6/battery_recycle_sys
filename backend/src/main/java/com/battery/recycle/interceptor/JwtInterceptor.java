package com.battery.recycle.interceptor;

import com.battery.recycle.constant.SystemConstants;
import com.battery.recycle.exception.BusinessException;
import com.battery.recycle.util.JwtUtil;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

/**
 * JWT拦截器
 */
@Component
public class JwtInterceptor implements HandlerInterceptor {
    
    @Autowired
    private JwtUtil jwtUtil;
    
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
        // 跨域预检请求直接放行
        if ("OPTIONS".equals(request.getMethod())) {
            return true;
        }
        
        // 获取Token
        String token = request.getHeader("Authorization");
        if (token == null || token.isEmpty()) {
            throw new BusinessException(401, SystemConstants.TOKEN_MISSING);
        }
        
        // 去除Bearer前缀
        if (token.startsWith("Bearer ")) {
            token = token.substring(7);
        }
        
        // 验证Token
        if (!jwtUtil.validateToken(token)) {
            throw new BusinessException(401, SystemConstants.TOKEN_INVALID);
        }
        
        // 将用户信息存入请求属性
        Long userId = jwtUtil.getUserIdFromToken(token);
        String username = jwtUtil.getUsernameFromToken(token);
        Integer role = jwtUtil.getRoleFromToken(token);
        
        request.setAttribute("userId", userId);
        request.setAttribute("username", username);
        request.setAttribute("role", role);
        
        return true;
    }
}

