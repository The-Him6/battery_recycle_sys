package com.battery.recycle.service;

import com.battery.recycle.constant.SystemConstants;
import com.battery.recycle.entity.SystemNotice;
import com.battery.recycle.entity.UserNoticeRead;
import com.battery.recycle.exception.BusinessException;
import com.battery.recycle.mapper.SystemNoticeMapper;
import com.battery.recycle.mapper.UserNoticeReadMapper;
import org.springframework.stereotype.Service;

import jakarta.annotation.Resource;
import java.util.List;

/**
 * 系统弹窗公告服务类
 */
@Service
public class SystemNoticeService {

    @Resource
    private SystemNoticeMapper systemNoticeMapper;

    @Resource
    private UserNoticeReadMapper userNoticeReadMapper;

    /**
     * 根据ID查询公告
     */
    public SystemNotice getById(Long id) {
        SystemNotice notice = systemNoticeMapper.getById(id);
        if (notice == null) {
            throw new BusinessException(SystemConstants.NOTICE_NOT_FOUND);
        }
        return notice;
    }

    /**
     * 管理员查询全部公告
     */
    public List<SystemNotice> listAll() {
        return systemNoticeMapper.listAll();
    }

    /**
     * 用户查询当前有效且未读的弹窗公告
     */
    public List<SystemNotice> listActiveUnread(Long userId) {
        return systemNoticeMapper.listActiveUnread(userId);
    }

    /**
     * 管理员新增公告，默认草稿状态
     */
    public void add(SystemNotice notice, Long adminId) {
        if (notice.getStatus() == null) {
            notice.setStatus(SystemConstants.NOTICE_STATUS_DRAFT);
        }
        notice.setCreateAdminId(adminId);
        systemNoticeMapper.insert(notice);
    }

    /**
     * 管理员更新公告
     */
    public void update(SystemNotice notice) {
        if (notice.getId() == null || systemNoticeMapper.getById(notice.getId()) == null) {
            throw new BusinessException(SystemConstants.NOTICE_NOT_FOUND);
        }
        systemNoticeMapper.update(notice);
    }

    /**
     * 标记公告已读，重复点击由数据库唯一索引保证幂等
     */
    public void markRead(Long noticeId, Long userId) {
        if (systemNoticeMapper.getById(noticeId) == null) {
            throw new BusinessException(SystemConstants.NOTICE_NOT_FOUND);
        }
        UserNoticeRead read = new UserNoticeRead();
        read.setNoticeId(noticeId);
        read.setUserId(userId);
        userNoticeReadMapper.insert(read);
    }
}
