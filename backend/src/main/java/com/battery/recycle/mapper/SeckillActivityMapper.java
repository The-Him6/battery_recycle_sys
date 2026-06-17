package com.battery.recycle.mapper;

import com.battery.recycle.entity.SeckillActivity;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 秒杀活动Mapper接口
 */
@Mapper
public interface SeckillActivityMapper {

    /**
     * 根据ID查询活动
     */
    SeckillActivity getById(@Param("id") Long id);

    /**
     * 查询全部活动
     */
    List<SeckillActivity> listAll();

    /**
     * 查询已上架活动
     */
    List<SeckillActivity> listOnline();

    /**
     * 新增活动
     */
    int insert(SeckillActivity activity);

    /**
     * 更新活动
     */
    int update(SeckillActivity activity);

    /**
     * 增加已售数量，用数据库条件兜底防超卖
     */
    int increaseSold(@Param("id") Long id);
}
