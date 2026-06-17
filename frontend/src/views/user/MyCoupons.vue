<template>
  <div class="my-coupons">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>我的券包</span>
          <el-button @click="loadCoupons">刷新</el-button>
        </div>
      </template>

      <el-table :data="couponList" border>
        <el-table-column prop="id" label="券ID" width="90" />
        <el-table-column prop="activityId" label="活动ID" width="100" />
        <el-table-column label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="getStatusType(row.status)">{{ getStatusText(row.status) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="effectiveTime" label="生效时间" min-width="160" />
        <el-table-column prop="expireTime" label="过期时间" min-width="160" />
        <el-table-column prop="usedProductId" label="使用商品" width="110" />
        <el-table-column prop="usedTime" label="使用时间" min-width="160" />
        <el-table-column label="操作" width="120">
          <template #default="{ row }">
            <el-button size="small" type="primary" :disabled="row.status !== 0" @click="$router.push('/user/points-exchange')">
              去兑换
            </el-button>
          </template>
        </el-table-column>
      </el-table>

      <el-empty v-if="couponList.length === 0" description="暂无秒杀券" />
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { getMySeckillCoupons } from '@/api/seckill'

const couponList = ref([])

// 加载我的秒杀券
const loadCoupons = async () => {
  const res = await getMySeckillCoupons()
  couponList.value = res.data || []
}

const getStatusText = (status) => ({ 0: '未使用', 1: '已使用', 2: '已过期' }[status] || '未知')
const getStatusType = (status) => ({ 0: 'success', 1: 'info', 2: 'danger' }[status] || 'info')

onMounted(loadCoupons)
</script>

<style scoped>
.card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}
</style>
