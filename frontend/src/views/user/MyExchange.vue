<template>
  <div class="my-exchange">
    <el-card>
      <template #header>
        <div style="display: flex; justify-content: space-between; align-items: center;">
          <span>我的兑换记录</span>
          <el-button type="success" size="small" @click="handleRefresh" :loading="refreshLoading">
            <el-icon><Refresh /></el-icon>
            刷新状态
          </el-button>
        </div>
      </template>

      <el-table :data="recordList" border stripe>
        <el-table-column type="index" label="序号" width="60" align="center" />
        <el-table-column prop="productName" label="商品名称" min-width="150" />
        <el-table-column prop="pointsUsed" label="使用积分" width="100" align="center">
          <template #default="{ row }">
            <span style="color: #f56c6c; font-weight: bold;">{{ row.pointsUsed }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="quantity" label="数量" width="80" align="center" />
        <el-table-column label="状态" width="100" align="center">
          <template #default="{ row }">
            <el-tag :type="getStatusType(row.exchangeStatus)">
              {{ getStatusText(row.exchangeStatus) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="contactPhone" label="联系电话" width="120" />
        <el-table-column prop="shippingAddress" label="收货地址" min-width="200" show-overflow-tooltip />
        <el-table-column prop="createTime" label="兑换时间" width="160" />
        <el-table-column label="操作" width="100" align="center" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" size="small" @click="viewDetail(row)">详情</el-button>
          </template>
        </el-table-column>
      </el-table>

      <el-empty v-if="recordList.length === 0" description="暂无兑换记录" />
    </el-card>

    <!-- 详情对话框 -->
    <el-dialog title="兑换详情" v-model="detailVisible" width="600px">
      <el-descriptions :column="1" border>
        <el-descriptions-item label="商品名称">{{ currentRecord.productName }}</el-descriptions-item>
        <el-descriptions-item label="使用积分">
          <span style="color: #f56c6c; font-weight: bold;">{{ currentRecord.pointsUsed }}</span>
        </el-descriptions-item>
        <el-descriptions-item label="数量">{{ currentRecord.quantity }}</el-descriptions-item>
        <el-descriptions-item label="状态">
          <el-tag :type="getStatusType(currentRecord.exchangeStatus)">
            {{ getStatusText(currentRecord.exchangeStatus) }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="联系电话">{{ currentRecord.contactPhone }}</el-descriptions-item>
        <el-descriptions-item label="收货地址">{{ currentRecord.shippingAddress }}</el-descriptions-item>
        <el-descriptions-item label="备注">{{ currentRecord.remark || '无' }}</el-descriptions-item>
        <el-descriptions-item label="兑换时间">{{ currentRecord.createTime }}</el-descriptions-item>
        <el-descriptions-item label="更新时间">{{ currentRecord.updateTime }}</el-descriptions-item>
      </el-descriptions>
      <template #footer>
        <el-button type="primary" @click="detailVisible = false">关闭</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, onUnmounted, onActivated } from 'vue'
import { ElMessage } from 'element-plus'
import { Refresh } from '@element-plus/icons-vue'
import request from '@/utils/request'

const recordList = ref([])
const detailVisible = ref(false)
const currentRecord = reactive({})
const refreshLoading = ref(false)
let autoRefreshTimer = null

// 状态文本映射
const getStatusText = (status) => {
  const map = {
    0: '待发货',
    1: '已发货',
    2: '已完成',
    3: '已取消'
  }
  return map[status] || '未知'
}

// 状态类型映射
const getStatusType = (status) => {
  const map = {
    0: 'warning',
    1: 'primary',
    2: 'success',
    3: 'info'
  }
  return map[status] || 'info'
}

// 加载兑换记录
const loadRecords = async () => {
  try {
    const res = await request.get('/exchange-record/my')
    recordList.value = res.data
  } catch (error) {
    ElMessage.error('加载兑换记录失败')
  }
}

// 查看详情
const viewDetail = (row) => {
  Object.assign(currentRecord, row)
  detailVisible.value = true
}

// 手动刷新
const handleRefresh = async () => {
  refreshLoading.value = true
  try {
    await loadRecords()
    ElMessage.success('兑换记录已刷新')
  } catch (error) {
    ElMessage.error('刷新失败')
  } finally {
    refreshLoading.value = false
  }
}

// 启动自动刷新
const startAutoRefresh = () => {
  // 每30秒自动刷新一次
  autoRefreshTimer = setInterval(() => {
    loadRecords()
  }, 30000)
}

// 停止自动刷新
const stopAutoRefresh = () => {
  if (autoRefreshTimer) {
    clearInterval(autoRefreshTimer)
    autoRefreshTimer = null
  }
}

onMounted(() => {
  loadRecords()
  startAutoRefresh()
})

onUnmounted(() => {
  stopAutoRefresh()
})

// 页面激活时刷新
onActivated(() => {
  loadRecords()
})
</script>

<style scoped>
.my-exchange {
  padding: 20px;
}
</style>















