<template>
  <div class="user-home">
    <!-- 欢迎横幅 -->
    <div class="welcome-banner">
      <img :src="loginBg" alt="欢迎背景" class="banner-bg-image" />
      <div class="banner-bg-overlay"></div>
      <div class="banner-content">
        <h1 class="banner-title">欢迎使用废电池回收系统</h1>
        <p class="banner-subtitle">让废旧电池回收更方便、更环保，共建绿色未来</p>
        <el-button type="primary" size="large" @click="$router.push('/user/recycle')" class="recycle-btn">
          <el-icon><Plus /></el-icon>
          <span>立即回收</span>
        </el-button>
      </div>
    </div>
    
    <!-- 统计卡片 -->
    <el-row :gutter="20" class="stats-section">
      <el-col :xs="24" :sm="8">
        <div class="stat-card fade-in" style="animation-delay: 0.1s">
          <div class="stat-icon" style="background: linear-gradient(135deg, #91af7b 0%, #6f8e5d 100%)">
            <el-icon :size="32"><Document /></el-icon>
          </div>
          <div class="stat-content">
            <div class="stat-value">{{ myStats.orderCount }}</div>
            <div class="stat-label">我的订单</div>
          </div>
        </div>
      </el-col>
      
      <el-col :xs="24" :sm="8">
        <div class="stat-card fade-in" style="animation-delay: 0.2s">
          <div class="stat-icon" style="background: linear-gradient(135deg, #b7cf9d 0%, #88a870 100%)">
            <BatteryIcon :size="32" body-fill="#f5fbf1" cap-fill="#dcebd4" inner-fill="#ffffff" bolt-fill="#8fb67b" />
          </div>
          <div class="stat-content">
            <div class="stat-value">{{ myStats.batteryCount }}</div>
            <div class="stat-label">回收电池数</div>
          </div>
        </div>
      </el-col>
      
      <el-col :xs="24" :sm="8">
        <div class="stat-card fade-in" style="animation-delay: 0.3s">
          <div class="stat-icon gradient-bg">
            <el-icon :size="32"><TrendCharts /></el-icon>
          </div>
          <div class="stat-content">
            <div class="stat-value">{{ myStats.totalPoints }}</div>
            <div class="stat-label">累计积分</div>
          </div>
        </div>
      </el-col>
    </el-row>
    
    <!-- 最近订单 -->
    <el-card class="custom-card recent-orders-card" shadow="hover">
      <template #header>
        <div style="display: flex; justify-content: space-between; align-items: center;">
          <span class="card-title">最近订单</span>
          <el-link type="primary" @click="$router.push('/user/orders')">查看全部</el-link>
        </div>
      </template>
      
      <el-table :data="recentOrders" style="width: 100%">
        <el-table-column prop="orderNumber" label="订单编号" width="200" />
        <el-table-column prop="totalCount" label="电池数量" width="120" />
        <el-table-column prop="totalPoints" label="获得积分" width="120" />
        <el-table-column label="订单状态" width="120">
          <template #default="{ row }">
            <el-tag :type="getStatusType(row.orderStatus)">
              {{ getStatusText(row.orderStatus) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="创建时间" />
      </el-table>
      
      <el-empty v-if="recentOrders.length === 0" description="暂无订单" />
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { Plus, Document, TrendCharts } from '@element-plus/icons-vue'
import { getMyOrders } from '@/api/order'
import loginBg from '@/assets/login-bg.png'
import BatteryIcon from '@/components/BatteryIcon.vue'

const recentOrders = ref([])
const myStats = ref({
  orderCount: 0,
  batteryCount: 0,
  totalPoints: 0
})

const getStatusType = (status) => {
  const types = { 0: 'warning', 1: 'primary', 2: 'success', 3: 'info' }
  return types[status] || 'info'
}

const getStatusText = (status) => {
  const texts = { 0: '待处理', 1: '处理中', 2: '已完成', 3: '已取消' }
  return texts[status] || '未知'
}

const loadMyOrders = async () => {
  try {
    const res = await getMyOrders()
    const orders = res.data || []
    
    // 订单数量包括所有订单
    myStats.value.orderCount = orders.length
    
    // 电池数量和积分只统计非取消的订单（orderStatus != 3）
    const validOrders = orders.filter(order => order.orderStatus !== 3)
    myStats.value.batteryCount = validOrders.reduce((sum, order) => sum + (order.totalCount || 0), 0)
    myStats.value.totalPoints = validOrders.reduce((sum, order) => sum + (order.totalPoints || 0), 0)
    
    // 最近5条订单
    recentOrders.value = orders.slice(0, 5)
  } catch (error) {
    console.error('加载订单失败：', error)
  }
}

onMounted(() => {
  loadMyOrders()
})
</script>

<style scoped>
.user-home {
  animation: fadeIn 0.5s ease;
}

.welcome-banner {
  border-radius: 24px;
  padding: 64px 44px;
  margin-bottom: 30px;
  position: relative;
  overflow: hidden;
  color: #456140;
  min-height: 320px;
  display: flex;
  align-items: center;
  box-shadow: 0 24px 60px rgba(104, 133, 82, 0.18);
}

.banner-bg-image {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
  object-position: 80% center;
  z-index: 0;
}

.banner-bg-overlay {
  position: absolute;
  inset: 0;
  background: linear-gradient(90deg, rgba(241, 247, 236, 0.96) 0%, rgba(199, 220, 183, 0.88) 28%, rgba(162, 191, 138, 0.42) 54%, rgba(255, 255, 255, 0.06) 74%);
  z-index: 1;
}

.welcome-banner::after {
  content: '';
  position: absolute;
  inset: 0;
  background: linear-gradient(180deg, rgba(255, 255, 255, 0.08), rgba(255, 255, 255, 0));
  pointer-events: none;
  z-index: 2;
}

.banner-content {
  position: relative;
  z-index: 3;
  max-width: 520px;
}

.banner-title {
  font-size: 36px;
  font-weight: 700;
  margin-bottom: 16px;
  color: #456140;
  text-shadow: 0 1px 0 rgba(255, 255, 255, 0.35);
}

.banner-subtitle {
  font-size: 18px;
  margin-bottom: 30px;
  color: #5f7a58;
}

.recycle-btn {
  height: 50px;
  padding: 0 40px;
  font-size: 16px;
  font-weight: 600;
  background: white;
  color: var(--primary-color);
  border: none;
}

.recycle-btn:hover {
  background: rgba(255, 255, 255, 0.9);
  transform: translateY(-2px);
}


.stats-section {
  margin-bottom: 30px;
}

.stat-card {
  background: #ffffff;
  border-radius: 12px;
  padding: 24px;
  display: flex;
  align-items: center;
  gap: 20px;
  box-shadow: var(--shadow-sm);
  transition: all 0.3s ease;
  margin-bottom: 20px;
}

.stat-card:hover {
  box-shadow: var(--shadow-md);
  transform: translateY(-4px);
}

.stat-icon {
  width: 64px;
  height: 64px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #ffffff;
}

.stat-content {
  flex: 1;
}

.stat-value {
  font-size: 32px;
  font-weight: 700;
  color: var(--text-primary);
  line-height: 1;
  margin-bottom: 8px;
}

.stat-label {
  font-size: 14px;
  color: var(--text-secondary);
}

.recent-orders-card {
  margin-bottom: 24px;
}

.card-title {
  font-size: 18px;
  font-weight: 600;
  color: var(--text-primary);
}

@media (max-width: 768px) {
  .welcome-banner {
    padding: 40px 20px;
  }
  
  .banner-title {
    font-size: 24px;
  }
  
  .banner-subtitle {
    font-size: 14px;
  }
  
  .banner-decoration {
    display: none;
  }
}
</style>

