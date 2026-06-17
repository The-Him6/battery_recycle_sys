import request from '@/utils/request'

// 用户注册
export const register = (data) => {
  return request({
    url: '/auth/register',
    method: 'post',
    data
  })
}

// 用户登录
export const login = (data) => {
  return request({
    url: '/auth/login',
    method: 'post',
    data
  })
}

// 用户退出登录
export const logout = () => {
  return request({
    url: '/auth/logout',
    method: 'post'
  })
}

// 忘记密码
export const forgotPassword = (data) => {
  return request({
    url: '/auth/forgot-password',
    method: 'post',
    data
  })
}

// 获取当前用户信息
export const getCurrentUserInfo = () => {
  return request({
    url: '/user/info',
    method: 'get'
  })
}

// 更新用户信息
export const updateUser = (data) => {
  return request({
    url: '/user',
    method: 'put',
    data
  })
}

// 修改当前用户密码
export const changePassword = (data) => {
  return request({
    url: '/user/change-password',
    method: 'put',
    data
  })
}

// 上传头像
export const uploadAvatar = (file) => {
  const formData = new FormData()
  formData.append('file', file)
  return request({
    url: '/user/avatar',
    method: 'post',
    data: formData,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

// 获取所有用户（管理员）
export const getUserList = () => {
  return request({
    url: '/user/list',
    method: 'get'
  })
}

// 删除用户（管理员）
export const deleteUser = (id) => {
  return request({
    url: `/user/${id}`,
    method: 'delete'
  })
}
