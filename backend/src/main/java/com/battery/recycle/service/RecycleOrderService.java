package com.battery.recycle.service;

import jakarta.annotation.Resource;

import com.battery.recycle.common.PageRequest;
import com.battery.recycle.common.PageResult;
import com.battery.recycle.constant.SystemConstants;
import com.battery.recycle.entity.BatteryType;
import com.battery.recycle.entity.RecycleDetail;
import com.battery.recycle.entity.RecycleOrder;
import com.battery.recycle.entity.User;
import com.battery.recycle.exception.BusinessException;
import com.battery.recycle.mapper.BatteryTypeMapper;
import com.battery.recycle.mapper.RecycleDetailMapper;
import com.battery.recycle.mapper.RecycleOrderMapper;
import com.battery.recycle.mapper.UserMapper;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

/**
 * 回收订单服务类
 */
@Service
public class RecycleOrderService {

    @Resource
    private RecycleOrderMapper recycleOrderMapper;

    @Resource
    private RecycleDetailMapper recycleDetailMapper;

    @Resource
    private BatteryTypeMapper batteryTypeMapper;

    @Resource
    private UserMapper userMapper;

    @Resource
    private UserPointsService userPointsService;

    /**
     * 根据ID查询订单
     */
    public RecycleOrder getById(Long id) {
        RecycleOrder order = recycleOrderMapper.getById(id);
        if (order == null) {
            throw new BusinessException(SystemConstants.ORDER_NOT_FOUND);
        }
        return order;
    }

    /**
     * 查询所有订单
     */
    public List<RecycleOrder> listAll() {
        return recycleOrderMapper.listAll();
    }

    /**
     * 分页查询订单列表
     */
    public PageResult<RecycleOrder> getOrderPage(PageRequest pageRequest) {
        // 开启分页
        PageHelper.startPage(pageRequest.getValidPageNum(), pageRequest.getValidPageSize());

        // 查询订单列表
        List<RecycleOrder> list = recycleOrderMapper.listAll();

        // 封装分页结果
        PageInfo<RecycleOrder> pageInfo = new PageInfo<>(list);
        return PageResult.of(pageInfo);
    }

    /**
     * 根据用户ID查询订单
     */
    public List<RecycleOrder> listByUserId(Long userId) {
        return recycleOrderMapper.listByUserId(userId);
    }

    /**
     * 查询订单明细
     */
    public List<RecycleDetail> getOrderDetails(Long orderId) {
        return recycleDetailMapper.listByOrderId(orderId);
    }

    /**
     * 创建订单
     */
    @Transactional(rollbackFor = Exception.class)
    public void createOrder(RecycleOrder order, List<RecycleDetail> details) {
        // 生成订单编号
        String orderNumber = generateOrderNumber(order.getUserId());
        order.setOrderNumber(orderNumber);

        // 计算总数量和总积分
        int totalCount = 0;
        int totalPoints = 0;

        for (RecycleDetail detail : details) {
            BatteryType batteryType = batteryTypeMapper.getById(detail.getBatteryTypeId());
            if (batteryType == null) {
                throw new BusinessException(SystemConstants.BATTERY_TYPE_NOT_FOUND);
            }

            int points = batteryType.getPoints() * detail.getBatteryCount();
            detail.setPoints(points);

            totalCount += detail.getBatteryCount();
            totalPoints += points;
        }

        order.setTotalCount(totalCount);
        order.setTotalPoints(totalPoints);
        order.setOrderStatus(SystemConstants.ORDER_STATUS_PENDING); // 设置为待处理状态

        // 插入订单
        recycleOrderMapper.insert(order);

        // 插入订单明细
        for (RecycleDetail detail : details) {
            detail.setOrderId(order.getId());
        }
        recycleDetailMapper.batchInsert(details);

        // 订单创建时不增加积分，等待管理员审核完成后再增加
    }

    /**
     * 更新订单状态
     */
    @Transactional(rollbackFor = Exception.class)
    public void updateStatus(Long id, Integer status) {
        RecycleOrder order = recycleOrderMapper.getById(id);
        if (order == null) {
            throw new BusinessException(SystemConstants.ORDER_NOT_FOUND);
        }

        Integer oldStatus = order.getOrderStatus();
        order.setOrderStatus(status);
        recycleOrderMapper.update(order);

        // 如果订单变为已完成状态，且之前不是已完成状态，给用户增加积分
        if (status.equals(SystemConstants.ORDER_STATUS_COMPLETED) &&
                !oldStatus.equals(SystemConstants.ORDER_STATUS_COMPLETED)) {
            userPointsService.addPoints(order.getUserId(), order.getTotalPoints());
        }
    }

    /**
     * 取消订单
     */
    public void cancelOrder(Long id, Long userId) {
        RecycleOrder order = recycleOrderMapper.getById(id);
        if (order == null) {
            throw new BusinessException(SystemConstants.ORDER_NOT_FOUND);
        }

        // 检查是否是订单所有者
        if (!order.getUserId().equals(userId)) {
            throw new BusinessException(SystemConstants.PERMISSION_DENIED);
        }

        // 只有待处理状态的订单可以取消
        if (!order.getOrderStatus().equals(SystemConstants.ORDER_STATUS_PENDING)) {
            throw new BusinessException(SystemConstants.ORDER_CANNOT_CANCEL);
        }

        order.setOrderStatus(SystemConstants.ORDER_STATUS_CANCELLED);
        recycleOrderMapper.update(order);
    }

    /**
     * 生成订单编号
     */
    private String generateOrderNumber(Long userId) {
        LocalDateTime now = LocalDateTime.now();
        String datePart = now.format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        String userPart = buildUserIdentifier(userId);
        int currentCount = recycleOrderMapper.countUserOrdersByDate(userId, now.toLocalDate().toString());
        String sequencePart = String.format("%03d", currentCount + 1);

        return "BR" + datePart + "-" + userPart + "-" + sequencePart;
    }

    private String buildUserIdentifier(Long userId) {
        if (userId == null) {
            return "U000";
        }

        User user = userMapper.getById(userId);
        if (user == null || user.getUsername() == null || user.getUsername().isEmpty()) {
            return "U" + String.format("%03d", userId % 1000);
        }

        String username = user.getUsername().trim().toUpperCase();
        String digits = username.replaceAll("\\D+", "");
        if (!digits.isEmpty()) {
            return "U" + digits;
        }

        return "U" + username.substring(0, Math.min(3, username.length()));
    }

    /**
     * 搜索订单（管理员）
     */
    public PageResult<RecycleOrder> searchOrders(String address, String startDate, String endDate,
            Integer orderStatus, PageRequest pageRequest) {
        int offset = (pageRequest.getValidPageNum() - 1) * pageRequest.getValidPageSize();

        List<RecycleOrder> list = recycleOrderMapper.searchOrders(address, startDate, endDate, orderStatus, null, offset,
                pageRequest.getValidPageSize());
        Integer total = recycleOrderMapper.countBySearch(address, startDate, endDate, orderStatus, null);

        PageResult<RecycleOrder> result = new PageResult<>();
        result.setTotal((long) total);
        result.setList(list);
        result.setPageNum(pageRequest.getValidPageNum());
        result.setPageSize(pageRequest.getValidPageSize());
        result.setPages((int) Math.ceil((double) total / pageRequest.getValidPageSize()));

        return result;
    }

    /**
     * 搜索我的订单（用户）
     */
    public List<RecycleOrder> searchMyOrders(Long userId, String address, String startDate, String endDate) {
        return recycleOrderMapper.searchOrders(address, startDate, endDate, null, userId, 0, 10000);
    }
}
