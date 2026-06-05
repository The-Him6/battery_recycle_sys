import { defineStore } from 'pinia'
import { ref } from 'vue'

const USER_TOKEN_KEY = 'userToken'
const USER_INFO_KEY = 'userInfo'
const ADMIN_TOKEN_KEY = 'adminToken'
const ADMIN_INFO_KEY = 'adminInfo'

const getStorageValue = (key) => sessionStorage.getItem(key) || ''
const getStorageUserInfo = (key) => JSON.parse(sessionStorage.getItem(key) || 'null')

export const useUserStore = defineStore('user', () => {
  // 状态
  const userToken = ref(getStorageValue(USER_TOKEN_KEY))
  const userInfo = ref(getStorageUserInfo(USER_INFO_KEY))
  const adminToken = ref(getStorageValue(ADMIN_TOKEN_KEY))
  const adminInfo = ref(getStorageUserInfo(ADMIN_INFO_KEY))

  const isAdminRoute = (path = window.location.pathname) => path.startsWith('/admin')
  const isUserRoute = (path = window.location.pathname) => path.startsWith('/user')

  const getTokenByPath = (path = window.location.pathname) => {
    if (isAdminRoute(path)) {
      return adminToken.value
    }
    if (isUserRoute(path)) {
      return userToken.value
    }
    return adminToken.value || userToken.value
  }

  const getUserInfoByPath = (path = window.location.pathname) => {
    if (isAdminRoute(path)) {
      return adminInfo.value
    }
    if (isUserRoute(path)) {
      return userInfo.value
    }
    return adminInfo.value || userInfo.value
  }

  // 当前页面使用的登录态
  const token = ref(getTokenByPath())
  const currentUserInfo = ref(getUserInfoByPath())

  const syncCurrentAuth = (path = window.location.pathname) => {
    token.value = getTokenByPath(path)
    currentUserInfo.value = getUserInfoByPath(path)
  }

  // 是否已登录
  const isLoggedIn = (path = window.location.pathname) => {
    return !!getTokenByPath(path)
  }

  // 是否是管理员
  const isAdmin = (path = window.location.pathname) => {
    return getUserInfoByPath(path)?.role === 1
  }

  // 设置token
  const setToken = (newToken, role) => {
    if (role === 1) {
      adminToken.value = newToken
      sessionStorage.setItem(ADMIN_TOKEN_KEY, newToken)
    } else {
      userToken.value = newToken
      sessionStorage.setItem(USER_TOKEN_KEY, newToken)
    }
    syncCurrentAuth()
  }

  // 设置用户信息
  const setUserInfo = (info) => {
    if (info?.role === 1) {
      adminInfo.value = info
      sessionStorage.setItem(ADMIN_INFO_KEY, JSON.stringify(info))
    } else {
      userInfo.value = info
      sessionStorage.setItem(USER_INFO_KEY, JSON.stringify(info))
    }
    syncCurrentAuth()
  }

  // 登录
  const login = (loginData) => {
    const role = loginData.userInfo?.role
    setToken(loginData.token, role)
    setUserInfo(loginData.userInfo)
  }

  // 退出登录
  const logout = (path = window.location.pathname) => {
    if (isAdminRoute(path)) {
      adminToken.value = ''
      adminInfo.value = null
      sessionStorage.removeItem(ADMIN_TOKEN_KEY)
      sessionStorage.removeItem(ADMIN_INFO_KEY)
    } else {
      userToken.value = ''
      userInfo.value = null
      sessionStorage.removeItem(USER_TOKEN_KEY)
      sessionStorage.removeItem(USER_INFO_KEY)
    }
    syncCurrentAuth(path)
  }

  // 更新用户信息
  const updateUserInfo = (info, path = window.location.pathname) => {
    if (isAdminRoute(path)) {
      adminInfo.value = { ...adminInfo.value, ...info }
      sessionStorage.setItem(ADMIN_INFO_KEY, JSON.stringify(adminInfo.value))
    } else {
      userInfo.value = { ...userInfo.value, ...info }
      sessionStorage.setItem(USER_INFO_KEY, JSON.stringify(userInfo.value))
    }
    syncCurrentAuth(path)
  }

  return {
    token,
    userInfo: currentUserInfo,
    userToken,
    adminToken,
    rawUserInfo: userInfo,
    adminInfo,
    isAdminRoute,
    isUserRoute,
    getTokenByPath,
    getUserInfoByPath,
    syncCurrentAuth,
    isLoggedIn,
    isAdmin,
    setToken,
    setUserInfo,
    login,
    logout,
    updateUserInfo
  }
})

