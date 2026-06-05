<template>
  <div class="points-exchange">
    <!-- 积分信息卡片 -->
    <el-card class="points-card">
      <div class="points-info">
        <div class="points-item">
          <div class="points-label">总积分</div>
          <div class="points-value">{{ userPoints.totalPoints || 0 }}</div>
        </div>
        <div class="points-item">
          <div class="points-label">可用积分</div>
          <div class="points-value primary">{{ userPoints.availablePoints || 0 }}</div>
        </div>
        <div class="points-item">
          <div class="points-label">已使用积分</div>
          <div class="points-value">{{ userPoints.usedPoints || 0 }}</div>
        </div>
      </div>
    </el-card>

    <!-- 商品列表 -->
    <el-card class="product-card">
      <template #header>
        <div class="card-header">
          <span>兑换商品</span>
          <el-select v-model="selectedBrand" placeholder="选择品牌" clearable @change="filterProducts">
            <el-option label="全部品牌" value="" />
            <el-option v-for="brand in brands" :key="brand" :label="brand" :value="brand" />
          </el-select>
        </div>
      </template>

      <div class="product-list">
        <div v-for="product in filteredProducts" :key="product.id" class="product-item">
          <div class="product-image">
            <img
              v-if="product.imageUrl"
              :src="product.imageUrl"
              alt="商品图片"
            />
            <div v-else class="no-image">暂无图片</div>
          </div>
          <div class="product-info">
            <div class="product-name">{{ product.productName }}</div>
            <div class="product-detail">
              <span class="brand">{{ product.brand }}</span>
              <span class="model">{{ product.batteryModel }}</span>
            </div>
            <div class="product-desc">{{ product.description || '暂无描述' }}</div>
            <div class="product-footer">
              <div class="product-points">
                <span class="points-label">所需积分：</span>
                <span class="points-value">{{ product.pointsRequired }}</span>
              </div>
              <div v-if="product.status === 1" class="product-stock">库存：{{ product.stock }}</div>
            </div>
            <div class="product-status" :class="{ offline: product.status !== 1, lowstock: product.status === 1 && product.stock <= 0 }">
              {{ product.status !== 1 ? '商品已下架' : product.stock <= 0 ? '库存不足' : '可兑换' }}
            </div>
          </div>
          <div class="product-action">
            <el-button
              type="primary"
              :disabled="isProductDisabled(product)"
              @click="handleExchange(product)"
            >
              {{ getProductStatusText(product) }}
            </el-button>
          </div>
        </div>
      </div>

      <el-empty v-if="filteredProducts.length === 0" description="暂无商品" />
    </el-card>

    <!-- 兑换对话框 -->
    <el-dialog title="确认兑换" v-model="exchangeVisible" width="500px">
      <el-form :model="exchangeForm" :rules="exchangeRules" ref="exchangeFormRef" label-width="100px">
        <el-form-item label="商品名称">
          <el-input v-model="currentProduct.productName" disabled />
        </el-form-item>
        <el-form-item label="所需积分">
          <el-input v-model="currentProduct.pointsRequired" disabled />
        </el-form-item>
        <el-form-item label="兑换数量" prop="quantity">
          <el-input-number
            v-model="exchangeForm.quantity"
            :min="1"
            :max="Math.min(currentProduct.stock, Math.floor(userPoints.availablePoints / currentProduct.pointsRequired))"
          />
        </el-form-item>
        <el-form-item label="总计积分">
          <el-input :value="currentProduct.pointsRequired * exchangeForm.quantity" disabled />
        </el-form-item>
        <el-form-item label="联系电话" prop="contactPhone">
          <el-input v-model="exchangeForm.contactPhone" placeholder="请输入联系电话" />
        </el-form-item>
        <el-form-item label="收货地址" prop="shippingAddress">
          <el-input
            v-model="exchangeForm.shippingAddress"
            type="textarea"
            :rows="3"
            placeholder="请输入收货地址"
          />
        </el-form-item>
        <el-form-item label="备注">
          <el-input
            v-model="exchangeForm.remark"
            type="textarea"
            :rows="2"
            placeholder="选填"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="exchangeVisible = false">取消</el-button>
        <el-button type="primary" @click="confirmExchange">确认兑换</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { getAvailableProducts } from '@/api/exchangeProduct'
import request from '@/utils/request'

const userPoints = ref({})
const productList = ref([])
const selectedBrand = ref('')
const brands = ref([])
const exchangeVisible = ref(false)
const exchangeFormRef = ref(null)
const currentProduct = reactive({})

const exchangeForm = reactive({
  productId: null,
  quantity: 1,
  contactPhone: '',
  shippingAddress: '',
  remark: ''
})

