<template>
  <div class="login-page">
    <div class="login-shell">
      <section class="visual-panel">
        <div class="visual-copy fade-in">
          <div class="eyebrow">BATTERY RECYCLING</div>
          <h1>废电池回收系统</h1>
          <p>
            让废旧电池回收更智能、更环保。用更轻松的方式参与绿色循环，
            让每一次投放都成为可记录、可追踪、可兑换的环保行动。
          </p>
        </div>
        <div class="visual-image-wrap fade-in">
          <img :src="loginBg" alt="环保电池背景图" class="visual-image" />
        </div>
      </section>

      <section class="form-panel">
        <div class="login-box fade-in">
          <div class="login-header">
            <div class="logo-section">
              <div class="logo-badge">
                <el-icon :size="28" color="#6f9b63">
                  <Cpu />
                </el-icon>
              </div>
              <div>
                <h2>欢迎回来</h2>
                <p class="subtitle">登录后继续你的绿色回收之旅</p>
              </div>
            </div>
          </div>

          <el-form :model="loginForm" :rules="rules" ref="loginFormRef" class="login-form">
            <el-form-item prop="username">
              <el-input
                v-model="loginForm.username"
                placeholder="请输入用户名"
                size="large"
                :prefix-icon="User"
              />
            </el-form-item>

            <el-form-item prop="password">
              <el-input
                v-model="loginForm.password"
                type="password"
                placeholder="请输入密码"
                size="large"
                :prefix-icon="Lock"
                @keyup.enter="handleLogin"
                show-password
              />
            </el-form-item>

            <div class="login-links">
              <el-link type="primary" @click="forgotDialogVisible = true">忘记密码？</el-link>
            </div>

            <el-form-item>
              <el-button
                type="primary"
                size="large"
                :loading="loading"
                @click="handleLogin"
                class="login-button"
              >
                登录
              </el-button>
            </el-form-item>

            <div class="form-footer">
              <span>还没有账号？</span>
              <el-link type="primary" @click="goToRegister">立即注册</el-link>
            </div>
          </el-form>
        </div>
      </section>
    </div>

    <el-dialog v-model="forgotDialogVisible" title="忘记密码" width="460px" destroy-on-close>
      <el-form :model="forgotForm" :rules="forgotRules" ref="forgotFormRef" label-width="90px">
        <el-form-item label="用户名" prop="username">
          <el-input v-model="forgotForm.username" placeholder="请输入用户名" />
        </el-form-item>

        <el-form-item label="手机号" prop="phone">
          <el-input v-model="forgotForm.phone" placeholder="请输入注册手机号" />
        </el-form-item>
      </el-form>

      <template #footer>
        <el-button @click="handleCloseForgotDialog">取消</el-button>
        <el-button type="primary" @click="handleForgotPassword" :loading="forgotLoading">确认重置</el-button>
      </template>
    </el-dialog>

    <el-dialog v-model="resetSuccessDialogVisible" title="密码重置成功" width="420px" destroy-on-close>
      <div class="reset-success-content">
        <p>您的密码已重置为 <strong>123456</strong>。</p>
        <p>请尽快登录系统并修改密码，保障账号安全。</p>
      </div>

      <template #footer>
        <el-button type="primary" @click="resetSuccessDialogVisible = false">我知道了</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { User, Lock, Cpu } from '@element-plus/icons-vue'
import { forgotPassword, login } from '@/api/user'
import { useUserStore } from '@/stores/user'
import loginBg from '@/assets/login-bg.png'

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()
const LOGIN_EXPIRED_MESSAGE_KEY = 'loginExpiredMessage'
const loginFormRef = ref(null)
const forgotFormRef = ref(null)
const loading = ref(false)
const forgotLoading = ref(false)
const forgotDialogVisible = ref(false)
const resetSuccessDialogVisible = ref(false)

const loginForm = reactive({
  username: '',
  password: ''
})

const forgotForm = reactive({
  username: '',
  phone: ''
})

const rules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' }
  ]
}

const forgotRules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' }
  ],
  phone: [
    { required: true, message: '请输入手机号', trigger: 'blur' }
  ]
}

const handleLogin = async () => {
  if (!loginFormRef.value) return
  
  await loginFormRef.value.validate(async (valid) => {
    if (valid) {
      loading.value = true
      try {
        const res = await login(loginForm)
        userStore.login(res.data)
        ElMessage.success('登录成功')

        const redirectTarget = typeof route.query.redirect === 'string' ? route.query.redirect : ''
        
        if (userStore.isAdmin('/admin')) {
          router.push(redirectTarget.startsWith('/admin') ? redirectTarget : '/admin')
        } else {
          router.push(redirectTarget.startsWith('/user') ? redirectTarget : '/user')
        }
      } catch (error) {
        console.error('登录失败：', error)
      } finally {
        loading.value = false
      }
    }
  })
}

const resetForgotForm = () => {
  forgotForm.username = ''
  forgotForm.phone = ''
  forgotFormRef.value?.resetFields()
}

const handleCloseForgotDialog = () => {
  forgotDialogVisible.value = false
  resetForgotForm()
}

