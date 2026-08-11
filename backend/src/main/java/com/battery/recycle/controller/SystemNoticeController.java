package com.battery.recycle.controller;

import jakarta.annotation.Resource;

import com.battery.recycle.common.Result;
import com.battery.recycle.entity.SystemNotice;
import com.battery.recycle.service.ISystemNoticeService;
import com.battery.recycle.util.AuthUtil;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 系统弹窗公告控制器
 */
@Tag(name = "系统公告", description = "系统弹窗公告的增删改查与已读标记")
@RestController
@RequestMapping("/notice")
public class SystemNoticeController {

    @Resource
    private ISystemNoticeService systemNoticeService;

    /**
     * 管理员查询全部公告
     */
    @Operation(summary = "查询全部公告", description = "仅管理员可操作")
    @GetMapping("/list")
    public Result<List<SystemNotice>> listAll() {
        AuthUtil.requireAdmin();
        return Result.success(systemNoticeService.listAll());
    }

    /**
     * 用户查询未读有效弹窗
     */
    @Operation(summary = "查询未读有效弹窗", description = "返回当前用户未读且在有效期内的公告")
    @GetMapping("/active")
    public Result<List<SystemNotice>> listActiveUnread() {
        return Result.success(systemNoticeService.listActiveUnread(AuthUtil.getUserId()));
    }

    /**
     * 管理员新增公告
     */
    @Operation(summary = "新增公告", description = "仅管理员可操作")
    @PostMapping
    public Result<Void> add(@RequestBody SystemNotice notice) {
        AuthUtil.requireAdmin();
        systemNoticeService.add(notice, AuthUtil.getUserId());
        return Result.success("新增公告成功", null);
    }

    /**
     * 管理员更新公告
     */
    @Operation(summary = "更新公告", description = "仅管理员可操作")
    @PutMapping
    public Result<Void> update(@RequestBody SystemNotice notice) {
        AuthUtil.requireAdmin();
        systemNoticeService.update(notice);
        return Result.success("更新公告成功", null);
    }

    /**
     * 用户标记公告已读
     */
    @Operation(summary = "标记公告已读")
    @PostMapping("/{id}/read")
    public Result<Void> markRead(@PathVariable Long id) {
        systemNoticeService.markRead(id, AuthUtil.getUserId());
        return Result.success("已读成功", null);
    }
}