const exchangeRules = {
  quantity: [{ required: true, message: '请输入兑换数量', trigger: 'blur' }],
  contactPhone: [
    { required: true, message: '请输入联系电话', trigger: 'blur' },
    { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号', trigger: 'blur' }
  ],
  shippingAddress: [{ required: true, message: '请输入收货地址', trigger: 'blur' }]
}

// 过滤后的商品列表
const filteredProducts = computed(() => {
  if (!selectedBrand.value) {
    return productList.value
  }
  return productList.value.filter(p => p.brand === selectedBrand.value)
})

// 加载用户积分
const loadUserPoints = async () => {
  try {
    const res = await request.get('/exchange-record/points')
    userPoints.value = res.data
  } catch (error) {
    ElMessage.error('加载积分信息失败')
  }
}

// 加载商品列表
const loadProducts = async () => {
  try {
    const res = await getAvailableProducts()
    productList.value = res.data
    
    // 提取品牌列表
    const brandSet = new Set(productList.value.map(p => p.brand))
    brands.value = Array.from(brandSet)
  } catch (error) {
    ElMessage.error('加载商品列表失败')
  }
}

// 过滤商品
const filterProducts = () => {
  // 由计算属性自动处理
}

const getProductStatusText = (product) => {
  if (product.status !== 1) {
    return '商品已下架'
  }
  if (product.stock <= 0) {
    return '库存不足'
  }
  if (userPoints.value.availablePoints < product.pointsRequired) {
    return '积分不足'
  }
  return '立即兑换'
}

const isProductDisabled = (product) => {
  return product.status !== 1 || product.stock <= 0 || userPoints.value.availablePoints < product.pointsRequired
}

// 处理兑换
const handleExchange = (product) => {
  if (isProductDisabled(product)) {
    return
  }

  Object.assign(currentProduct, product)
  exchangeForm.productId = product.id
  exchangeForm.quantity = 1
  exchangeForm.contactPhone = ''
  exchangeForm.shippingAddress = ''
  exchangeForm.remark = ''
  exchangeVisible.value = true
}

// 确认兑换
const confirmExchange = () => {
  exchangeFormRef.value.validate(async (valid) => {
    if (valid) {
      try {
        await request.post('/exchange-record', exchangeForm)
        ElMessage.success('兑换成功！')
        exchangeVisible.value = false
        loadUserPoints()
        loadProducts()
      } catch (error) {
        ElMessage.error(error.message || '兑换失败')
      }
    }
  })
}

onMounted(() => {
  loadUserPoints()
  loadProducts()
})
</script>

<style scoped>
.points-exchange {
  padding: 20px;
}

.points-card {
  margin-bottom: 20px;
}

.points-info {
  display: flex;
  justify-content: space-around;
  padding: 20px 0;
}

.points-item {
  text-align: center;
}

.points-label {
  font-size: 14px;
  color: #666;
  margin-bottom: 10px;
}

.points-value {
  font-size: 32px;
  font-weight: bold;
  color: #303133;
}

.points-value.primary {
  color: #1a73e8;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.product-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 20px;
}

.product-item {
  border: 1px solid #e4e7ed;
  border-radius: 8px;
  padding: 15px;
  transition: all 0.3s;
  display: flex;
  flex-direction: column;
}

.product-item:hover {
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
  transform: translateY(-2px);
}

.product-image {
  width: 100%;
  height: 200px;
  margin-bottom: 15px;
  border-radius: 4px;
  overflow: hidden;
}

.product-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.no-image {
  width: 100%;
  height: 100%;
  background: #f5f7fa;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #999;
}

.product-info {
  flex: 1;
}

.product-name {
  font-size: 16px;
  font-weight: bold;
  margin-bottom: 8px;
  color: #303133;
}

.product-detail {
  margin-bottom: 8px;
}

.brand {
  color: #1a73e8;
  margin-right: 10px;
}

.model {
  color: #666;
}

.product-desc {
  font-size: 14px;
  color: #666;
  margin-bottom: 12px;
  line-height: 1.5;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.product-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
}

.product-points .points-label {
  font-size: 14px;
  color: #666;
}

.product-points .points-value {
  font-size: 20px;
  font-weight: bold;
  color: #f56c6c;
}

.product-stock {
  font-size: 14px;
  color: #909399;
}

.product-status {
  margin-top: 8px;
  font-size: 13px;
  font-weight: 600;
  color: #67c23a;
}

.product-status.lowstock {
  color: #e6a23c;
}

.product-status.offline {
  color: #f56c6c;
}

.product-action {
  text-align: center;
}

.product-action .el-button {
  width: 100%;
}
</style>





