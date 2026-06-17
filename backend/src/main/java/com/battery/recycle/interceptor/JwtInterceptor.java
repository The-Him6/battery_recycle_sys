package com.battery.recycle.interceptor;

import com.battery.recycle.constant.SystemConstants;
import com.battery.recycle.exception.BusinessException;
import com.battery.recycle.service.LoginStateService;
import com.battery.recycle.util.JwtUtil;
import com.battery.recycle.util.UserHolder;
import com.battery.recycle.vo.UserContext;
import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

/**
 * JWT拦截器
 */
@Component
public class JwtInterceptor implements HandlerInterceptor {
    
    @Resource
    private JwtUtil jwtUtil;

    @Resource
    private LoginStateService loginStateService;
    
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
        
        // 验证Token是否过期
        if (!jwtUtil.validateToken(token)) {
            throw new BusinessException(401, SystemConstants.TOKEN_INVALID);
        }
        
        // 从Token中解析当前用户信息
        Long userId = jwtUtil.getUserIdFromToken(token);
        String username = jwtUtil.getUsernameFromToken(token);
        Integer role = jwtUtil.getRoleFromToken(token);
        String jti = jwtUtil.getJtiFromToken(token);

        // Redis中没有登录态时，说明该JWT已退出登录或被强制失效
        if (jti == null || !loginStateService.refreshLoginState(jti)) {
            throw new BusinessException(401, SystemConstants.TOKEN_INVALID);
        }
        
        // 将用户信息放入ThreadLocal，后续Controller和Service可直接读取当前登录用户
        UserHolder.save(new UserContext(userId, username, role, jti));
        
        return true;
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) {
        // Tomcat线程会复用，请求结束必须清理ThreadLocal，避免用户信息串到下一次请求
        UserHolder.remove();
    }
}

