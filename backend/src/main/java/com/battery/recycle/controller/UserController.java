package com.battery.recycle.controller;

import com.battery.recycle.annotation.OssUpload;
import com.battery.recycle.common.PageRequest;
import com.battery.recycle.common.PageResult;
import com.battery.recycle.common.Result;
import com.battery.recycle.constant.SystemConstants;
import com.battery.recycle.dto.ChangePasswordDTO;
import com.battery.recycle.entity.User;
import com.battery.recycle.exception.BusinessException;
import com.battery.recycle.service.FileUploadService;
import com.battery.recycle.service.UserService;
import com.battery.recycle.vo.UserVO;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

/**
 * 用户控制器
 */
@RestController
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private FileUploadService fileUploadService;

    /**
     * 获取当前用户信息
     */
    @GetMapping("/info")
    public Result<UserVO> getCurrentUserInfo(HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        UserVO userVO = userService.getById(userId);
        return Result.success(userVO);
    }

    /**
     * 根据ID查询用户
     */
    @GetMapping("/{id}")
    public Result<UserVO> getById(@PathVariable Long id) {
        UserVO userVO = userService.getById(id);
        return Result.success(userVO);
    }

    /**
     * 查询所有用户（仅管理员）
     */
    @GetMapping("/list")
    public Result<List<UserVO>> listAll(HttpServletRequest request) {
        Integer role = (Integer) request.getAttribute("role");
        if (!role.equals(SystemConstants.ROLE_ADMIN)) {
            throw new BusinessException(SystemConstants.ADMIN_ONLY);
        }
        List<UserVO> list = userService.listAll();
        return Result.success(list);
    }

    /**
     * 分页查询用户列表（仅管理员）
     */
    @GetMapping("/page")
    public Result<PageResult<UserVO>> getUserPage(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) Long userId,
            @RequestParam(required = false) String username,
            HttpServletRequest request) {
        Integer role = (Integer) request.getAttribute("role");
        if (!role.equals(SystemConstants.ROLE_ADMIN)) {
            throw new BusinessException(SystemConstants.ADMIN_ONLY);
        }

        PageRequest pageRequest = new PageRequest();
        pageRequest.setPageNum(pageNum);
        pageRequest.setPageSize(pageSize);

        PageResult<UserVO> pageResult;
        // 如果有搜索条件，使用搜索方法
        if (userId != null || (username != null && !username.isEmpty())) {
            pageResult = userService.searchUsers(userId, username, pageRequest);
        } else {
            pageResult = userService.getUserPage(pageRequest);
        }

        return Result.success(pageResult);
    }

    /**
     * 更新用户信息
     */
    @PutMapping
    public Result<Void> update(@RequestBody User user, HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        Integer role = (Integer) request.getAttribute("role");

        // 普通用户只能修改自己的信息
        if (!role.equals(SystemConstants.ROLE_ADMIN) && !user.getId().equals(userId)) {
            throw new BusinessException(SystemConstants.PERMISSION_DENIED);
        }

        userService.update(user);
        return Result.success(SystemConstants.USER_UPDATE_SUCCESS, null);
    }

    /**
     * 当前用户修改密码
     */
    @PutMapping("/change-password")
    public Result<Void> changePassword(@RequestBody ChangePasswordDTO dto, HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        userService.changePassword(userId, dto);
        return Result.success("密码修改成功", null);
    }

    /**
     * 添加用户（仅管理员）
     */
    @PostMapping
    public Result<Void> addUser(@RequestBody User user, HttpServletRequest request) {
        Integer role = (Integer) request.getAttribute("role");
        if (!role.equals(SystemConstants.ROLE_ADMIN)) {
            throw new BusinessException(SystemConstants.ADMIN_ONLY);
        }
        userService.addUser(user);
        return Result.success("添加用户成功", null);
    }

    /**
     * 删除用户（仅管理员）
     */
    @DeleteMapping("/{id}")
    public Result<Void> deleteById(@PathVariable Long id, HttpServletRequest request) {
        Integer role = (Integer) request.getAttribute("role");
        if (!role.equals(SystemConstants.ROLE_ADMIN)) {
            throw new BusinessException(SystemConstants.ADMIN_ONLY);
        }
        userService.deleteById(id);
        return Result.success(SystemConstants.USER_DELETE_SUCCESS, null);
    }

    /**
     * 上传头像
     */
    @PostMapping("/avatar")
    @OssUpload(path = "avatar/", allowedTypes = { "image/jpeg", "image/png", "image/jpg", "image/gif" }, maxSize = 2
            * 1024 * 1024)
    public Result<String> uploadAvatar(@RequestParam("file") MultipartFile file, HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");

        // 上传文件到OSS
        String avatarUrl = fileUploadService.uploadAvatar(file);

        // 更新用户头像
        User user = new User();
        user.setId(userId);
        user.setAvatar(avatarUrl);
        userService.update(user);

        return Result.success(SystemConstants.FILE_UPLOAD_SUCCESS, avatarUrl);
    }

    /**
     * 仅上传头像文件（不更新数据库，用于管理员编辑用户）
     */
    @PostMapping("/upload-avatar")
    @OssUpload(path = "avatar/", allowedTypes = { "image/jpeg", "image/png", "image/jpg", "image/gif" }, maxSize = 2
            * 1024 * 1024)
    public Result<String> uploadAvatarFile(@RequestParam("file") MultipartFile file) {
        // 只上传文件到OSS，返回URL，不更新数据库
        String avatarUrl = fileUploadService.uploadAvatar(file);
        return Result.success(SystemConstants.FILE_UPLOAD_SUCCESS, avatarUrl);
    }
}
