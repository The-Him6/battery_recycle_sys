package com.battery.recycle.mapper;

import com.battery.recycle.entity.UserNoticeRead;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

/**
 * 用户公告已读Mapper接口
 */
@Mapper
public interface UserNoticeReadMapper {

    /**
     * 根据公告和用户查询已读记录
     */
    UserNoticeRead getByNoticeAndUser(@Param("noticeId") Long noticeId, @Param("userId") Long userId);

    /**
     * 新增已读记录，重复时由数据库唯一索引兜底
     */
    int insert(UserNoticeRead read);
}
