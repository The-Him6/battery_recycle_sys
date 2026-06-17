package com.battery.recycle.service;

import jakarta.annotation.Resource;

import com.battery.recycle.entity.UserPoints;
import com.battery.recycle.mapper.UserPointsMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * 用户积分服务类
 */
@Service
public class UserPointsService {

    @Resource
    private UserPointsMapper userPointsMapper;

    /**
     * 根据用户ID查询积分
     */
    public UserPoints getByUserId(Long userId) {
        UserPoints userPoints = userPointsMapper.getByUserId(userId);
        if (userPoints == null) {
            // 如果不存在，创建初始积分记录
            userPoints = new UserPoints();
            userPoints.setUserId(userId);
            userPoints.setTotalPoints(0);
            userPoints.setAvailablePoints(0);
            userPoints.setUsedPoints(0);
            userPointsMapper.insert(userPoints);
        }
        return userPoints;
    }

    /**
     * 增加积分
     */
    @Transactional(rollbackFor = Exception.class)
    public void addPoints(Long userId, Integer points) {
        // 确保用户积分记录存在
        getByUserId(userId);
        // 增加积分
        userPointsMapper.addPoints(userId, points);
    }

    /**
     * 扣减积分
     */
    @Transactional(rollbackFor = Exception.class)
    public boolean deductPoints(Long userId, Integer points) {
        UserPoints userPoints = getByUserId(userId);
        if (userPoints.getAvailablePoints() < points) {
            return false;
        }
        int result = userPointsMapper.deductPoints(userId, points);
        return result > 0;
    }

    /**
     * 更新积分
     */
    public void update(UserPoints userPoints) {
        userPointsMapper.update(userPoints);
    }
}




































