<template>
  <div class="user-management">
    <h2 class="page-title">用户管理</h2>
    
    <el-card class="custom-card" shadow="hover">
      <template #header>
        <div style="display: flex; justify-content: space-between; align-items: center;">
          <span class="card-title">用户列表</span>
          <el-button type="primary" @click="handleAdd" :icon="Plus">添加用户</el-button>
        </div>
      </template>
      
      <!-- 搜索框 -->
      <div style="margin-bottom: 20px;">
        <el-form :inline="true" :model="searchForm">
          <el-form-item label="用户ID">
            <el-input v-model.number="searchForm.userId" placeholder="请输入用户ID" clearable style="width: 150px;" />
          </el-form-item>
          <el-form-item label="用户名">
            <el-input v-model="searchForm.username" placeholder="请输入用户名" clearable style="width: 200px;" />
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="handleSearch" :icon="Search">搜索</el-button>
            <el-button @click="handleReset" :icon="Refresh">重置</el-button>
          </el-form-item>
        </el-form>
      </div>
      
      <el-table :data="userList" style="width: 100%" v-loading="loading">
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column label="头像" width="80" align="center">
          <template #default="{ row }">
            <el-avatar :size="50" :src="row.avatar" v-if="row.avatar">
              <template #error>
                <el-icon><User /></el-icon>
              </template>
            </el-avatar>
            <el-avatar :size="50" v-else>
              <el-icon><User /></el-icon>
            </el-avatar>
          </template>
        </el-table-column>
        <el-table-column prop="username" label="用户名" width="150" />
        <el-table-column prop="nickname" label="昵称" width="150" />
        <el-table-column prop="phone" label="手机号" width="150" />
        <el-table-column prop="email" label="邮箱" width="200" />
        <el-table-column label="角色" width="100">
          <template #default="{ row }">
            <el-tag :type="row.role === 1 ? 'danger' : 'primary'">
              {{ row.role === 1 ? '管理员' : '普通用户' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.status === 1 ? 'success' : 'info'">
              {{ row.status === 1 ? '正常' : '禁用' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="注册时间" width="180" />
        <el-table-column label="操作" width="280" fixed="right" align="center">
          <template #default="{ row }">
            <div style="display: flex; gap: 8px; justify-content: center; flex-wrap: wrap;">
              <el-button
                type="primary"
                size="small"
                @click="handleEdit(row)"
                :icon="Edit"
              >
                编辑
              </el-button>
              <el-button
                type="warning"
                size="small"
                @click="handleResetPassword(row)"
              >
                重置密码
              </el-button>
              <el-button
                type="danger"
                size="small"
                @click="handleDelete(row)"
                :icon="Delete"
                v-if="row.role !== 1"
              >
                删除
              </el-button>
            </div>
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
    
    <!-- 添加/编辑对话框 -->
    <el-dialog v-model="dialogVisible" :title="isEdit ? '编辑用户' : '添加用户'" width="500px">
      <el-form :model="editForm" :rules="rules" ref="formRef" label-width="80px">
        <el-form-item label="头像" v-if="isEdit">
          <div style="display: flex; align-items: center; gap: 20px;">
            <el-avatar :size="80" :src="editForm.avatar" v-if="editForm.avatar">
              <template #error>
                <el-icon><User /></el-icon>
              </template>
            </el-avatar>
            <el-avatar :size="80" v-else>
              <el-icon><User /></el-icon>
            </el-avatar>
            <el-upload
              :show-file-list="false"
              :before-upload="beforeAvatarUpload"
              :http-request="handleAvatarUpload"
              accept="image/*"
            >
              <el-button type="primary" size="small">更换头像</el-button>
            </el-upload>
          </div>
          <div style="color: #999; font-size: 12px; margin-top: 8px;">
            支持 jpg、png、gif 格式，大小不超过 2MB
          </div>
        </el-form-item>
        <el-form-item label="用户名" prop="username" v-if="!isEdit">
          <el-input v-model="editForm.username" placeholder="请输入用户名" />
        </el-form-item>
        <el-form-item label="密码" prop="password" v-if="!isEdit">
          <el-input v-model="editForm.password" type="password" placeholder="请输入密码" />
        </el-form-item>
        <el-form-item label="昵称">
          <el-input v-model="editForm.nickname" placeholder="请输入昵称" />
        </el-form-item>
        <el-form-item label="手机号">
          <el-input v-model="editForm.phone" placeholder="请输入手机号" />
        </el-form-item>
        <el-form-item label="邮箱">
          <el-input v-model="editForm.email" placeholder="请输入邮箱" />
        </el-form-item>
        <el-form-item label="角色" v-if="!isEdit">
          <el-radio-group v-model="editForm.role">
            <el-radio :label="0">普通用户</el-radio>
            <el-radio :label="1">管理员</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="状态">
          <el-radio-group v-model="editForm.status">
            <el-radio :label="1">正常</el-radio>
            <el-radio :label="0">禁用</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSave">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus, Edit, Delete, User, Search, Refresh } from '@element-plus/icons-vue'
import { getUserList, updateUser, deleteUser } from '@/api/user'
import request from '@/utils/request'

const loading = ref(false)
const userList = ref([])
const dialogVisible = ref(false)
const isEdit = ref(false)
const editForm = ref({})
const formRef = ref(null)

// 搜索表单
const searchForm = ref({
  userId: null,
  username: ''
})

// 分页相关
const pageNum = ref(1)
const pageSize = ref(10)
const total = ref(0)

const rules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    { min: 3, max: 20, message: '用户名长度在3-20个字符', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, max: 20, message: '密码长度在6-20个字符', trigger: 'blur' }
  ]
}

const loadUserList = async () => {
  loading.value = true
  try {
    const params = {
      pageNum: pageNum.value,
      pageSize: pageSize.value
    }
    
    // 添加搜索条件
    if (searchForm.value.userId) {
      params.userId = searchForm.value.userId
    }
    if (searchForm.value.username) {
      params.username = searchForm.value.username
    }
    
    const res = await request({
      url: '/user/page',
      method: 'get',
      params
    })
    userList.value = res.data.list || []
    total.value = res.data.total || 0
  } catch (error) {
    console.error('加载用户列表失败：', error)
  } finally {
    loading.value = false
  }
}

const handleSearch = () => {
  pageNum.value = 1
  loadUserList()
}

const handleReset = () => {
  searchForm.value = {
    userId: null,
    username: ''
  }
  pageNum.value = 1
  loadUserList()
}

const handleSizeChange = (val) => {
  pageSize.value = val
  pageNum.value = 1
  loadUserList()
}

const handleCurrentChange = (val) => {
  pageNum.value = val
  loadUserList()
}

const handleAdd = () => {
  isEdit.value = false
  editForm.value = {
    username: '',
    password: '',
    nickname: '',
    phone: '',
    email: '',
    role: 0,
    status: 1
  }
  dialogVisible.value = true
}

const handleEdit = (row) => {
  isEdit.value = true
  editForm.value = { ...row }
  dialogVisible.value = true
}

const handleSave = async () => {
  if (!formRef.value) return
  
  await formRef.value.validate(async (valid) => {
    if (valid) {
      try {
        if (isEdit.value) {
          await updateUser(editForm.value)
          ElMessage.success('更新成功')
        } else {
          await request({
            url: '/user',
            method: 'post',
            data: editForm.value
          })
          ElMessage.success('添加成功')
        }
        dialogVisible.value = false
        loadUserList()
      } catch (error) {
        console.error('保存失败：', error)
      }
    }
  })
}

const handleDelete = (row) => {
  ElMessageBox.confirm(`确定要删除用户"${row.username}"吗？`, '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    try {
      await deleteUser(row.id)
      ElMessage.success('删除成功')
      loadUserList()
    } catch (error) {
      console.error('删除失败：', error)
    }
  }).catch(() => {})
}

