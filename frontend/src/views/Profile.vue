<template>
  <div class="profile">
    <h2 class="page-title">个人中心</h2>
    
    <el-row :gutter="20">
      <!-- 头像上传 -->
      <el-col :xs="24" :md="8">
        <el-card class="custom-card avatar-card" shadow="hover">
          <template #header>
            <span class="card-title">个人头像</span>
          </template>
          
          <div class="avatar-section">
            <el-avatar :size="120" :src="avatarUrl || defaultAvatar" />
            <el-upload
              :show-file-list="false"
              :before-upload="beforeAvatarUpload"
              :http-request="handleAvatarUpload"
              accept="image/*"
            >
              <el-button type="primary" :icon="Upload" style="margin-top: 20px;">
                上传头像
              </el-button>
            </el-upload>
            <p class="upload-tip">支持 JPG、PNG 格式，大小不超过 10MB</p>
          </div>
        </el-card>
      </el-col>
      
      <!-- 个人信息 -->
      <el-col :xs="24" :md="16">
        <el-card class="custom-card" shadow="hover">
          <template #header>
            <span class="card-title">个人信息</span>
          </template>
          
          <el-form :model="userForm" label-width="100px">
            <el-form-item label="用户名">
              <el-input v-model="userForm.username" disabled />
            </el-form-item>
            
            <el-form-item label="昵称">
              <el-input v-model="userForm.nickname" placeholder="请输入昵称" />
            </el-form-item>
            
            <el-form-item label="手机号">
              <el-input v-model="userForm.phone" placeholder="请输入手机号" />
            </el-form-item>
            
            <el-form-item label="邮箱">
              <el-input v-model="userForm.email" placeholder="请输入邮箱" />
            </el-form-item>
            
            <el-form-item label="角色">
              <el-tag :type="userForm.role === 1 ? 'danger' : 'primary'">
                {{ userForm.role === 1 ? '管理员' : '普通用户' }}
              </el-tag>
            </el-form-item>
            
            <el-form-item label="注册时间">
              <span>{{ userForm.createTime }}</span>
            </el-form-item>
            
            <el-form-item>
              <el-button type="primary" @click="handleSave" :loading="saving">
                保存修改
              </el-button>
              <el-button type="warning" @click="passwordDialogVisible = true">
                修改密码
              </el-button>
            </el-form-item>
          </el-form>
        </el-card>
      </el-col>
    </el-row>

    <el-dialog v-model="passwordDialogVisible" title="修改密码" width="460px" destroy-on-close>
      <el-form :model="passwordForm" :rules="passwordRules" ref="passwordFormRef" label-width="100px">
        <el-form-item label="原密码" prop="oldPassword">
          <el-input v-model="passwordForm.oldPassword" type="password" show-password placeholder="请输入原密码" />
        </el-form-item>

        <el-form-item label="新密码" prop="newPassword">
          <el-input v-model="passwordForm.newPassword" type="password" show-password placeholder="请输入新密码" />
        </el-form-item>

        <el-form-item label="确认新密码" prop="confirmPassword">
          <el-input v-model="passwordForm.confirmPassword" type="password" show-password placeholder="请再次输入新密码" />
        </el-form-item>
      </el-form>

      <template #footer>
        <el-button @click="handleClosePasswordDialog">取消</el-button>
        <el-button type="primary" @click="handleChangePassword" :loading="changingPassword">确认修改</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { ElMessage } from 'element-plus'
import { Upload } from '@element-plus/icons-vue'
import { changePassword, getCurrentUserInfo, updateUser, uploadAvatar } from '@/api/user'
import { useUserStore } from '@/stores/user'

const userStore = useUserStore()
const userForm = ref({})
const saving = ref(false)
const changingPassword = ref(false)
const passwordDialogVisible = ref(false)
const passwordFormRef = ref(null)
const passwordForm = ref({
  oldPassword: '',
  newPassword: '',
  confirmPassword: ''
})
const defaultAvatar = 'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png'

