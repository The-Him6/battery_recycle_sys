import request from '@/utils/request'

// 获取所有商品（管理员）
export const getProductList = () => {
  return request({
    url: '/exchange-product/list',
    method: 'get'
  })
}

// 获取可兑换商品（用户）
export const getAvailableProducts = () => {
  return request({
    url: '/exchange-product/available',
    method: 'get'
  })
}

// 根据ID获取商品
export const getProductById = (id) => {
  return request({
    url: `/exchange-product/${id}`,
    method: 'get'
  })
}

// 添加商品（管理员）
export const addProduct = (data) => {
  return request({
    url: '/exchange-product',
    method: 'post',
    data
  })
}

// 更新商品（管理员）
export const updateProduct = (data) => {
  return request({
    url: '/exchange-product',
    method: 'put',
    data
  })
}

// 删除商品（管理员）
export const deleteProduct = (id) => {
  return request({
    url: `/exchange-product/${id}`,
    method: 'delete'
  })
}

// 上传商品图片（管理员）
export const uploadProductImage = (file) => {
  const formData = new FormData()
  formData.append('file', file)
  return request({
    url: '/exchange-product/upload-image',
    method: 'post',
    data: formData,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}









































