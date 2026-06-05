<template>
  <div class="exchange-record-manage">
    <el-card>
      <template #header>
        <span>兑换记录管理</span>
      </template>

      <el-table :data="recordList" border stripe>
        <el-table-column type="index" label="序号" width="60" align="center" />
        <el-table-column prop="id" label="记录ID" width="80" align="center" />
        <el-table-column prop="userId" label="用户ID" width="80" align="center" />
        <el-table-column prop="productName" label="商品名称" min-width="150" />
        <el-table-column prop="pointsUsed" label="使用积分" width="100" align="center" />
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
        <el-table-column label="操作" width="200" align="center" fixed="right">
          <template #default="{ row }">
            <el-button
              v-if="row.exchangeStatus === 0"
              type="success"
              size="small"
              @click="updateStatus(row.id, 1)"
            >
              发货
            </el-button>
            <el-button
              v-if="row.exchangeStatus === 1"
              type="primary"
              size="small"
              @click="updateStatus(row.id, 2)"
            >
              完成
            </el-button>
            <el-button type="info" size="small" @click="viewDetail(row)">详情</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <!-- 详情对话框 -->
    <el-dialog title="兑换详情" v-model="detailVisible" width="600px">
      <el-descriptions :column="1" border>
        <el-descriptions-item label="记录ID">{{ currentRecord.id }}</el-descriptions-item>
        <el-descriptions-item label="用户ID">{{ currentRecord.userId }}</el-descriptions-item>
        <el-descriptions-item label="商品名称">{{ currentRecord.productName }}</el-descriptions-item>
        <el-descriptions-item label="使用积分">{{ currentRecord.pointsUsed }}</el-descriptions-item>
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
      </el-descriptions>
      <template #footer>
        <el-button @click="detailVisible = false">关闭</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import request from '@/utils/request'

const recordList = ref([])
const detailVisible = ref(false)
const currentRecord = reactive({})

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
    const res = await request.get('/exchange-record/list')
    recordList.value = res.data
  } catch (error) {
    ElMessage.error('加载兑换记录失败')
  }
}

// 更新状态
const updateStatus = (id, status) => {
  const statusText = getStatusText(status)
  ElMessageBox.confirm(`确定要将状态更新为"${statusText}"吗？`, '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    try {
      await request.put(`/exchange-record/${id}/status`, { status })
      ElMessage.success('状态更新成功')
      loadRecords()
    } catch (error) {
      ElMessage.error('状态更新失败')
    }
  })
}

// 查看详情
const viewDetail = (row) => {
  Object.assign(currentRecord, row)
  detailVisible.value = true
}

onMounted(() => {
  loadRecords()
})
</script>

<style scoped>
.exchange-record-manage {
  padding: 20px;
}
</style>













