const handleResetPassword = (row) => {
  ElMessageBox.confirm(`确定将用户“${row.username}”的密码重置为 123456 吗？`, '重置密码', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    try {
      await updateUser({
        id: row.id,
        password: '123456'
      })
      ElMessage.success(`用户“${row.username}”密码已重置为 123456`)
    } catch (error) {
      console.error('重置密码失败：', error)
    }
  }).catch(() => {})
}

// 上传前检查
const beforeAvatarUpload = (file) => {
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

// 自定义上传方法（管理员编辑用户头像）
const handleAvatarUpload = async ({ file }) => {
  try {
    const formData = new FormData()
    formData.append('file', file)
    
    // 使用专门的上传接口，只上传文件不更新数据库
    const res = await request({
      url: '/user/upload-avatar',
      method: 'post',
      data: formData,
      headers: {
        'Content-Type': 'multipart/form-data'
      }
    })
    
    // 更新表单中的头像URL，点击保存时才会更新到数据库
    editForm.value.avatar = res.data
    ElMessage.success('头像上传成功，请点击保存按钮')
  } catch (error) {
    console.error('头像上传失败：', error)
    ElMessage.error(error.message || '头像上传失败')
  }
}

onMounted(() => {
  loadUserList()
})
</script>

<style scoped>
.user-management {
  animation: fadeIn 0.5s ease;
}

.card-title {
  font-size: 18px;
  font-weight: 600;
  color: var(--text-primary);
}
</style>

