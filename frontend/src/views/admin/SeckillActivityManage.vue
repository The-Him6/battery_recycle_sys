<template>
  <div class="seckill-manage">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>秒杀活动管理</span>
          <el-button type="primary" @click="openDialog()">新增活动</el-button>
        </div>
      </template>

      <el-table :data="activityList" border>
        <el-table-column prop="title" label="活动名称" min-width="160" />
        <el-table-column prop="stock" label="库存" width="90" />
        <el-table-column prop="sold" label="已售" width="90" />
        <el-table-column prop="pointsCost" label="积分价" width="90" />
        <el-table-column prop="startTime" label="开始时间" min-width="160" />
        <el-table-column prop="endTime" label="结束时间" min-width="160" />
        <el-table-column label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="getStatusType(row.status)">{{ getStatusText(row.status) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="300" fixed="right">
          <template #default="{ row }">
            <el-button size="small" @click="openDialog(row)">编辑</el-button>
            <el-button size="small" type="success" @click="handleOnline(row.id)">上架</el-button>
            <el-button size="small" type="warning" @click="handlePreheat(row.id)">预热</el-button>
            <el-button size="small" type="danger" @click="handleOffline(row.id)">下架</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <el-dialog v-model="dialogVisible" :title="form.id ? '编辑秒杀活动' : '新增秒杀活动'" width="720px">
      <el-form ref="formRef" :model="form" :rules="rules" label-width="120px">
        <el-form-item label="活动名称" prop="title">
          <el-input v-model="form.title" placeholder="例如：周末电池兑换秒杀券" />
        </el-form-item>
        <el-form-item label="活动说明">
          <el-input v-model="form.description" type="textarea" :rows="3" placeholder="说明秒杀券使用规则" />
        </el-form-item>
        <el-form-item label="库存" prop="stock">
          <el-input-number v-model="form.stock" :min="1" :max="10000" />
        </el-form-item>
        <el-form-item label="秒杀积分" prop="pointsCost">
          <el-input-number v-model="form.pointsCost" :min="1" :max="100000" />
        </el-form-item>
        <el-form-item label="秒杀开始" prop="startTime">
          <el-date-picker v-model="form.startTime" type="datetime" value-format="YYYY-MM-DD HH:mm:ss" />
        </el-form-item>
        <el-form-item label="秒杀结束" prop="endTime">
          <el-date-picker v-model="form.endTime" type="datetime" value-format="YYYY-MM-DD HH:mm:ss" />
        </el-form-item>
        <el-form-item label="券生效时间" prop="couponStartTime">
          <el-date-picker v-model="form.couponStartTime" type="datetime" value-format="YYYY-MM-DD HH:mm:ss" />
        </el-form-item>
        <el-form-item label="券过期时间" prop="couponEndTime">
          <el-date-picker v-model="form.couponEndTime" type="datetime" value-format="YYYY-MM-DD HH:mm:ss" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitForm">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { reactive, ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  addSeckillActivity,
  getSeckillActivityList,
  offlineSeckillActivity,
  onlineSeckillActivity,
  preheatSeckillActivity,
  updateSeckillActivity
} from '@/api/seckill'

const activityList = ref([])
const dialogVisible = ref(false)
const formRef = ref(null)

const form = reactive({
  id: null,
  title: '',
  description: '',
  stock: 100,
  sold: 0,
  pointsCost: 500,
  startTime: '',
  endTime: '',
  couponStartTime: '',
  couponEndTime: ''
})

const rules = {
  title: [{ required: true, message: '请输入活动名称', trigger: 'blur' }],
  stock: [{ required: true, message: '请输入库存', trigger: 'blur' }],
  pointsCost: [{ required: true, message: '请输入秒杀积分', trigger: 'blur' }],
  startTime: [{ required: true, message: '请选择秒杀开始时间', trigger: 'change' }],
  endTime: [{ required: true, message: '请选择秒杀结束时间', trigger: 'change' }],
  couponStartTime: [{ required: true, message: '请选择券生效时间', trigger: 'change' }],
  couponEndTime: [{ required: true, message: '请选择券过期时间', trigger: 'change' }]
}

// 加载活动列表
const loadActivities = async () => {
  const res = await getSeckillActivityList()
  activityList.value = res.data || []
}

// 打开新增或编辑弹窗
const openDialog = (row) => {
  Object.assign(form, {
    id: row?.id || null,
    title: row?.title || '',
    description: row?.description || '',
    stock: row?.stock ?? 100,
    sold: row?.sold ?? 0,
    pointsCost: row?.pointsCost ?? 500,
    startTime: row?.startTime || '',
    endTime: row?.endTime || '',
    couponStartTime: row?.couponStartTime || '',
    couponEndTime: row?.couponEndTime || ''
  })
  dialogVisible.value = true
}

// 保存活动
const submitForm = () => {
  formRef.value.validate(async (valid) => {
    if (!valid) return
    if (form.id) {
      await updateSeckillActivity(form)
    } else {
      await addSeckillActivity(form)
    }
    ElMessage.success('保存成功')
    dialogVisible.value = false
    loadActivities()
  })
}

// 上架活动并触发Redis库存预热
const handleOnline = async (id) => {
  await onlineSeckillActivity(id)
  ElMessage.success('已上架并预热库存')
  loadActivities()
}

// 手动预热Redis库存
const handlePreheat = async (id) => {
  await preheatSeckillActivity(id)
  ElMessage.success('预热成功')
}

// 下架活动
const handleOffline = async (id) => {
  await ElMessageBox.confirm('确定下架该活动吗？', '提示')
  await offlineSeckillActivity(id)
  ElMessage.success('已下架')
  loadActivities()
}

const getStatusText = (status) => ({ 0: '草稿', 1: '上架', 2: '下架', 3: '结束' }[status] || '未知')
const getStatusType = (status) => ({ 0: 'info', 1: 'success', 2: 'warning', 3: 'danger' }[status] || 'info')

onMounted(loadActivities)
</script>

<style scoped>
.card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}
</style>
