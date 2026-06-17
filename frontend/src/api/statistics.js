import request from '@/utils/request'

// 获取管理员首页概览数字
export const getDashboardOverview = () => {
  return request({
    url: '/statistics/dashboard',
    method: 'get'
  })
}

// 统计每种电池的回收数量
export const countByBatteryType = () => {
  return request({
    url: '/statistics/battery-type',
    method: 'get'
  })
}

// 统计每日回收数量
export const countByDate = (days) => {
  return request({
    url: '/statistics/date',
    method: 'get',
    params: { days }
  })
}

// 按月统计回收数量
export const countByMonth = () => {
  return request({
    url: '/statistics/monthly',
    method: 'get'
  })
}

// 按年统计回收数量
export const countByYear = () => {
  return request({
    url: '/statistics/yearly',
    method: 'get'
  })
}

// 统计订单状态分布
export const countByOrderStatus = () => {
  return request({
    url: '/statistics/order-status',
    method: 'get'
  })
}

// 统计地区回收排行（按市）
export const countByCity = (limit) => {
  return request({
    url: '/statistics/city-rank',
    method: 'get',
    params: { limit }
  })
}

// 获取综合统计数据
export const getOverview = () => {
  return request({
    url: '/statistics/overview',
    method: 'get'
  })
}
