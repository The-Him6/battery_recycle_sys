import request from '@/utils/request'

// 管理员查询全部系统公告
export const getNoticeList = () => {
  return request({
    url: '/notice/list',
    method: 'get'
  })
}

// 用户查询当前未读弹窗
export const getActiveNotices = () => {
  return request({
    url: '/notice/active',
    method: 'get'
  })
}

// 管理员新增系统公告
export const addNotice = (data) => {
  return request({
    url: '/notice',
    method: 'post',
    data
  })
}

// 管理员更新系统公告
export const updateNotice = (data) => {
  return request({
    url: '/notice',
    method: 'put',
    data
  })
}

// 用户标记公告已读
export const markNoticeRead = (id) => {
  return request({
    url: `/notice/${id}/read`,
    method: 'post'
  })
}
