package com.battery.recycle.service;

import com.battery.recycle.common.PageRequest;
import com.battery.recycle.common.PageResult;
import com.battery.recycle.entity.RecycleDetail;
import com.battery.recycle.entity.RecycleOrder;

import java.util.List;

/**
 * 回收订单服务接口。
 */
public interface IRecycleOrderService {

    RecycleOrder getById(Long id);

    List<RecycleOrder> listAll();

    PageResult<RecycleOrder> getOrderPage(PageRequest pageRequest);

    List<RecycleOrder> listByUserId(Long userId);

    List<RecycleDetail> getOrderDetails(Long orderId);

    void createOrder(RecycleOrder order, List<RecycleDetail> details);

    void updateStatus(Long id, Integer status);

    void cancelOrder(Long id, Long userId);

    PageResult<RecycleOrder> searchOrders(String address, String startDate, String endDate,
                                          Integer orderStatus, PageRequest pageRequest);

    List<RecycleOrder> searchMyOrders(Long userId, String address, String startDate, String endDate);
}
