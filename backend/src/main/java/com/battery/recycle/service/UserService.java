package com.battery.recycle.service;

import com.battery.recycle.common.PageRequest;
import com.battery.recycle.common.PageResult;
import com.battery.recycle.constant.SystemConstants;
import com.battery.recycle.dto.ChangePasswordDTO;
import com.battery.recycle.entity.User;
import com.battery.recycle.exception.BusinessException;
import com.battery.recycle.mapper.UserMapper;
import com.battery.recycle.util.Md5Util;
import com.battery.recycle.vo.UserVO;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * 用户服务类
 */
@Service
public class UserService {

    @Autowired
    private UserMapper userMapper;

    /**
     * 根据ID查询用户
     */
    public UserVO getById(Long id) {
        User user = userMapper.getById(id);
        if (user == null) {
            throw new BusinessException(SystemConstants.USER_NOT_FOUND);
        }
        UserVO vo = new UserVO();
        BeanUtils.copyProperties(user, vo);
        return vo;
    }

    /**
     * 查询所有用户
     */
    public List<UserVO> listAll() {
        List<User> users = userMapper.listAll();
        List<UserVO> voList = new ArrayList<>();
        for (User user : users) {
            UserVO vo = new UserVO();
            BeanUtils.copyProperties(user, vo);
            voList.add(vo);
        }
        return voList;
    }

    /**
     * 分页查询用户列表
     */
    public PageResult<UserVO> getUserPage(PageRequest pageRequest) {
        // 开启分页
        PageHelper.startPage(pageRequest.getValidPageNum(), pageRequest.getValidPageSize());

        // 查询用户列表
        List<User> users = userMapper.listAll();

        // 转换为 VO
        List<UserVO> voList = new ArrayList<>();
        for (User user : users) {
            UserVO vo = new UserVO();
            BeanUtils.copyProperties(user, vo);
            voList.add(vo);
        }

        // 封装分页结果
        PageInfo<User> pageInfo = new PageInfo<>(users);
        PageResult<UserVO> result = new PageResult<>();
        result.setTotal(pageInfo.getTotal());
        result.setList(voList);
        result.setPageNum(pageInfo.getPageNum());
        result.setPageSize(pageInfo.getPageSize());
        result.setPages(pageInfo.getPages());

        return result;
    }

    /**
     * 添加用户
     */
    public void addUser(User user) {
        // 检查用户名是否已存在
        User existUser = userMapper.getByUsername(user.getUsername());
        if (existUser != null) {
            throw new BusinessException(SystemConstants.USER_ALREADY_EXISTS);
        }

        // 密码加密
        user.setPassword(Md5Util.encrypt(user.getPassword()));

        // 设置默认值
        if (user.getRole() == null) {
            user.setRole(SystemConstants.ROLE_USER);
        }
        if (user.getStatus() == null) {
            user.setStatus(SystemConstants.STATUS_NORMAL);
        }
        if (user.getNickname() == null || user.getNickname().isEmpty()) {
            user.setNickname(user.getUsername());
        }

        userMapper.insert(user);
    }

    /**
     * 更新用户信息
     */
    public void update(User user) {
        User existUser = userMapper.getById(user.getId());
        if (existUser == null) {
            throw new BusinessException(SystemConstants.USER_NOT_FOUND);
        }

        // 如果修改了密码，需要加密
        if (user.getPassword() != null && !user.getPassword().isEmpty()) {
            user.setPassword(Md5Util.encrypt(user.getPassword()));
        }

        userMapper.update(user);
    }

    /**
     * 修改当前用户密码
     */
    public void changePassword(Long userId, ChangePasswordDTO dto) {
        String encryptedOldPassword = Md5Util.encrypt(dto.getOldPassword());
        User user = userMapper.getByIdAndPassword(userId, encryptedOldPassword);
        if (user == null) {
            throw new BusinessException(SystemConstants.USER_OLD_PASSWORD_ERROR);
        }
        if (dto.getOldPassword().equals(dto.getNewPassword())) {
            throw new BusinessException(SystemConstants.USER_NEW_PASSWORD_SAME_AS_OLD);
        }

        User updateUser = new User();
        updateUser.setId(userId);
        updateUser.setPassword(dto.getNewPassword());
        update(updateUser);
    }

    /**
     * 删除用户
     */
    public void deleteById(Long id) {
        User user = userMapper.getById(id);
        if (user == null) {
            throw new BusinessException(SystemConstants.USER_NOT_FOUND);
        }
        userMapper.deleteById(id);
    }

    /**
     * 搜索用户
     */
    public PageResult<UserVO> searchUsers(Long userId, String username, PageRequest pageRequest) {
        int offset = (pageRequest.getValidPageNum() - 1) * pageRequest.getValidPageSize();

        List<User> users = userMapper.searchUsers(userId, username, offset, pageRequest.getValidPageSize());
        Integer total = userMapper.countBySearch(userId, username);

        List<UserVO> voList = new ArrayList<>();
        for (User user : users) {
            UserVO vo = new UserVO();
            BeanUtils.copyProperties(user, vo);
            voList.add(vo);
        }

        PageResult<UserVO> result = new PageResult<>();
        result.setTotal((long) total);
        result.setList(voList);
        result.setPageNum(pageRequest.getValidPageNum());
        result.setPageSize(pageRequest.getValidPageSize());
        result.setPages((int) Math.ceil((double) total / pageRequest.getValidPageSize()));

        return result;
    }
}
