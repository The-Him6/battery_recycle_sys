import request from '@/utils/request'

// 获取电池种类列表
export const getBatteryTypeList = () => {
  return request({
    url: '/battery-type/list',
    method: 'get'
  })
}

// 获取启用的电池种类
export const getEnabledBatteryTypes = () => {
  return request({
    url: '/battery-type/enabled',
    method: 'get'
  })
}

// 根据ID获取电池种类
export const getBatteryTypeById = (id) => {
  return request({
    url: `/battery-type/${id}`,
    method: 'get'
  })
}

// 添加电池种类
export const addBatteryType = (data) => {
  return request({
    url: '/battery-type',
    method: 'post',
    data
  })
}

// 更新电池种类
export const updateBatteryType = (data) => {
  return request({
    url: '/battery-type',
    method: 'put',
    data
  })
}

// 删除电池种类
export const deleteBatteryType = (id) => {
  return request({
    url: `/battery-type/${id}`,
    method: 'delete'
  })
}

// 上传电池图标
export const uploadBatteryIcon = (file) => {
  const formData = new FormData()
  formData.append('file', file)
  return request({
    url: '/battery-type/upload-icon',
    method: 'post',
    data: formData,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

