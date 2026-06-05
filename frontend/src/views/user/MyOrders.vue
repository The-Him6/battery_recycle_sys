<template>
  <div class="my-orders">
    <h2 class="page-title">我的订单</h2>
    
    <!-- 搜索框 -->
    <el-card class="custom-card search-card" shadow="hover">
      <el-form :inline="true" :model="searchForm">
        <el-form-item label="回收地址">
          <el-input v-model="searchForm.address" placeholder="请输入地址关键词" clearable style="width: 200px;" />
        </el-form-item>
        <el-form-item label="日期范围">
          <el-date-picker
            v-model="searchForm.dateRange"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            value-format="YYYY-MM-DD"
            style="width: 300px;"
          />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch" :icon="Search">搜索</el-button>
          <el-button @click="handleReset" :icon="Refresh">重置</el-button>
          <el-button type="success" @click="handleRefresh" :icon="Refresh" :loading="refreshLoading">刷新订单</el-button>
        </el-form-item>
      </el-form>
    </el-card>
    
    <!-- 订单筛选 -->
    <el-card class="custom-card filter-card" shadow="hover">
      <el-radio-group v-model="filterStatus" @change="handleFilterChange">
        <el-radio-button :label="null">全部</el-radio-button>
        <el-radio-button :label="0">待处理</el-radio-button>
        <el-radio-button :label="1">处理中</el-radio-button>
        <el-radio-button :label="2">已完成</el-radio-button>
        <el-radio-button :label="3">已取消</el-radio-button>
      </el-radio-group>
    </el-card>
    
    <!-- 订单列表 -->
    <div class="order-list">
      <el-card
        v-for="order in filteredOrders"
        :key="order.id"
        class="custom-card order-card"
        shadow="hover"
      >
        <div class="order-header">
          <div class="order-number">
            <el-icon><Document /></el-icon>
            <span>订单编号：{{ order.orderNumber }}</span>
          </div>
          <el-tag :type="getStatusType(order.orderStatus)">
            {{ getStatusText(order.orderStatus) }}
          </el-tag>
        </div>
        
        <el-divider />
        
        <el-row :gutter="20" class="order-info">
          <el-col :xs="24" :sm="12" :md="6">
            <div class="info-item">
              <span class="info-label">电池数量</span>
              <span class="info-value">{{ order.totalCount }} 个</span>
            </div>
          </el-col>
          <el-col :xs="24" :sm="12" :md="6">
            <div class="info-item">
              <span class="info-label">获得积分</span>
              <span class="info-value primary-color">{{ order.totalPoints }} 分</span>
            </div>
          </el-col>
          <el-col :xs="24" :sm="12" :md="6">
            <div class="info-item">
              <span class="info-label">回收地址</span>
              <span class="info-value">{{ order.recycleAddress }}</span>
            </div>
          </el-col>
          <el-col :xs="24" :sm="12" :md="6">
            <div class="info-item">
              <span class="info-label">创建时间</span>
              <span class="info-value">{{ order.createTime }}</span>
            </div>
          </el-col>
        </el-row>
        
        <div class="order-actions">
          <el-button type="primary" size="small" @click="handleViewDetail(order)" :icon="View">
            查看详情
          </el-button>
          <el-button
            type="danger"
            size="small"
            @click="handleCancel(order)"
            :icon="Close"
            v-if="order.orderStatus === 0"
          >
            取消订单
          </el-button>
        </div>
      </el-card>
      
      <el-empty v-if="filteredOrders.length === 0" description="暂无订单" />
    </div>
    
    <!-- 订单详情对话框 -->
    <el-dialog v-model="detailVisible" title="订单详情" width="800px">
      <el-descriptions :column="2" border v-if="currentOrder">
        <el-descriptions-item label="订单编号" :span="2">{{ currentOrder.orderNumber }}</el-descriptions-item>
        <el-descriptions-item label="电池总数">{{ currentOrder.totalCount }} 个</el-descriptions-item>
        <el-descriptions-item label="获得积分">{{ currentOrder.totalPoints }} 分</el-descriptions-item>
        <el-descriptions-item label="回收地址" :span="2">{{ currentOrder.recycleAddress }}</el-descriptions-item>
        <el-descriptions-item label="联系电话">{{ currentOrder.contactPhone }}</el-descriptions-item>
        <el-descriptions-item label="订单状态">
          <el-tag :type="getStatusType(currentOrder.orderStatus)">
            {{ getStatusText(currentOrder.orderStatus) }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="创建时间" :span="2">{{ currentOrder.createTime }}</el-descriptions-item>
        <el-descriptions-item label="备注" :span="2">{{ currentOrder.remark || '无' }}</el-descriptions-item>
      </el-descriptions>
      
      <el-divider>订单明细</el-divider>
      
      <el-table :data="orderDetails" style="width: 100%">
        <el-table-column prop="batteryTypeId" label="电池种类ID" width="120" />
        <el-table-column prop="batteryCount" label="数量" width="100" />
        <el-table-column prop="points" label="积分" width="100" />
        <el-table-column prop="createTime" label="创建时间" />
      </el-table>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted, onActivated } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Document, View, Close, Search, Refresh } from '@element-plus/icons-vue'
