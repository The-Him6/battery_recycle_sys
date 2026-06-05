package com.battery.recycle.controller;

import com.battery.recycle.common.PageRequest;
import com.battery.recycle.common.PageResult;
import com.battery.recycle.common.Result;
import com.battery.recycle.constant.SystemConstants;
import com.battery.recycle.dto.CreateOrderDTO;
import com.battery.recycle.entity.RecycleDetail;
import com.battery.recycle.entity.RecycleOrder;
import com.battery.recycle.exception.BusinessException;
import com.battery.recycle.service.RecycleOrderService;
import com.battery.recycle.vo.OrderVO;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 回收订单控制器
 */
@RestController
@RequestMapping("/order")
public class RecycleOrderController {

    @Autowired
    private RecycleOrderService recycleOrderService;

    /**
     * 根据ID查询订单
     */
    @GetMapping("/{id}")
    public Result<OrderVO> getById(@PathVariable Long id, HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        Integer role = (Integer) request.getAttribute("role");

        RecycleOrder order = recycleOrderService.getById(id);

        // 普通用户只能查看自己的订单
        if (!role.equals(SystemConstants.ROLE_ADMIN) && !order.getUserId().equals(userId)) {
            throw new BusinessException(SystemConstants.PERMISSION_DENIED);
        }

        // 查询订单明细
        List<RecycleDetail> details = recycleOrderService.getOrderDetails(id);

        OrderVO vo = new OrderVO();
        BeanUtils.copyProperties(order, vo);
        vo.setDetails(details);

        return Result.success(vo);
    }

    /**
     * 查询所有订单（管理员）
     */
    @GetMapping("/list")
    public Result<List<RecycleOrder>> listAll(HttpServletRequest request) {
        Integer role = (Integer) request.getAttribute("role");
        if (!role.equals(SystemConstants.ROLE_ADMIN)) {
            throw new BusinessException(SystemConstants.ADMIN_ONLY);
        }
        List<RecycleOrder> list = recycleOrderService.listAll();
        return Result.success(list);
    }

    /**
     * 分页查询订单列表（管理员）
     */
    @GetMapping("/page")
    public Result<PageResult<RecycleOrder>> getOrderPage(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "20") Integer pageSize,
            @RequestParam(required = false) String address,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate,
            @RequestParam(required = false) Integer orderStatus,
            HttpServletRequest request) {
        Integer role = (Integer) request.getAttribute("role");
        if (!role.equals(SystemConstants.ROLE_ADMIN)) {
            throw new BusinessException(SystemConstants.ADMIN_ONLY);
        }

        PageRequest pageRequest = new PageRequest();
        pageRequest.setPageNum(pageNum);
        pageRequest.setPageSize(pageSize);

        PageResult<RecycleOrder> pageResult;
        // 如果有搜索条件，使用搜索方法
        if ((address != null && !address.isEmpty()) ||
                (startDate != null && !startDate.isEmpty()) ||
                (endDate != null && !endDate.isEmpty()) ||
                orderStatus != null) {
            pageResult = recycleOrderService.searchOrders(address, startDate, endDate, orderStatus, pageRequest);
        } else {
            pageResult = recycleOrderService.getOrderPage(pageRequest);
        }

        return Result.success(pageResult);
    }

    /**
     * 查询我的订单
     */
    @GetMapping("/my")
    public Result<List<RecycleOrder>> listMyOrders(
            @RequestParam(required = false) String address,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate,
            HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");

        List<RecycleOrder> list;
        // 如果有搜索条件，使用搜索方法
        if ((address != null && !address.isEmpty()) ||
                (startDate != null && !startDate.isEmpty()) ||
                (endDate != null && !endDate.isEmpty())) {
            list = recycleOrderService.searchMyOrders(userId, address, startDate, endDate);
        } else {
            list = recycleOrderService.listByUserId(userId);
        }

        return Result.success(list);
    }

    /**
     * 创建订单
     */
    @PostMapping
    public Result<Void> createOrder(@RequestBody CreateOrderDTO dto, HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");

        // 构建订单对象
        RecycleOrder order = new RecycleOrder();
        order.setUserId(userId);
        order.setRecycleAddress(dto.getRecycleAddress());
        order.setContactPhone(dto.getContactPhone());
        order.setRemark(dto.getRemark());

        // 构建订单明细列表
        List<RecycleDetail> details = new ArrayList<>();
        for (CreateOrderDTO.OrderDetailDTO detailDTO : dto.getDetails()) {
            RecycleDetail detail = new RecycleDetail();
            detail.setBatteryTypeId(detailDTO.getBatteryTypeId());
            detail.setBatteryCount(detailDTO.getBatteryCount());
            details.add(detail);
        }

        recycleOrderService.createOrder(order, details);
        return Result.success(SystemConstants.ORDER_CREATE_SUCCESS, null);
    }

    /**
     * 更新订单状态（管理员）
     */
    @PutMapping("/{id}/status")
    public Result<Void> updateStatus(@PathVariable Long id, @RequestBody Map<String, Integer> params,
            HttpServletRequest request) {
        Integer role = (Integer) request.getAttribute("role");
        if (!role.equals(SystemConstants.ROLE_ADMIN)) {
            throw new BusinessException(SystemConstants.ADMIN_ONLY);
        }

        Integer status = params.get("status");
        recycleOrderService.updateStatus(id, status);
        return Result.success(SystemConstants.ORDER_UPDATE_SUCCESS, null);
    }

    /**
     * 取消订单
     */
    @PutMapping("/{id}/cancel")
    public Result<Void> cancelOrder(@PathVariable Long id, HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        recycleOrderService.cancelOrder(id, userId);
        return Result.success(SystemConstants.ORDER_CANCEL_SUCCESS, null);
    }
}