const handleForgotPassword = async () => {
  if (!forgotFormRef.value) return

  await forgotFormRef.value.validate(async (valid) => {
    if (!valid) return

    forgotLoading.value = true
    try {
      await forgotPassword({
        username: forgotForm.username,
        phone: forgotForm.phone
      })
      handleCloseForgotDialog()
      resetSuccessDialogVisible.value = true
    } catch (error) {
      console.error('重置密码失败：', error)
    } finally {
      forgotLoading.value = false
    }
  })
}

const goToRegister = () => {
  router.push('/register')
}

onMounted(() => {
  const expiredMessage = sessionStorage.getItem(LOGIN_EXPIRED_MESSAGE_KEY)
  if (expiredMessage) {
    ElMessage.error(expiredMessage)
    sessionStorage.removeItem(LOGIN_EXPIRED_MESSAGE_KEY)
  }
})
</script>

<style scoped>
.login-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 28px;
  background:
    radial-gradient(circle at top left, rgba(207, 231, 196, 0.6), transparent 34%),
    linear-gradient(135deg, #eef5ea 0%, #f7faf4 100%);
}

.reset-success-content {
  color: #526a49;
  line-height: 1.9;
  font-size: 15px;
}

.reset-success-content p {
  margin: 0 0 8px;
}

.reset-success-content strong {
  color: #2f4f28;
  font-size: 16px;
}

.login-shell {
  width: min(1240px, 100%);
  min-height: calc(100vh - 56px);
  display: grid;
  grid-template-columns: minmax(0, 1.35fr) minmax(380px, 460px);
  gap: 28px;
  padding: 28px;
  border-radius: 34px;
  background: rgba(255, 255, 255, 0.6);
  border: 1px solid rgba(184, 205, 173, 0.55);
  box-shadow: 0 30px 80px rgba(109, 138, 86, 0.16);
  backdrop-filter: blur(12px);
}

.visual-panel {
  position: relative;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  min-height: 100%;
  padding: 18px 12px 10px 12px;
}

.visual-copy {
  max-width: 560px;
  padding: 12px 18px;
}

.eyebrow {
  display: inline-flex;
  align-items: center;
  padding: 6px 12px;
  margin-bottom: 18px;
  border-radius: 999px;
  background: rgba(201, 222, 188, 0.72);
  color: #5e7f54;
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 0.18em;
}

.visual-copy h1 {
  margin: 0 0 16px;
  font-size: 46px;
  line-height: 1.12;
  color: #48643f;
  font-weight: 700;
}

.visual-copy p {
  margin: 0;
  font-size: 17px;
  line-height: 1.9;
  color: #6d7f65;
}

.visual-image-wrap {
  position: relative;
  margin-top: 24px;
  border-radius: 30px;
  overflow: hidden;
  background: rgba(255, 255, 255, 0.45);
  box-shadow: 0 24px 60px rgba(109, 138, 86, 0.12);
}

.visual-image {
  display: block;
  width: 100%;
  height: 100%;
  min-height: 520px;
  object-fit: cover;
  object-position: center;
}

.form-panel {
  display: flex;
  align-items: center;
  justify-content: center;
}

.login-box {
  width: 100%;
  padding: 38px 34px;
  background: rgba(255, 255, 255, 0.76);
  backdrop-filter: blur(16px);
  border: 1px solid rgba(255, 255, 255, 0.72);
  border-radius: 28px;
  box-shadow: 0 18px 45px rgba(102, 128, 83, 0.13);
}

.login-header {
  margin-bottom: 28px;
}

.logo-section {
  display: flex;
  align-items: center;
  gap: 14px;
}

.logo-badge {
  width: 56px;
  height: 56px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 18px;
  background: linear-gradient(135deg, #edf5e7 0%, #dbe8d1 100%);
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.8);
}

.logo-section h2 {
  margin: 0 0 6px;
  font-size: 28px;
  color: #4d6446;
}

.subtitle {
  margin: 0;
  color: #80907a;
  font-size: 14px;
}

.login-form :deep(.el-input__wrapper) {
  min-height: 48px;
  border-radius: 14px;
  background: rgba(248, 251, 245, 0.95);
  box-shadow: inset 0 0 0 1px rgba(194, 212, 183, 0.72);
}

.login-form :deep(.el-input__wrapper.is-focus) {
  box-shadow: inset 0 0 0 1px #9db88f;
}

.login-form :deep(.el-input__prefix-inner) {
  color: #8aa07f;
}

.login-links {
  display: flex;
  justify-content: flex-end;
  margin: -6px 0 14px;
}

.login-button {
  width: 100%;
  height: 50px;
  border: none;
  border-radius: 14px;
  font-size: 16px;
  font-weight: 700;
  color: #516548;
  background: linear-gradient(135deg, #e6f0de 0%, #d7e8cc 100%);
  box-shadow: 0 10px 24px rgba(148, 176, 125, 0.28);
}

.login-button:hover {
  color: #4a5f42;
  background: linear-gradient(135deg, #eaf3e4 0%, #dcecd1 100%);
}

.form-footer {
  text-align: center;
  color: #7f8e79;
  font-size: 14px;
}

.form-footer span {
  margin-right: 8px;
}

.form-footer :deep(.el-link),
.login-links :deep(.el-link) {
  color: #7a9c6a;
  font-weight: 600;
}
</style>
