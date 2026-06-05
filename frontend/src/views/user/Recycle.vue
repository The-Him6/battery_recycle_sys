<template>
  <div class="recycle">
    <h2 class="page-title">电池回收</h2>
    
    <!-- 电池识别指南 -->
    <el-card class="custom-card guide-card" shadow="hover">
      <template #header>
        <div style="display: flex; align-items: center; gap: 8px;">
          <el-icon color="#1890ff"><InfoFilled /></el-icon>
          <span class="card-title">如何识别电池型号</span>
        </div>
      </template>
      
      <div class="guide-grid">
        <div class="guide-grid-item" v-for="(type, index) in batteryTypes" :key="type.id">
          <div class="guide-item">
            <div class="guide-number">{{ index + 1 }}</div>
            <div class="guide-icon previewable-image" v-if="type.icon" @click="openImagePreview(type)">
              <img :src="type.icon" :alt="type.typeName" />
              <div class="image-preview-mask">点击查看</div>
            </div>
            <h4>{{ type.typeName }}</h4>
            <p class="guide-desc">{{ type.identificationGuide || type.description }}</p>
          </div>
        </div>
      </div>
    </el-card>
    
    <el-card class="custom-card" shadow="hover">
      <template #header>
        <span class="card-title">创建回收订单</span>
      </template>
      
      <el-form :model="orderForm" :rules="rules" ref="orderFormRef" label-width="120px">
        <el-form-item label="回收地址" prop="recycleAddress">
          <el-input
            v-model="orderForm.recycleAddress"
            placeholder="请输入回收地址"
            :prefix-icon="Location"
          />
        </el-form-item>
        
        <el-form-item label="联系电话" prop="contactPhone">
          <el-input
            v-model="orderForm.contactPhone"
            placeholder="请输入联系电话"
            :prefix-icon="Phone"
          />
        </el-form-item>
        
        <el-divider>选择回收电池</el-divider>
        
        <div class="battery-selection-grid">
          <div class="battery-selection-item" v-for="type in batteryTypes" :key="type.id">
            <div class="battery-card" :class="{ selected: isSelected(type.id) }">
              <div class="battery-header">
                <div class="battery-icon previewable-image" v-if="type.icon" @click="openImagePreview(type)">
                  <img :src="type.icon" :alt="type.typeName" />
                  <div class="image-preview-mask">点击查看</div>
                </div>
                <el-icon v-else :size="40" color="#1890ff">
                  <Box />
                </el-icon>
                <h3>{{ type.typeName }}</h3>
              </div>
              <p class="battery-desc">{{ type.description }}</p>
              <div class="battery-points">
                <el-tag type="warning">{{ type.points }} 积分/个</el-tag>
              </div>
              <el-input-number
                v-model="batteryCount[type.id]"
                :min="0"
                :max="999"
                @change="handleCountChange(type.id)"
                style="width: 100%; margin-top: 16px;"
              />
            </div>
          </div>
        </div>
        
        <el-divider>订单预览</el-divider>
        
        <div class="order-preview">
          <el-descriptions :column="2" border>
            <el-descriptions-item label="电池总数">
              <el-tag type="primary">{{ totalCount }} 个</el-tag>
            </el-descriptions-item>
            <el-descriptions-item label="预计积分">
              <el-tag type="success">{{ totalPoints }} 分</el-tag>
            </el-descriptions-item>
          </el-descriptions>
        </div>
        
        <el-form-item label="备注">
          <el-input
            v-model="orderForm.remark"
            type="textarea"
            :rows="3"
            placeholder="请输入备注信息（可选）"
          />
        </el-form-item>
        
        <el-form-item>
          <el-button type="primary" size="large" @click="handleSubmit" :loading="submitting">
            提交订单
          </el-button>
          <el-button size="large" @click="handleReset">
            重置
          </el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <el-dialog v-model="previewVisible" :title="previewTitle" width="520px" align-center>
      <div class="image-preview-dialog">
        <img :src="previewImage" :alt="previewTitle" />
      </div>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { Location, Phone, Box, InfoFilled } from '@element-plus/icons-vue'
import { getEnabledBatteryTypes } from '@/api/batteryType'
import { createOrder } from '@/api/order'

const router = useRouter()
const orderFormRef = ref(null)
const submitting = ref(false)
const batteryTypes = ref([])
const batteryCount = ref({})
const previewVisible = ref(false)
const previewImage = ref('')
const previewTitle = ref('')

const orderForm = ref({
  recycleAddress: '',
  contactPhone: '',
  remark: ''
})

