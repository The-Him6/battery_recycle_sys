<template>
  <div class="register-page">
    <div class="register-shell">
      <section class="visual-panel">
        <div class="visual-copy fade-in">
          <div class="eyebrow">BATTERY RECYCLING</div>
          <h1>创建你的回收账户</h1>
          <p>
            注册后即可提交回收订单、累计环保积分、兑换绿色商品，
            开启属于你的低碳行动记录。
          </p>
        </div>
        <div class="visual-image-wrap fade-in">
          <img :src="loginBg" alt="环保电池背景图" class="visual-image" />
        </div>
      </section>

      <section class="form-panel">
        <div class="register-box fade-in">
          <div class="register-header">
            <div class="logo-section">
              <div class="logo-badge">
                <el-icon :size="28" color="#6f9b63">
                  <Cpu />
                </el-icon>
              </div>
              <div>
                <h2>欢迎加入</h2>
                <p class="subtitle">创建账户，开始你的绿色回收计划</p>
              </div>
            </div>
          </div>

          <el-form :model="registerForm" :rules="rules" ref="registerFormRef" class="register-form">
            <el-form-item prop="username">
              <el-input
                v-model="registerForm.username"
                placeholder="请输入用户名"
                size="large"
                :prefix-icon="User"
              />
            </el-form-item>

            <el-form-item prop="password">
              <el-input
                v-model="registerForm.password"
                type="password"
                placeholder="请输入密码"
                size="large"
                :prefix-icon="Lock"
                show-password
              />
            </el-form-item>

            <el-form-item prop="confirmPassword">
              <el-input
                v-model="registerForm.confirmPassword"
                type="password"
                placeholder="请确认密码"
                size="large"
                :prefix-icon="Lock"
                show-password
              />
            </el-form-item>

            <el-form-item prop="nickname">
              <el-input
                v-model="registerForm.nickname"
                placeholder="请输入昵称（可选）"
                size="large"
                :prefix-icon="Avatar"
              />
            </el-form-item>

            <el-form-item prop="phone">
              <el-input
                v-model="registerForm.phone"
                placeholder="请输入手机号"
                size="large"
                :prefix-icon="Phone"
              />
            </el-form-item>

            <el-form-item>
              <el-button
                type="primary"
                size="large"
                :loading="loading"
                @click="handleRegister"
                class="register-button"
              >
                注册
              </el-button>
            </el-form-item>

            <div class="form-footer">
              <span>已有账号？</span>
              <el-link type="primary" @click="goToLogin">立即登录</el-link>
            </div>
          </el-form>
        </div>
      </section>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { User, Lock, Avatar, Phone, Cpu } from '@element-plus/icons-vue'
import { register } from '@/api/user'
import loginBg from '@/assets/login-bg.png'

const router = useRouter()
const registerFormRef = ref(null)
const loading = ref(false)

const registerForm = reactive({
  username: '',
  password: '',
  confirmPassword: '',
  nickname: '',
  phone: ''
})

const validateConfirmPassword = (rule, value, callback) => {
  if (value !== registerForm.password) {
    callback(new Error('两次输入的密码不一致'))
  } else {
    callback()
  }
}

const rules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    { min: 3, max: 20, message: '用户名长度在3-20个字符', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, max: 20, message: '密码长度在6-20个字符', trigger: 'blur' }
  ],
  confirmPassword: [
    { required: true, message: '请确认密码', trigger: 'blur' },
    { validator: validateConfirmPassword, trigger: 'blur' }
  ],
  phone: [
    { required: true, message: '请输入手机号', trigger: 'blur' }
  ]
}

const handleRegister = async () => {
  if (!registerFormRef.value) return
  
  await registerFormRef.value.validate(async (valid) => {
    if (valid) {
      loading.value = true
      try {
        await register({
          username: registerForm.username,
          password: registerForm.password,
          nickname: registerForm.nickname,
          phone: registerForm.phone
        })
        ElMessage.success('注册成功，请登录')
        router.push('/login')
      } catch (error) {
        console.error('注册失败：', error)
      } finally {
        loading.value = false
      }
    }
  })
}

const goToLogin = () => {
  router.push('/login')
}
</script>

<style scoped>
.register-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 28px;
  background:
    radial-gradient(circle at top left, rgba(207, 231, 196, 0.6), transparent 34%),
    linear-gradient(135deg, #eef5ea 0%, #f7faf4 100%);
}

.register-shell {
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

.register-box {
  width: 100%;
  padding: 38px 34px;
  background: rgba(255, 255, 255, 0.76);
  backdrop-filter: blur(16px);
  border: 1px solid rgba(255, 255, 255, 0.72);
  border-radius: 28px;
  box-shadow: 0 18px 45px rgba(102, 128, 83, 0.13);
}

.register-header {
  margin-bottom: 24px;
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

.register-form :deep(.el-input__wrapper) {
  min-height: 48px;
  border-radius: 14px;
  background: rgba(248, 251, 245, 0.95);
  box-shadow: inset 0 0 0 1px rgba(194, 212, 183, 0.72);
}

.register-form :deep(.el-input__wrapper.is-focus) {
  box-shadow: inset 0 0 0 1px #9db88f;
}

.register-form :deep(.el-input__prefix-inner) {
  color: #8aa07f;
}

.register-button {
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
</style>
