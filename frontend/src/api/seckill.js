import request from '@/utils/request'

// 管理员查询全部秒杀活动
export const getSeckillActivityList = () => {
  return request({
    url: '/seckill/activity/list',
    method: 'get'
  })
}

// 用户查询已上架秒杀活动
export const getOnlineSeckillActivities = () => {
  return request({
    url: '/seckill/activity/online',
    method: 'get'
  })
}

// 管理员新增秒杀活动
export const addSeckillActivity = (data) => {
  return request({
    url: '/seckill/activity',
    method: 'post',
    data
  })
}

// 管理员更新秒杀活动
export const updateSeckillActivity = (data) => {
  return request({
    url: '/seckill/activity',
    method: 'put',
    data
  })
}

// 管理员上架活动并预热Redis库存
export const onlineSeckillActivity = (id) => {
  return request({
    url: `/seckill/activity/${id}/online`,
    method: 'put'
  })
}

// 管理员下架活动
export const offlineSeckillActivity = (id) => {
  return request({
    url: `/seckill/activity/${id}/offline`,
    method: 'put'
  })
}

// 管理员手动预热活动库存
export const preheatSeckillActivity = (id) => {
  return request({
    url: `/seckill/activity/${id}/preheat`,
    method: 'post'
  })
}

// 用户参与秒杀抢券
export const seckillCoupon = (activityId) => {
  return request({
    url: `/seckill/${activityId}`,
    method: 'post'
  })
}

// 查询我的全部秒杀券
export const getMySeckillCoupons = () => {
  return request({
    url: '/seckill-coupon/my',
    method: 'get'
  })
}

// 查询我的可用秒杀券
export const getUsableSeckillCoupons = () => {
  return request({
    url: '/seckill-coupon/usable',
    method: 'get'
  })
}
