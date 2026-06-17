package com.battery.recycle.controller;

import com.battery.recycle.util.AuthUtil;

import com.battery.recycle.annotation.OssUpload;
import com.battery.recycle.common.Result;
import com.battery.recycle.constant.SystemConstants;
import com.battery.recycle.entity.BatteryType;
import com.battery.recycle.exception.BusinessException;
import com.battery.recycle.service.BatteryTypeService;
import com.battery.recycle.service.FileUploadService;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

/**
 * 电池种类控制器
 */
@RestController
@RequestMapping("/battery-type")
public class BatteryTypeController {

    @Resource
    private BatteryTypeService batteryTypeService;

    @Resource
    private FileUploadService fileUploadService;

    /**
     * 根据ID查询电池种类
     */
    @GetMapping("/{id}")
    public Result<BatteryType> getById(@PathVariable Long id) {
        BatteryType batteryType = batteryTypeService.getById(id);
        return Result.success(batteryType);
    }

    /**
     * 查询所有电池种类
     */
    @GetMapping("/list")
    public Result<List<BatteryType>> listAll() {
        List<BatteryType> list = batteryTypeService.listAll();
        return Result.success(list);
    }

    /**
     * 查询启用的电池种类
     */
    @GetMapping("/enabled")
    public Result<List<BatteryType>> listEnabled() {
        List<BatteryType> list = batteryTypeService.listEnabled();
        return Result.success(list);
    }

    /**
     * 添加电池种类（仅管理员）
     */
    @PostMapping
    public Result<Void> add(@RequestBody BatteryType batteryType) {
        Integer role = AuthUtil.getRole();
        if (!role.equals(SystemConstants.ROLE_ADMIN)) {
            throw new BusinessException(SystemConstants.ADMIN_ONLY);
        }
        batteryTypeService.add(batteryType);
        return Result.success(SystemConstants.BATTERY_TYPE_ADD_SUCCESS, null);
    }

    /**
     * 更新电池种类（仅管理员）
     */
    @PutMapping
    public Result<Void> update(@RequestBody BatteryType batteryType) {
        Integer role = AuthUtil.getRole();
        if (!role.equals(SystemConstants.ROLE_ADMIN)) {
            throw new BusinessException(SystemConstants.ADMIN_ONLY);
        }
        batteryTypeService.update(batteryType);
        return Result.success(SystemConstants.BATTERY_TYPE_UPDATE_SUCCESS, null);
    }

    /**
     * 删除电池种类（仅管理员）
     */
    @DeleteMapping("/{id}")
    public Result<Void> deleteById(@PathVariable Long id) {
        Integer role = AuthUtil.getRole();
        if (!role.equals(SystemConstants.ROLE_ADMIN)) {
            throw new BusinessException(SystemConstants.ADMIN_ONLY);
        }
        batteryTypeService.deleteById(id);
        return Result.success(SystemConstants.BATTERY_TYPE_DELETE_SUCCESS, null);
    }

    /**
     * 上传电池图标（仅管理员）
     */
    @PostMapping("/upload-icon")
    @OssUpload(path = "icon/", allowedTypes = { "image/jpeg", "image/png", "image/jpg", "image/gif" }, maxSize = 2
            * 1024 * 1024)
    public Result<String> uploadIcon(@RequestParam("file") MultipartFile file) {
        Integer role = AuthUtil.getRole();
        if (!role.equals(SystemConstants.ROLE_ADMIN)) {
            throw new BusinessException(SystemConstants.ADMIN_ONLY);
        }

        String iconUrl = fileUploadService.uploadBatteryTypeIcon(file);
        return Result.success(SystemConstants.FILE_UPLOAD_SUCCESS, iconUrl);
    }
}
