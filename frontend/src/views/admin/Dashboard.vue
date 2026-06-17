<template>
  <div class="dashboard">
    <h2 class="page-title">数据概览</h2>
    
    <!-- 统计卡片 -->
    <el-row :gutter="20" class="stats-row">
      <el-col :xs="24" :sm="12" :md="6">
        <div class="stat-card fade-in" style="animation-delay: 0.1s">
          <div class="stat-icon" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%)">
            <el-icon :size="32"><User /></el-icon>
          </div>
          <div class="stat-content">
            <div class="stat-value">{{ stats.userCount || 0 }}</div>
            <div class="stat-label">用户总数</div>
          </div>
        </div>
      </el-col>
      
      <el-col :xs="24" :sm="12" :md="6">
        <div class="stat-card fade-in" style="animation-delay: 0.2s">
          <div class="stat-icon" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%)">
            <el-icon :size="32"><Document /></el-icon>
          </div>
          <div class="stat-content">
            <div class="stat-value">{{ stats.orderCount || 0 }}</div>
            <div class="stat-label">订单总数</div>
          </div>
        </div>
      </el-col>
      
      <el-col :xs="24" :sm="12" :md="6">
        <div class="stat-card fade-in" style="animation-delay: 0.3s">
          <div class="stat-icon" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)">
            <el-icon :size="32"><Box /></el-icon>
          </div>
          <div class="stat-content">
            <div class="stat-value">{{ stats.batteryCount || 0 }}</div>
            <div class="stat-label">回收电池数</div>
          </div>
        </div>
      </el-col>
      
      <el-col :xs="24" :sm="12" :md="6">
        <div class="stat-card fade-in" style="animation-delay: 0.4s">
          <div class="stat-icon gradient-bg">
            <el-icon :size="32"><TrendCharts /></el-icon>
          </div>
          <div class="stat-content">
            <div class="stat-value">{{ stats.todayCount || 0 }}</div>
            <div class="stat-label">今日回收</div>
          </div>
        </div>
      </el-col>
    </el-row>
    
    <!-- 快捷操作 -->
    <el-card class="quick-actions custom-card" shadow="hover">
      <template #header>
        <span class="card-title">快捷操作</span>
      </template>
      <el-row :gutter="16">
        <el-col :xs="24" :sm="12" :md="6">
          <el-button type="primary" size="large" @click="$router.push('/admin/users')" class="action-btn">
            <el-icon><User /></el-icon>
            <span>用户管理</span>
          </el-button>
        </el-col>
        <el-col :xs="24" :sm="12" :md="6">
          <el-button type="success" size="large" @click="$router.push('/admin/battery-types')" class="action-btn">
            <el-icon><Box /></el-icon>
            <span>电池管理</span>
          </el-button>
        </el-col>
        <el-col :xs="24" :sm="12" :md="6">
          <el-button type="warning" size="large" @click="$router.push('/admin/orders')" class="action-btn">
            <el-icon><Document /></el-icon>
            <span>订单管理</span>
          </el-button>
        </el-col>
        <el-col :xs="24" :sm="12" :md="6">
          <el-button type="info" size="large" @click="$router.push('/admin/statistics/battery-types')" class="action-btn">
            <el-icon><TrendCharts /></el-icon>
            <span>数据统计</span>
          </el-button>
        </el-col>
      </el-row>
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { User, Document, Box, TrendCharts } from '@element-plus/icons-vue'
import { getDashboardOverview } from '@/api/statistics'

const stats = ref({
  userCount: 0,
  orderCount: 0,
  batteryCount: 0,
  todayCount: 0
})

const loadStats = async () => {
  try {
    // 后端直接返回概览卡片需要的数字，避免前端拉取用户和订单全量列表。
    const res = await getDashboardOverview()
    const data = res.data || {}

    // 逐个兜底，保证接口字段异常时页面仍能展示为0。
    stats.value.userCount = Number(data.userCount) || 0
    stats.value.orderCount = Number(data.orderCount) || 0
    stats.value.batteryCount = Number(data.batteryCount) || 0
    stats.value.todayCount = Number(data.todayCount) || 0
  } catch (error) {
    console.error('加载统计数据失败：', error)
  }
}

onMounted(() => {
  loadStats()
})
</script>

<style scoped>
.dashboard {
  animation: fadeIn 0.5s ease;
}

.stats-row {
  margin-bottom: 24px;
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

.quick-actions {
  margin-top: 24px;
}

.card-title {
  font-size: 18px;
  font-weight: 600;
  color: var(--text-primary);
}

.action-btn {
  width: 100%;
  height: 60px;
  font-size: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  margin-bottom: 16px;
}

@media (max-width: 768px) {
  .stat-card {
    padding: 16px;
  }
  
  .stat-icon {
    width: 48px;
    height: 48px;
  }
  
  .stat-value {
    font-size: 24px;
  }
}
</style>
