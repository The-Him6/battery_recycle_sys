<template>
  <div class="user-layout">
    <el-container>
      <!-- 顶部导航 -->
      <el-header class="header">
        <div class="header-left">
          <BatteryIcon :size="34" body-fill="#7d9f69" cap-fill="#5f7f50" inner-fill="#eef5ea" bolt-fill="#89b076" />
          <span class="logo-text">废电池回收系统</span>
        </div>
        
        <el-menu
          :default-active="activeMenu"
          mode="horizontal"
          router
          background-color="transparent"
          text-color="#6f7d6b"
          active-text-color="#7d9f69"
          class="nav-menu"
        >
          <el-menu-item index="/user/home">
            <el-icon><HomeFilled /></el-icon>
            <span>首页</span>
          </el-menu-item>
          
          <el-menu-item index="/user/recycle">
            <el-icon><Plus /></el-icon>
            <span>电池回收</span>
          </el-menu-item>
          
          <el-menu-item index="/user/orders">
            <el-icon><Document /></el-icon>
            <span>我的订单</span>
          </el-menu-item>
          
          <el-menu-item index="/user/points-exchange">
            <el-icon><ShoppingCart /></el-icon>
            <span>积分兑换</span>
          </el-menu-item>
          
          <el-menu-item index="/user/my-exchange">
            <el-icon><List /></el-icon>
            <span>兑换记录</span>
          </el-menu-item>
          
          <el-menu-item index="/user/profile">
            <el-icon><User /></el-icon>
            <span>个人中心</span>
          </el-menu-item>
        </el-menu>
        
        <div class="header-right">
          <span class="user-name">{{ userStore.userInfo?.nickname || userStore.userInfo?.username }}</span>
          <el-button type="danger" text @click="handleLogout" :icon="SwitchButton">
            退出
          </el-button>
        </div>
      </el-header>
      
      <!-- 内容区 -->
      <el-main class="main-content">
        <router-view />
      </el-main>
    </el-container>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessageBox, ElMessage } from 'element-plus'
import { HomeFilled, Plus, Document, User, SwitchButton, ShoppingCart, List } from '@element-plus/icons-vue'
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
    userStore.logout('/user')
    ElMessage.success('已退出登录')
    router.push('/login')
  }).catch(() => {})
}
</script>

<style scoped>
.user-layout {
  min-height: 100vh;
  background: var(--bg-color);
}

.el-container {
  min-height: 100vh;
}

.header {
  background: #ffffff;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 24px;
  position: sticky;
  top: 0;
  z-index: 100;
}

.header-left {
  display: flex;
  align-items: center;
  gap: 12px;
}

.logo-text {
  font-size: 20px;
  font-weight: 700;
  color: var(--text-primary);
}

.nav-menu {
  flex: 1;
  border-bottom: none;
  margin: 0 40px;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 16px;
}

.user-name {
  font-size: 14px;
  color: var(--text-secondary);
}

.main-content {
  padding: 24px;
  max-width: 1400px;
  margin: 0 auto;
  width: 100%;
}
</style>

