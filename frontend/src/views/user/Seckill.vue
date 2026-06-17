<template>
  <div class="user-seckill">
    <el-card class="page-card">
      <template #header>
        <div class="card-header">
          <span>秒杀抢券</span>
          <el-button @click="loadActivities">刷新</el-button>
        </div>
      </template>

      <div class="activity-list">
        <div v-for="activity in activityList" :key="activity.id" class="activity-item">
          <div class="activity-main">
            <div class="activity-title">{{ activity.title }}</div>
            <div class="activity-desc">{{ activity.description || '全场电池商品通用，抢券成功后按生效时间使用。' }}</div>
            <div class="activity-meta">
              <el-tag type="warning">{{ activity.pointsCost }} 积分</el-tag>
              <el-tag type="success">剩余 {{ Math.max((activity.stock || 0) - (activity.sold || 0), 0) }} 张</el-tag>
              <el-tag>每人限抢 1 张</el-tag>
            </div>
            <div class="activity-time">
              秒杀时间：{{ activity.startTime }} 至 {{ activity.endTime }}
            </div>
            <div class="activity-time">
              用券时间：{{ activity.couponStartTime }} 至 {{ activity.couponEndTime }}
            </div>
          </div>
          <div class="activity-action">
            <el-button type="primary" :disabled="isDisabled(activity)" @click="handleSeckill(activity)">
              {{ getActionText(activity) }}
            </el-button>
          </div>
        </div>
      </div>

      <el-empty v-if="activityList.length === 0" description="暂无秒杀活动" />
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getOnlineSeckillActivities, seckillCoupon } from '@/api/seckill'

const activityList = ref([])

// 加载已上架活动
const loadActivities = async () => {
  const res = await getOnlineSeckillActivities()
  activityList.value = res.data || []
}

// 判断活动是否可抢
const isDisabled = (activity) => {
  const now = Date.now()
  return activity.status !== 1 ||
    now < new Date(activity.startTime).getTime() ||
    now > new Date(activity.endTime).getTime() ||
    (activity.stock || 0) - (activity.sold || 0) <= 0
}

// 获取按钮文案
const getActionText = (activity) => {
  const now = Date.now()
  if (now < new Date(activity.startTime).getTime()) return '未开始'
  if (now > new Date(activity.endTime).getTime()) return '已结束'
  if ((activity.stock || 0) - (activity.sold || 0) <= 0) return '已抢完'
  return '立即抢券'
}

// 执行秒杀抢券
const handleSeckill = async (activity) => {
  await ElMessageBox.confirm(`确定使用 ${activity.pointsCost} 积分参与秒杀吗？`, '确认抢券')
  await seckillCoupon(activity.id)
  ElMessage.success('抢券成功，优惠券将在生效时间后可用')
  loadActivities()
}

onMounted(loadActivities)
</script>

<style scoped>
.page-card {
  min-height: 420px;
}

.card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.activity-list {
  display: grid;
  gap: 16px;
}

.activity-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 24px;
  padding: 20px;
  border: 1px solid #e4e7ed;
  border-radius: 8px;
  background: #ffffff;
}

.activity-main {
  min-width: 0;
}

.activity-title {
  font-size: 18px;
  font-weight: 700;
  color: #303133;
  margin-bottom: 8px;
}

.activity-desc {
  color: #606266;
  line-height: 1.6;
  margin-bottom: 12px;
}

.activity-meta {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin-bottom: 10px;
}

.activity-time {
  font-size: 13px;
  color: #909399;
  line-height: 1.7;
}

.activity-action {
  flex: 0 0 120px;
}

.activity-action .el-button {
  width: 100%;
}
</style>
