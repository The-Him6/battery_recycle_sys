<template>
  <div class="notice-manage">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>系统弹窗管理</span>
          <el-button type="primary" @click="openDialog()">新增公告</el-button>
        </div>
      </template>

      <el-table :data="noticeList" border>
        <el-table-column prop="title" label="标题" min-width="160" />
        <el-table-column prop="content" label="内容" min-width="240" show-overflow-tooltip />
        <el-table-column prop="activityId" label="关联活动" width="100" />
        <el-table-column prop="popupStartTime" label="开始展示" min-width="160" />
        <el-table-column prop="popupEndTime" label="结束展示" min-width="160" />
        <el-table-column label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="getStatusType(row.status)">{{ getStatusText(row.status) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="120">
          <template #default="{ row }">
            <el-button size="small" @click="openDialog(row)">编辑</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <el-dialog v-model="dialogVisible" :title="form.id ? '编辑公告' : '新增公告'" width="680px">
      <el-form ref="formRef" :model="form" :rules="rules" label-width="120px">
        <el-form-item label="标题" prop="title">
          <el-input v-model="form.title" />
        </el-form-item>
        <el-form-item label="内容" prop="content">
          <el-input v-model="form.content" type="textarea" :rows="5" />
        </el-form-item>
        <el-form-item label="关联活动ID">
          <el-input-number v-model="form.activityId" :min="1" />
        </el-form-item>
        <el-form-item label="展示开始" prop="popupStartTime">
          <el-date-picker v-model="form.popupStartTime" type="datetime" value-format="YYYY-MM-DD HH:mm:ss" />
        </el-form-item>
        <el-form-item label="展示结束" prop="popupEndTime">
          <el-date-picker v-model="form.popupEndTime" type="datetime" value-format="YYYY-MM-DD HH:mm:ss" />
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="form.status">
            <el-option label="草稿" :value="0" />
            <el-option label="已发布" :value="1" />
            <el-option label="已撤回" :value="2" />
          </el-select>
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
import { ElMessage } from 'element-plus'
import { addNotice, getNoticeList, updateNotice } from '@/api/notice'

const noticeList = ref([])
const dialogVisible = ref(false)
const formRef = ref(null)

const form = reactive({
  id: null,
  title: '',
  content: '',
  activityId: null,
  popupStartTime: '',
  popupEndTime: '',
  status: 0
})

const rules = {
  title: [{ required: true, message: '请输入标题', trigger: 'blur' }],
  content: [{ required: true, message: '请输入内容', trigger: 'blur' }],
  popupStartTime: [{ required: true, message: '请选择展示开始时间', trigger: 'change' }],
  popupEndTime: [{ required: true, message: '请选择展示结束时间', trigger: 'change' }]
}

// 加载公告列表
const loadNotices = async () => {
  const res = await getNoticeList()
  noticeList.value = res.data || []
}

// 打开编辑弹窗
const openDialog = (row) => {
  Object.assign(form, {
    id: row?.id || null,
    title: row?.title || '',
    content: row?.content || '',
    activityId: row?.activityId || null,
    popupStartTime: row?.popupStartTime || '',
    popupEndTime: row?.popupEndTime || '',
    status: row?.status ?? 0
  })
  dialogVisible.value = true
}

// 保存公告
const submitForm = () => {
  formRef.value.validate(async (valid) => {
    if (!valid) return
    if (form.id) {
      await updateNotice(form)
    } else {
      await addNotice(form)
    }
    ElMessage.success('保存成功')
    dialogVisible.value = false
    loadNotices()
  })
}

const getStatusText = (status) => ({ 0: '草稿', 1: '已发布', 2: '已撤回' }[status] || '未知')
const getStatusType = (status) => ({ 0: 'info', 1: 'success', 2: 'warning' }[status] || 'info')

onMounted(loadNotices)
</script>

<style scoped>
.card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}
</style>