const rules = {
  recycleAddress: [
    { required: true, message: '请输入回收地址', trigger: 'blur' }
  ],
  contactPhone: [
    { required: true, message: '请输入联系电话', trigger: 'blur' },
    { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号', trigger: 'blur' }
  ]
}

const totalCount = computed(() => {
  return Object.values(batteryCount.value).reduce((sum, count) => sum + (count || 0), 0)
})

const totalPoints = computed(() => {
  let points = 0
  batteryTypes.value.forEach(type => {
    const count = batteryCount.value[type.id] || 0
    points += count * type.points
  })
  return points
})

const isSelected = (typeId) => {
  return (batteryCount.value[typeId] || 0) > 0
}

const handleCountChange = (typeId) => {
  if (!batteryCount.value[typeId] || batteryCount.value[typeId] < 0) {
    batteryCount.value[typeId] = 0
  }
}

const openImagePreview = (type) => {
  if (!type?.icon) return
  previewImage.value = type.icon
  previewTitle.value = type.typeName
  previewVisible.value = true
}

const handleSubmit = async () => {
  if (!orderFormRef.value) return
  
  await orderFormRef.value.validate(async (valid) => {
    if (valid) {
      if (totalCount.value === 0) {
        ElMessage.warning('请至少选择一种电池进行回收')
        return
      }
      
      submitting.value = true
      try {
        // 构建订单明细
        const details = []
        batteryTypes.value.forEach(type => {
          const count = batteryCount.value[type.id] || 0
          if (count > 0) {
            details.push({
              batteryTypeId: type.id,
              batteryCount: count
            })
          }
        })
        
        await createOrder({
          recycleAddress: orderForm.value.recycleAddress,
          contactPhone: orderForm.value.contactPhone,
          remark: orderForm.value.remark,
          details
        })
        
        ElMessage.success('订单创建成功')
        router.push('/user/orders')
      } catch (error) {
        console.error('创建订单失败：', error)
      } finally {
        submitting.value = false
      }
    }
  })
}

const handleReset = () => {
  orderFormRef.value?.resetFields()
  batteryCount.value = {}
}

const loadBatteryTypes = async () => {
  try {
    const res = await getEnabledBatteryTypes()
    batteryTypes.value = res.data || []
    
    // 初始化计数器
    batteryTypes.value.forEach(type => {
      batteryCount.value[type.id] = 0
    })
  } catch (error) {
    console.error('加载电池种类失败：', error)
  }
}

onMounted(() => {
  loadBatteryTypes()
})
</script>

<style scoped>
.recycle {
  animation: fadeIn 0.5s ease;
}

.card-title {
  font-size: 18px;
  font-weight: 600;
  color: var(--text-primary);
}

.guide-card {
  margin-bottom: 24px;
}

.guide-grid {
  display: grid;
  grid-template-columns: repeat(5, minmax(0, 1fr));
  gap: 16px;
}

.guide-grid-item {
  min-width: 0;
}

.guide-item {
  height: 100%;
  text-align: center;
  padding: 18px 16px;
  border-radius: 8px;
  background: var(--bg-color);
  margin-bottom: 0;
  transition: all 0.3s ease;
}

.guide-item:hover {
  background: #fff;
  box-shadow: var(--shadow-sm);
  transform: translateY(-2px);
}

.guide-number {
  width: 40px;
  height: 40px;
  line-height: 40px;
  border-radius: 50%;
  background: linear-gradient(135deg, #1890ff 0%, #0050b3 100%);
  color: white;
  font-size: 20px;
  font-weight: bold;
  margin: 0 auto 12px;
}

.guide-item h4 {
  font-size: 16px;
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: 8px;
}

.guide-item p {
  font-size: 13px;
  color: var(--text-secondary);
  margin: 4px 0;
  line-height: 1.6;
}

.guide-desc {
  white-space: pre-wrap;
  word-break: break-word;
}

.guide-icon {
  width: 80px;
  height: 80px;
  margin: 0 auto 12px;
  border-radius: 8px;
  overflow: hidden;
  background: #f5f7fa;
  display: flex;
  align-items: center;
  justify-content: center;
}

.previewable-image {
  position: relative;
  cursor: zoom-in;
}

.image-preview-mask {
  position: absolute;
  inset: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
  font-weight: 600;
  color: #fff;
  background: rgba(24, 144, 255, 0.62);
  opacity: 0;
  transition: opacity 0.25s ease;
}

.previewable-image:hover .image-preview-mask {
  opacity: 1;
}

.guide-icon img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.guide-tip {
  color: var(--primary-color);
  font-weight: 500;
  margin-top: 8px;
}

.battery-selection {
  margin: 20px 0;
}

.battery-selection-grid {
  display: grid;
  grid-template-columns: repeat(5, minmax(0, 1fr));
  gap: 16px;
}

.battery-selection-item {
  min-width: 0;
}

.battery-card {
  height: 100%;
  background: var(--bg-color);
  border-radius: 12px;
  padding: 18px 16px;
  text-align: center;
  transition: all 0.3s ease;
  border: 2px solid transparent;
  margin-bottom: 0;
}

.battery-card:hover {
  background: #fff;
  box-shadow: var(--shadow-sm);
  transform: translateY(-4px);
}

.battery-card.selected {
  border-color: var(--primary-color);
  background: #fff;
  box-shadow: var(--shadow-md);
}

.battery-header {
  margin-bottom: 12px;
}

.battery-header h3 {
  font-size: 16px;
  font-weight: 600;
  color: var(--text-primary);
  margin-top: 8px;
}

.battery-icon {
  width: 60px;
  height: 60px;
  margin: 0 auto 8px;
  border-radius: 8px;
  overflow: hidden;
  background: #f5f7fa;
  display: flex;
  align-items: center;
  justify-content: center;
}

.battery-icon img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.battery-desc {
  font-size: 13px;
  color: var(--text-secondary);
  margin-bottom: 12px;
  min-height: 66px;
}

.battery-points {
  margin-bottom: 12px;
}

.order-preview {
  margin: 20px 0;
}

.image-preview-dialog {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 8px 0;
}

.image-preview-dialog img {
  max-width: 100%;
  max-height: 65vh;
  object-fit: contain;
  border-radius: 12px;
  background: #f5f7fa;
}

@media (max-width: 1400px) {
  .guide-grid,
  .battery-selection-grid {
    grid-template-columns: repeat(3, minmax(0, 1fr));
  }
}

@media (max-width: 992px) {
  .guide-grid,
  .battery-selection-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 576px) {
  .guide-grid,
  .battery-selection-grid {
    grid-template-columns: 1fr;
  }
}
</style>