import { getMyOrders, getOrderById, cancelOrder } from '@/api/order'
import request from '@/utils/request'

const orderList = ref([])
const filterStatus = ref(null)
const detailVisible = ref(false)
const currentOrder = ref(null)
const orderDetails = ref([])
const refreshLoading = ref(false)
let autoRefreshTimer = null

// 搜索表单
const searchForm = ref({
  address: '',
  dateRange: null
})

const filteredOrders = computed(() => {
  if (filterStatus.value === null) {
    return orderList.value
  }
  return orderList.value.filter(order => order.orderStatus === filterStatus.value)
})

const getStatusType = (status) => {
  const types = { 0: 'warning', 1: 'primary', 2: 'success', 3: 'info' }
  return types[status] || 'info'
}

const getStatusText = (status) => {
  const texts = { 0: '待处理', 1: '处理中', 2: '已完成', 3: '已取消' }
  return texts[status] || '未知'
}

const loadOrderList = async () => {
  try {
    const params = {}
    
    // 添加搜索条件
    if (searchForm.value.address) {
      params.address = searchForm.value.address
    }
    if (searchForm.value.dateRange && searchForm.value.dateRange.length === 2) {
      params.startDate = searchForm.value.dateRange[0]
      params.endDate = searchForm.value.dateRange[1]
    }
    
    const res = await request({
      url: '/order/my',
      method: 'get',
      params
    })
    orderList.value = res.data || []
  } catch (error) {
    console.error('加载订单列表失败：', error)
  }
}

const handleSearch = () => {
  loadOrderList()
}

const handleReset = () => {
  searchForm.value = {
    address: '',
    dateRange: null
  }
  loadOrderList()
}

const handleRefresh = async () => {
  refreshLoading.value = true
  try {
    await loadOrderList()
    ElMessage.success('订单状态已刷新')
  } catch (error) {
    ElMessage.error('刷新失败')
  } finally {
    refreshLoading.value = false
  }
}

const handleFilterChange = () => {
  // 筛选逻辑已通过computed实现
}

// 启动自动刷新
const startAutoRefresh = () => {
  // 每30秒自动刷新一次
  autoRefreshTimer = setInterval(() => {
    loadOrderList()
  }, 30000)
}

// 停止自动刷新
const stopAutoRefresh = () => {
  if (autoRefreshTimer) {
    clearInterval(autoRefreshTimer)
    autoRefreshTimer = null
  }
}

const handleViewDetail = async (order) => {
  try {
    const res = await getOrderById(order.id)
    currentOrder.value = res.data
    orderDetails.value = res.data.details || []
    detailVisible.value = true
  } catch (error) {
    console.error('加载订单详情失败：', error)
  }
}

const handleCancel = (order) => {
  ElMessageBox.confirm('确定要取消该订单吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    try {
      await cancelOrder(order.id)
      ElMessage.success('订单已取消')
      loadOrderList()
    } catch (error) {
      console.error('取消订单失败：', error)
    }
  }).catch(() => {})
}

onMounted(() => {
  loadOrderList()
  startAutoRefresh()
})

onUnmounted(() => {
  stopAutoRefresh()
})

// 页面激活时刷新
onActivated(() => {
  loadOrderList()
})
</script>

<style scoped>
.my-orders {
  animation: fadeIn 0.5s ease;
}

.filter-card {
  margin-bottom: 24px;
}

.order-list {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.order-card {
  transition: all 0.3s ease;
}

.order-card:hover {
  transform: translateY(-4px);
}

.order-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.order-number {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 16px;
  font-weight: 600;
  color: var(--text-primary);
}

.order-info {
  margin: 20px 0;
}

.info-item {
  display: flex;
  flex-direction: column;
  gap: 8px;
  margin-bottom: 16px;
}

.info-label {
  font-size: 13px;
  color: var(--text-secondary);
}

.info-value {
  font-size: 15px;
  font-weight: 600;
  color: var(--text-primary);
}

.primary-color {
  color: var(--primary-color);
}

.order-actions {
  display: flex;
  gap: 12px;
  justify-content: flex-end;
}
</style>

