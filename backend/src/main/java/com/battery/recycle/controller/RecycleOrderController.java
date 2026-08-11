package com.battery.recycle.controller;

import com.battery.recycle.util.AuthUtil;

import jakarta.annotation.Resource;

import com.battery.recycle.common.PageRequest;
import com.battery.recycle.common.PageResult;
import com.battery.recycle.common.Result;
import com.battery.recycle.constant.SystemConstants;
import com.battery.recycle.dto.CreateOrderDTO;
import com.battery.recycle.entity.RecycleDetail;
import com.battery.recycle.entity.RecycleOrder;
import com.battery.recycle.exception.BusinessException;
import com.battery.recycle.service.IRecycleOrderService;
import com.battery.recycle.vo.OrderVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.BeanUtils;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 回收订单控制器
 */
@Tag(name = "回收订单管理", description = "回收订单的创建、查询与状态管理")
@RestController
@RequestMapping("/order")
public class RecycleOrderController {

    @Resource
    private IRecycleOrderService recycleOrderService;

    /**
     * 根据ID查询订单
     */
    @Operation(summary = "根据ID查询订单", description = "普通用户只能查看自己的订单")
    @GetMapping("/{id}")
    public Result<OrderVO> getById(@PathVariable Long id) {
        Long userId = AuthUtil.getUserId();
        Integer role = AuthUtil.getRole();

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
    @Operation(summary = "查询所有订单", description = "仅管理员可操作")
    @GetMapping("/list")
    public Result<List<RecycleOrder>> listAll() {
        Integer role = AuthUtil.getRole();
        if (!role.equals(SystemConstants.ROLE_ADMIN)) {
            throw new BusinessException(SystemConstants.ADMIN_ONLY);
        }
        List<RecycleOrder> list = recycleOrderService.listAll();
        return Result.success(list);
    }

    /**
     * 分页查询订单列表（管理员）
     */
    @Operation(summary = "分页查询订单列表", description = "仅管理员可操作，支持地址、日期、状态条件搜索")
    @GetMapping("/page")
    public Result<PageResult<RecycleOrder>> getOrderPage(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "20") Integer pageSize,
            @RequestParam(required = false) String address,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate,
            @RequestParam(required = false) Integer orderStatus) {
        Integer role = AuthUtil.getRole();
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
    @Operation(summary = "查询我的订单", description = "支持地址、日期条件搜索")
    @GetMapping("/my")
    public Result<List<RecycleOrder>> listMyOrders(
            @RequestParam(required = false) String address,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate) {
        Long userId = AuthUtil.getUserId();

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
    @Operation(summary = "创建订单", description = "提交电池回收上门回收订单")
    @PostMapping
    public Result<Void> createOrder(@RequestBody CreateOrderDTO dto) {
        Long userId = AuthUtil.getUserId();

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
    @Operation(summary = "更新订单状态", description = "仅管理员可操作")
    @PutMapping("/{id}/status")
    public Result<Void> updateStatus(@PathVariable Long id, @RequestBody Map<String, Integer> params) {
        Integer role = AuthUtil.getRole();
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
    @Operation(summary = "取消订单", description = "用户取消自己的未开始订单")
    @PutMapping("/{id}/cancel")
    public Result<Void> cancelOrder(@PathVariable Long id) {
        Long userId = AuthUtil.getUserId();
        recycleOrderService.cancelOrder(id, userId);
        return Result.success(SystemConstants.ORDER_CANCEL_SUCCESS, null);
    }
}
