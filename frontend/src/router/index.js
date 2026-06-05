import { createRouter, createWebHistory } from 'vue-router'
import { useUserStore } from '@/stores/user'

const getLoginRedirectPath = (targetPath) => {
  if (targetPath.startsWith('/admin')) {
    return '/login?redirect=/admin'
  }
  if (targetPath.startsWith('/user')) {
    return '/login?redirect=/user'
  }
  return '/login'
}

const routes = [
  {
    path: '/',
    redirect: '/login'
  },
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/views/Login.vue'),
    meta: { requiresAuth: false }
  },
  {
    path: '/register',
    name: 'Register',
    component: () => import('@/views/Register.vue'),
    meta: { requiresAuth: false }
  },
  {
    path: '/admin',
    name: 'AdminLayout',
    component: () => import('@/layouts/AdminLayout.vue'),
    meta: { requiresAuth: true, requiresAdmin: true },
    children: [
      {
        path: '',
        redirect: '/admin/dashboard'
      },
      {
        path: 'dashboard',
        name: 'AdminDashboard',
        component: () => import('@/views/admin/Dashboard.vue')
      },
      {
        path: 'users',
        name: 'UserManagement',
        component: () => import('@/views/admin/UserManagement.vue')
      },
      {
        path: 'battery-types',
        name: 'BatteryTypeManagement',
        component: () => import('@/views/admin/BatteryTypeManagement.vue')
      },
      {
        path: 'orders',
        name: 'OrderManagement',
        component: () => import('@/views/admin/OrderManagement.vue')
      },
      {
        path: 'statistics/battery-types',
        name: 'StatisticsBatteryType',
        component: () => import('@/views/admin/StatisticsBatteryType.vue')
      },
      {
        path: 'statistics/trend',
        name: 'StatisticsTrend',
        component: () => import('@/views/admin/StatisticsTrend.vue')
      },
      {
        path: 'statistics/battery-ratio',
        name: 'StatisticsBatteryRatio',
        component: () => import('@/views/admin/StatisticsBatteryRatio.vue')
      },
      {
        path: 'statistics/city-rank',
        name: 'StatisticsCityRank',
        component: () => import('@/views/admin/StatisticsCityRank.vue')
      },
      {
        path: 'exchange-products',
        name: 'ExchangeProductManage',
        component: () => import('@/views/admin/ExchangeProductManage.vue')
      },
      {
        path: 'exchange-records',
        name: 'ExchangeRecordManage',
        component: () => import('@/views/admin/ExchangeRecordManage.vue')
      },
      {
        path: 'profile',
        name: 'AdminProfile',
        component: () => import('@/views/Profile.vue')
      }
    ]
  },
  {
    path: '/user',
    name: 'UserLayout',
    component: () => import('@/layouts/UserLayout.vue'),
    meta: { requiresAuth: true },
    children: [
      {
        path: '',
        redirect: '/user/home'
      },
      {
        path: 'home',
        name: 'UserHome',
        component: () => import('@/views/user/Home.vue')
      },
      {
        path: 'recycle',
        name: 'Recycle',
        component: () => import('@/views/user/Recycle.vue')
      },
      {
        path: 'orders',
        name: 'MyOrders',
        component: () => import('@/views/user/MyOrders.vue')
      },
      {
        path: 'points-exchange',
        name: 'PointsExchange',
        component: () => import('@/views/user/PointsExchange.vue')
      },
      {
        path: 'my-exchange',
        name: 'MyExchange',
        component: () => import('@/views/user/MyExchange.vue')
      },
      {
        path: 'profile',
        name: 'UserProfile',
        component: () => import('@/views/Profile.vue')
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// 路由守卫
router.beforeEach((to, from, next) => {
  const userStore = useUserStore()
  userStore.syncCurrentAuth(to.path)
  const redirectTarget = typeof to.query.redirect === 'string' ? to.query.redirect : ''
  const prefersAdminLogin = redirectTarget.startsWith('/admin') || from.path.startsWith('/admin')
  const prefersUserLogin = redirectTarget.startsWith('/user') || from.path.startsWith('/user')
  
  // 需要登录的页面
  if (to.meta.requiresAuth) {
    if (!userStore.isLoggedIn(to.path)) {
      next(getLoginRedirectPath(to.path))
      return
    }
    
    // 需要管理员权限的页面
    if (to.meta.requiresAdmin && !userStore.isAdmin(to.path)) {
      next('/user')
      return
    }
  }
  
  // 已登录用户访问登录/注册页面，重定向到对应首页
  if (to.path === '/login' || to.path === '/register') {
    if (prefersAdminLogin) {
      if (userStore.isLoggedIn('/admin')) {
        next('/admin')
        return
      }
      next()
      return
    }

    if (prefersUserLogin) {
      if (userStore.isLoggedIn('/user')) {
        next('/user')
        return
      }
      next()
      return
    }

    next()
    return
  }
  
  next()
})

export default router

