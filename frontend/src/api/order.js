import request from '@/utils/request'

// 创建订单
export const createOrder = (data) => {
  return request({
    url: '/order',
    method: 'post',
    data
  })
}

// 获取我的订单
export const getMyOrders = () => {
  return request({
    url: '/order/my',
    method: 'get'
  })
}

// 获取所有订单（管理员）
export const getAllOrders = () => {
  return request({
    url: '/order/list',
    method: 'get'
  })
}

// 根据ID获取订单详情
export const getOrderById = (id) => {
  return request({
    url: `/order/${id}`,
    method: 'get'
  })
}

// 更新订单状态（管理员）
export const updateOrderStatus = (id, status) => {
  return request({
    url: `/order/${id}/status`,
    method: 'put',
    data: { status }
  })
}

// 取消订单
export const cancelOrder = (id) => {
  return request({
    url: `/order/${id}/cancel`,
    method: 'put'
  })
}

