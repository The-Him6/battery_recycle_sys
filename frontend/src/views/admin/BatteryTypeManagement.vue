<template>
  <div class="battery-type-management">
    <h2 class="page-title">电池种类管理</h2>
    
    <el-card class="custom-card" shadow="hover">
      <template #header>
        <div style="display: flex; justify-content: space-between; align-items: center;">
          <span class="card-title">电池种类列表</span>
          <el-button type="primary" @click="handleAdd" :icon="Plus">添加电池种类</el-button>
        </div>
      </template>
      
      <el-table :data="batteryTypeList" style="width: 100%" v-loading="loading">
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="typeName" label="种类名称" width="150" />
        <el-table-column label="电池图标" width="100" align="center">
          <template #default="{ row }">
            <img
              v-if="row.icon"
              :src="row.icon"
              alt="电池图标"
              style="width: 60px; height: 60px; border-radius: 4px; object-fit: cover; cursor: pointer;"
              @click="previewImage(row.icon)"
            />
            <span v-else style="color: #999;">暂无图标</span>
          </template>
        </el-table-column>
        <el-table-column prop="description" label="电池说明" min-width="180" show-overflow-tooltip />
        <el-table-column prop="identificationGuide" label="如何识别" min-width="150" show-overflow-tooltip />
        <el-table-column prop="points" label="积分" width="100" />
        <el-table-column label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.status === 1 ? 'success' : 'info'">
              {{ row.status === 1 ? '启用' : '禁用' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="创建时间" width="180" />
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" size="small" @click="handleEdit(row)" :icon="Edit">
              编辑
            </el-button>
            <el-button type="danger" size="small" @click="handleDelete(row)" :icon="Delete">
              删除
            </el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
    
    <!-- 添加/编辑对话框 -->
    <el-dialog v-model="dialogVisible" :title="isEdit ? '编辑电池种类' : '添加电池种类'" width="600px">
      <el-form :model="form" :rules="rules" ref="formRef" label-width="120px">
        <el-form-item label="种类名称" prop="typeName">
          <el-input v-model="form.typeName" placeholder="请输入种类名称" />
        </el-form-item>
        <el-form-item label="电池图标" prop="icon">
          <el-upload
            class="icon-uploader"
            :show-file-list="false"
            :before-upload="beforeIconUpload"
            :http-request="handleIconUpload"
            accept="image/*"
          >
            <img v-if="form.icon" :src="form.icon" class="icon-image" />
            <el-icon v-else class="icon-uploader-icon"><Plus /></el-icon>
          </el-upload>
          <div style="color: #999; font-size: 12px; margin-top: 5px;">
            支持 jpg、png、gif 格式，大小不超过 2MB
          </div>
        </el-form-item>
        <el-form-item label="电池说明" prop="description">
          <el-input v-model="form.description" type="textarea" :rows="3" placeholder="请输入用户端创建回收订单页面展示的电池说明" />
        </el-form-item>
        <el-form-item label="如何识别电池" prop="identificationGuide">
          <el-input 
            v-model="form.identificationGuide" 
            type="textarea" 
            :rows="4" 
            placeholder="请输入如何识别该类型电池的方法，例如：外观特征、标识、尺寸等"
          />
        </el-form-item>
        <el-form-item label="积分" prop="points">
          <el-input-number v-model="form.points" :min="0" :max="1000" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="form.status">
            <el-radio :label="1">启用</el-radio>
            <el-radio :label="0">禁用</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSave">保存</el-button>
      </template>
    </el-dialog>

    <!-- 图片预览对话框 -->
    <el-dialog v-model="imagePreviewVisible" width="600px" :show-close="true">
      <img :src="previewImageUrl" style="width: 100%; display: block;" alt="预览图片" />
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus, Edit, Delete } from '@element-plus/icons-vue'
import { getBatteryTypeList, addBatteryType, updateBatteryType, deleteBatteryType } from '@/api/batteryType'
import { uploadBatteryIcon } from '@/api/batteryType'

const loading = ref(false)
const batteryTypeList = ref([])
const dialogVisible = ref(false)
const isEdit = ref(false)
const formRef = ref(null)
const imagePreviewVisible = ref(false)
const previewImageUrl = ref('')

const form = ref({
  typeName: '',
  description: '',
  identificationGuide: '',
  icon: '',
  points: 0,
  status: 1
})

const rules = {
  typeName: [{ required: true, message: '请输入种类名称', trigger: 'blur' }],
  points: [{ required: true, message: '请输入积分', trigger: 'blur' }]
}

const loadBatteryTypeList = async () => {
  loading.value = true
  try {
    const res = await getBatteryTypeList()
    batteryTypeList.value = res.data || []
  } catch (error) {
    console.error('加载电池种类列表失败：', error)
  } finally {
    loading.value = false
  }
}

const handleAdd = () => {
  isEdit.value = false
  form.value = {
    typeName: '',
    description: '',
    identificationGuide: '',
    icon: '',
    points: 0,
    status: 1
  }
  dialogVisible.value = true
}

const handleEdit = (row) => {
  isEdit.value = true
  form.value = { ...row }
  dialogVisible.value = true
}

const handleSave = async () => {
  if (!formRef.value) return
  
  await formRef.value.validate(async (valid) => {
    if (valid) {
      try {
        if (isEdit.value) {
          await updateBatteryType(form.value)
          ElMessage.success('更新成功')
        } else {
          await addBatteryType(form.value)
          ElMessage.success('添加成功')
        }
        dialogVisible.value = false
        loadBatteryTypeList()
      } catch (error) {
        console.error('保存失败：', error)
      }
    }
  })
}

const handleDelete = (row) => {
  ElMessageBox.confirm(`确定要删除电池种类"${row.typeName}"吗？`, '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    try {
      await deleteBatteryType(row.id)
      ElMessage.success('删除成功')
      loadBatteryTypeList()
    } catch (error) {
      console.error('删除失败：', error)
    }
  }).catch(() => {})
}

// 上传前检查
const beforeIconUpload = (file) => {
  const isImage = file.type.startsWith('image/')
  const isLt2M = file.size / 1024 / 1024 < 2

  if (!isImage) {
    ElMessage.error('只能上传图片文件!')
    return false
  }
  if (!isLt2M) {
    ElMessage.error('图片大小不能超过 2MB!')
    return false
  }
  return true
}

// 自定义上传方法
const handleIconUpload = async ({ file }) => {
  try {
    const res = await uploadBatteryIcon(file)
    form.value.icon = res.data
    ElMessage.success('图标上传成功')
  } catch (error) {
    console.error('图标上传失败：', error)
    ElMessage.error(error.message || '图标上传失败')
  }
}

// 预览图片
const previewImage = (url) => {
  previewImageUrl.value = url
  imagePreviewVisible.value = true
}

onMounted(() => {
  loadBatteryTypeList()
})
</script>

<style scoped>
.battery-type-management {
  animation: fadeIn 0.5s ease;
}

.card-title {
  font-size: 16px;
  font-weight: 600;
}

.icon-uploader {
  border: 1px dashed #d9d9d9;
  border-radius: 6px;
  cursor: pointer;
  overflow: hidden;
  transition: border-color 0.3s;
}

.icon-uploader:hover {
  border-color: #409eff;
}

.icon-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 120px;
  height: 120px;
  text-align: center;
  line-height: 120px;
}

.icon-image {
  width: 120px;
  height: 120px;
  display: block;
  object-fit: cover;
}
</style>

