<template>
  <div class="order-management">
    <h2 class="page-title">订单管理</h2>
    
    <el-card class="custom-card" shadow="hover">
      <!-- 搜索框 -->
      <div style="margin-bottom: 20px;">
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
          <el-form-item label="订单状态">
            <el-select v-model="searchForm.orderStatus" placeholder="请选择订单状态" clearable style="width: 160px;">
              <el-option label="待处理" :value="0" />
              <el-option label="处理中" :value="1" />
              <el-option label="已完成" :value="2" />
              <el-option label="已取消" :value="3" />
            </el-select>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="handleSearch" :icon="Search">搜索</el-button>
            <el-button @click="handleReset" :icon="Refresh">重置</el-button>
          </el-form-item>
        </el-form>
      </div>
      
      <el-table :data="orderList" style="width: 100%" v-loading="loading">
        <el-table-column prop="orderNumber" label="订单编号" width="200" />
        <el-table-column label="用户名" width="140">
          <template #default="{ row }">
            {{ getDisplayUserId(row) }}
          </template>
        </el-table-column>
        <el-table-column prop="totalCount" label="电池数量" width="120" />
        <el-table-column prop="totalPoints" label="获得积分" width="120" />
        <el-table-column prop="recycleAddress" label="回收地址" min-width="200" />
        <el-table-column prop="contactPhone" label="联系电话" width="150" />
        <el-table-column label="订单状态" width="120">
          <template #default="{ row }">
            <el-tag :type="getStatusType(row.orderStatus)">
              {{ getStatusText(row.orderStatus) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="创建时间" width="180" />
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" size="small" @click="handleViewDetail(row)" :icon="View">
              查看
            </el-button>
            <el-button
              type="success"
              size="small"
              @click="handleUpdateStatus(row)"
              :icon="Edit"
              v-if="row.orderStatus !== 2 && row.orderStatus !== 3"
            >
              处理
            </el-button>
          </template>
        </el-table-column>
      </el-table>
      
      <!-- 分页组件 -->
      <div style="margin-top: 20px; display: flex; justify-content: flex-end;">
        <el-pagination
          v-model:current-page="pageNum"
          v-model:page-size="pageSize"
          :page-sizes="[10, 20, 50, 100]"
          :total="total"
          layout="total, sizes, prev, pager, next, jumper"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        />
      </div>
    </el-card>
    
    <!-- 订单详情对话框 -->
    <el-dialog v-model="detailVisible" title="订单详情" width="800px">
      <el-descriptions :column="2" border v-if="currentOrder">
        <el-descriptions-item label="订单编号">{{ currentOrder.orderNumber }}</el-descriptions-item>
        <el-descriptions-item label="用户名">{{ getDisplayUserId(currentOrder) }}</el-descriptions-item>
        <el-descriptions-item label="电池总数">{{ currentOrder.totalCount }}</el-descriptions-item>
        <el-descriptions-item label="获得积分">{{ currentOrder.totalPoints }}</el-descriptions-item>
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
    
    <!-- 更新状态对话框 -->
    <el-dialog v-model="statusVisible" title="更新订单状态" width="400px">
      <el-form label-width="100px">
        <el-form-item label="订单状态">
          <el-select v-model="newStatus" placeholder="请选择状态">
            <el-option label="待处理" :value="0" />
            <el-option label="处理中" :value="1" />
            <el-option label="已完成" :value="2" />
            <el-option label="已取消" :value="3" />
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="statusVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSaveStatus">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { View, Edit, Search, Refresh } from '@element-plus/icons-vue'
import request from '@/utils/request'
import { getOrderById, updateOrderStatus } from '@/api/order'
import { getUserList } from '@/api/user'

const loading = ref(false)
const orderList = ref([])
const detailVisible = ref(false)
const statusVisible = ref(false)
const currentOrder = ref(null)
const orderDetails = ref([])
const newStatus = ref(null)
const currentOrderId = ref(null)
const userMap = ref({})

// 搜索表单
const searchForm = ref({
  address: '',
  dateRange: null,
  orderStatus: null
})

// 分页相关
const pageNum = ref(1)
const pageSize = ref(20)
const total = ref(0)

const getStatusType = (status) => {
  const types = { 0: 'warning', 1: 'primary', 2: 'success', 3: 'info' }
  return types[status] || 'info'
}

const getStatusText = (status) => {
  const texts = { 0: '待处理', 1: '处理中', 2: '已完成', 3: '已取消' }
  return texts[status] || '未知'
}

const getDisplayUserId = (row) => {
  const rawUserId = row.userId ?? row.user?.id ?? row.user?.userId
  if (!rawUserId) return '-'
  return userMap.value[rawUserId]?.username || String(rawUserId)
}

const loadUserMap = async () => {
  try {
    const res = await getUserList()
    const users = res.data || []
    userMap.value = users.reduce((map, user) => {
      map[user.id] = user
      return map
    }, {})
  } catch (error) {
    console.error('加载用户映射失败：', error)
  }
}

const loadOrderList = async () => {
  loading.value = true
  try {
    const params = {
      pageNum: pageNum.value,
      pageSize: pageSize.value
    }
    
    // 添加搜索条件
    if (searchForm.value.address) {
      params.address = searchForm.value.address
    }
    if (searchForm.value.dateRange && searchForm.value.dateRange.length === 2) {
      params.startDate = searchForm.value.dateRange[0]
      params.endDate = searchForm.value.dateRange[1]
    }
    if (searchForm.value.orderStatus !== null && searchForm.value.orderStatus !== undefined) {
      params.orderStatus = searchForm.value.orderStatus
    }
    
    const res = await request({
      url: '/order/page',
      method: 'get',
      params
    })
    orderList.value = res.data.list || []
    total.value = res.data.total || 0
  } catch (error) {
    console.error('加载订单列表失败：', error)
    ElMessage.error('加载订单列表失败')
  } finally {
    loading.value = false
  }
}

const handleSearch = () => {
  pageNum.value = 1
  loadOrderList()
}

const handleReset = () => {
  searchForm.value = {
    address: '',
    dateRange: null,
    orderStatus: null
  }
  pageNum.value = 1
  loadOrderList()
}

const handleSizeChange = (val) => {
  pageSize.value = val
  pageNum.value = 1
  loadOrderList()
}

const handleCurrentChange = (val) => {
  pageNum.value = val
  loadOrderList()
}

const handleViewDetail = async (row) => {
  try {
    const res = await getOrderById(row.id)
    currentOrder.value = res.data
    orderDetails.value = res.data.details || []
    detailVisible.value = true
  } catch (error) {
    console.error('加载订单详情失败：', error)
  }
}

const handleUpdateStatus = (row) => {
  currentOrderId.value = row.id
  newStatus.value = row.orderStatus
  statusVisible.value = true
}

const handleSaveStatus = async () => {
  try {
    await updateOrderStatus(currentOrderId.value, newStatus.value)
    ElMessage.success('更新成功')
    statusVisible.value = false
    loadOrderList()
  } catch (error) {
    console.error('更新状态失败：', error)
  }
}

onMounted(async () => {
  await loadUserMap()
  loadOrderList()
})
</script>

<style scoped>
.order-management {
  animation: fadeIn 0.5s ease;
}
</style>