const validateConfirmPassword = (rule, value, callback) => {
  if (!value) {
    callback(new Error('请再次输入新密码'))
    return
  }
  if (passwordForm.value.oldPassword && value === passwordForm.value.oldPassword) {
    callback(new Error('新密码不能与原密码相同'))
    return
  }
  if (value !== passwordForm.value.newPassword) {
    callback(new Error('两次输入的新密码不一致'))
    return
  }
  callback()
}

const validateNewPassword = (rule, value, callback) => {
  if (!value) {
    callback(new Error('请输入新密码'))
    return
  }
  if (value.length < 6 || value.length > 20) {
    callback(new Error('密码长度在6-20个字符'))
    return
  }
  if (passwordForm.value.oldPassword && value === passwordForm.value.oldPassword) {
    callback(new Error('新密码不能与原密码相同'))
    return
  }
  callback()
}

const passwordRules = {
  oldPassword: [
    { required: true, message: '请输入原密码', trigger: 'blur' }
  ],
  newPassword: [
    { validator: validateNewPassword, trigger: 'blur' }
  ],
  confirmPassword: [
    { required: true, message: '请再次输入新密码', trigger: 'blur' },
    { validator: validateConfirmPassword, trigger: 'blur' }
  ]
}

const avatarUrl = computed(() => {
  if (userForm.value.avatar) {
    if (userForm.value.avatar.startsWith('http://') || userForm.value.avatar.startsWith('https://')) {
      return userForm.value.avatar
    }
    if (userForm.value.avatar.startsWith('/uploads')) {
      return `/api${userForm.value.avatar}`
    }
    return userForm.value.avatar
  }
  return null
})

const loadUserInfo = async () => {
  try {
    const res = await getCurrentUserInfo()
    userForm.value = res.data || {}
  } catch (error) {
    console.error('加载用户信息失败：', error)
  }
}

const beforeAvatarUpload = (file) => {
  const isImage = file.type.startsWith('image/')
  const isLt10M = file.size / 1024 / 1024 < 10
  
  if (!isImage) {
    ElMessage.error('只能上传图片文件！')
    return false
  }
  if (!isLt10M) {
    ElMessage.error('图片大小不能超过 10MB！')
    return false
  }
  return true
}

const handleAvatarUpload = async ({ file }) => {
  try {
    const res = await uploadAvatar(file)
    userForm.value.avatar = res.data
    userStore.updateUserInfo({ avatar: res.data })
    ElMessage.success('头像上传成功')
  } catch (error) {
    console.error('头像上传失败：', error)
  }
}

const handleSave = async () => {
  saving.value = true
  try {
    await updateUser(userForm.value)
    userStore.updateUserInfo(userForm.value)
    ElMessage.success('保存成功')
  } catch (error) {
    console.error('保存失败：', error)
  } finally {
    saving.value = false
  }
}

const resetPasswordForm = () => {
  passwordForm.value = {
    oldPassword: '',
    newPassword: '',
    confirmPassword: ''
  }
  passwordFormRef.value?.resetFields()
}

const handleClosePasswordDialog = () => {
  passwordDialogVisible.value = false
  resetPasswordForm()
}

const handleChangePassword = async () => {
  if (!passwordFormRef.value) return

  await passwordFormRef.value.validate(async (valid) => {
    if (!valid) return

    changingPassword.value = true
    try {
      await changePassword({
        oldPassword: passwordForm.value.oldPassword,
        newPassword: passwordForm.value.newPassword
      })
      ElMessage.success('密码修改成功，请牢记新密码')
      handleClosePasswordDialog()
    } catch (error) {
      console.error('修改密码失败：', error)
    } finally {
      changingPassword.value = false
    }
  })
}

onMounted(() => {
  loadUserInfo()
})
</script>

<style scoped>
.profile {
  animation: fadeIn 0.5s ease;
}

.card-title {
  font-size: 18px;
  font-weight: 600;
  color: var(--text-primary);
}

.avatar-card {
  text-align: center;
}

.avatar-section {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 20px 0;
}

.upload-tip {
  margin-top: 12px;
  font-size: 12px;
  color: var(--text-light);
}
</style>
