package com.battery.recycle.service;

import com.battery.recycle.common.PageRequest;
import com.battery.recycle.common.PageResult;
import com.battery.recycle.dto.ChangePasswordDTO;
import com.battery.recycle.entity.User;
import com.battery.recycle.vo.UserVO;

import java.util.List;

/**
 * 用户服务接口。
 */
public interface IUserService {

    UserVO getById(Long id);

    List<UserVO> listAll();

    PageResult<UserVO> getUserPage(PageRequest pageRequest);

    void addUser(User user);

    void update(User user);

    void changePassword(Long userId, ChangePasswordDTO dto);

    void deleteById(Long id);

    PageResult<UserVO> searchUsers(Long userId, String username, PageRequest pageRequest);
}
