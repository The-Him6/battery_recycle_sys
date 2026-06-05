<template>
  <div class="admin-layout">
    <el-container>
      <!-- 侧边栏 -->
      <el-aside width="280px" class="sidebar">
        <div class="logo-section">
          <div class="logo-brand">
            <BatteryIcon :size="34" body-fill="#7d9f69" cap-fill="#5f7f50" inner-fill="#eef5ea" bolt-fill="#89b076" />
            <div class="logo-copy">
              <span class="logo-text">废电池回收系统</span>
              <span class="logo-subtext">管理后台</span>
            </div>
          </div>
        </div>
        
        <el-menu
          :default-active="activeMenu"
          router
          background-color="#ffffff"
          text-color="#606266"
          active-text-color="#1890ff"
        >
          <el-menu-item index="/admin/dashboard">
            <el-icon><DataAnalysis /></el-icon>
            <span>数据概览</span>
          </el-menu-item>
          
          <el-menu-item index="/admin/users">
            <el-icon><User /></el-icon>
            <span>用户管理</span>
          </el-menu-item>
          
          <el-menu-item index="/admin/battery-types">
            <el-icon><Box /></el-icon>
            <span>电池种类管理</span>
          </el-menu-item>
          
          <el-menu-item index="/admin/orders">
            <el-icon><Document /></el-icon>
            <span>订单管理</span>
          </el-menu-item>
          
          <el-sub-menu index="/admin/statistics-group">
            <template #title>
              <el-icon><TrendCharts /></el-icon>
              <span>数据统计</span>
            </template>
            <el-menu-item index="/admin/statistics/battery-types">电池回收统计</el-menu-item>
            <el-menu-item index="/admin/statistics/trend">回收趋势</el-menu-item>
            <el-menu-item index="/admin/statistics/battery-ratio">种类占比</el-menu-item>
            <el-menu-item index="/admin/statistics/city-rank">地区排行榜</el-menu-item>
          </el-sub-menu>
          
          <el-menu-item index="/admin/exchange-products">
            <el-icon><ShoppingCart /></el-icon>
            <span>兑换商品管理</span>
          </el-menu-item>
          
          <el-menu-item index="/admin/exchange-records">
            <el-icon><List /></el-icon>
            <span>兑换记录管理</span>
          </el-menu-item>
          
          <el-menu-item index="/admin/profile">
            <el-icon><Setting /></el-icon>
            <span>个人中心</span>
          </el-menu-item>
        </el-menu>
      </el-aside>
      
      <!-- 主内容区 -->
      <el-container>
        <!-- 顶部导航 -->
        <el-header class="header">
          <div class="header-left">
            <span class="welcome-text">欢迎，{{ userStore.userInfo?.nickname || userStore.userInfo?.username }}</span>
          </div>
          
          <div class="header-right">
            <el-button @click="handleLogout" :icon="SwitchButton">
              退出登录
            </el-button>
          </div>
        </el-header>
        
        <!-- 内容区 -->
        <el-main class="main-content">
          <router-view />
        </el-main>
      </el-container>
    </el-container>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessageBox, ElMessage } from 'element-plus'
import { 
  DataAnalysis, User, Box, Document, 
  TrendCharts, Tickets, Setting, SwitchButton,
  ShoppingCart, List
} from '@element-plus/icons-vue'
import { useUserStore } from '@/stores/user'
import BatteryIcon from '@/components/BatteryIcon.vue'

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()

const activeMenu = computed(() => route.path)

const handleLogout = () => {
  ElMessageBox.confirm('确定要退出登录吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(() => {
    userStore.logout('/admin')
    ElMessage.success('已退出登录')
    router.push('/login')
  }).catch(() => {})
}
</script>

<style scoped>
.admin-layout {
  height: 100vh;
  overflow: hidden;
}

.el-container {
  height: 100%;
}

.sidebar {
  background: #ffffff;
  border-right: 1px solid rgba(219, 229, 213, 0.8);
  overflow-y: auto;
}

.logo-section {
  height: 72px;
  display: flex;
  align-items: center;
  padding: 0 24px;
  border-bottom: 1px solid var(--border-color);
}

.logo-brand {
  display: flex;
  align-items: center;
  gap: 12px;
  width: 100%;
}

.logo-copy {
  display: flex;
  flex-direction: column;
  min-width: 0;
}

.logo-text {
  font-size: 20px;
  font-weight: 700;
  color: var(--text-primary);
  line-height: 1.2;
}

.logo-subtext {
  margin-top: 4px;
  font-size: 12px;
  letter-spacing: 0.12em;
  color: #7d9f69;
  line-height: 1;
}

.el-menu {
  border-right: none;
}

.header {
  height: 72px;
  background: #ffffff;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 24px;
  border-bottom: 1px solid rgba(219, 229, 213, 0.8);
}

.welcome-text {
  font-size: 16px;
  color: var(--text-primary);
  font-weight: 500;
  line-height: 1;
}

.main-content {
  background: var(--bg-color);
  overflow-y: auto;
}
</style>

