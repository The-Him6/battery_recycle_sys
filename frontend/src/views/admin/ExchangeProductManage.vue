<template>
  <div class="exchange-product-manage">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>积分兑换商品管理</span>
          <el-button type="primary" @click="handleAdd">添加商品</el-button>
        </div>
      </template>

      <el-table :data="productList" border stripe>
        <el-table-column type="index" label="序号" width="60" align="center" />
        <el-table-column prop="productName" label="商品名称" min-width="150" />
        <el-table-column prop="brand" label="品牌" width="100" />
        <el-table-column prop="batteryModel" label="电池型号" width="120" />
        <el-table-column prop="pointsRequired" label="所需积分" width="100" align="center" />
        <el-table-column prop="stock" label="库存" width="80" align="center" />
        <el-table-column label="商品图片" width="100" align="center">
          <template #default="{ row }">
            <img
              v-if="row.imageUrl"
              :src="row.imageUrl"
              alt="商品图片"
              style="width: 60px; height: 60px; border-radius: 4px; object-fit: cover; cursor: pointer;"
              @click="previewImage(row.imageUrl)"
            />
            <span v-else style="color: #999;">暂无图片</span>
          </template>
        </el-table-column>
        <el-table-column label="状态" width="80" align="center">
          <template #default="{ row }">
            <el-tag :type="row.status === 1 ? 'success' : 'danger'">
              {{ row.status === 1 ? '上架' : '下架' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="创建时间" width="160" />
        <el-table-column label="操作" width="180" align="center" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" size="small" @click="handleEdit(row)">编辑</el-button>
            <el-button type="danger" size="small" @click="handleDelete(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <!-- 添加/编辑对话框 -->
    <el-dialog
      :title="dialogTitle"
      v-model="dialogVisible"
      width="600px"
      @close="resetForm"
    >
      <el-form :model="form" :rules="rules" ref="formRef" label-width="100px">
        <el-form-item label="商品名称" prop="productName">
          <el-input v-model="form.productName" placeholder="请输入商品名称" />
        </el-form-item>
        <el-form-item label="品牌" prop="brand">
          <el-input v-model="form.brand" placeholder="请输入品牌" />
        </el-form-item>
        <el-form-item label="电池型号" prop="batteryModel">
          <el-input v-model="form.batteryModel" placeholder="请输入电池型号" />
        </el-form-item>
        <el-form-item label="所需积分" prop="pointsRequired">
          <el-input-number v-model="form.pointsRequired" :min="1" :step="100" />
        </el-form-item>
        <el-form-item label="库存" prop="stock">
          <el-input-number v-model="form.stock" :min="0" />
        </el-form-item>
        <el-form-item label="商品图片" prop="imageUrl">
          <el-upload
            class="avatar-uploader"
            :show-file-list="false"
            :before-upload="beforeImageUpload"
            :http-request="handleImageUpload"
            accept="image/*"
          >
            <img v-if="form.imageUrl" :src="form.imageUrl" class="avatar" />
            <el-icon v-else class="avatar-uploader-icon"><Plus /></el-icon>
          </el-upload>
          <div style="color: #999; font-size: 12px; margin-top: 5px;">
            支持 jpg、png、gif 格式，大小不超过 2MB
          </div>
        </el-form-item>
        <el-form-item label="商品描述" prop="description">
          <el-input
            v-model="form.description"
            type="textarea"
            :rows="3"
            placeholder="请输入商品描述"
          />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="form.status">
            <el-radio :label="1">上架</el-radio>
            <el-radio :label="0">下架</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit">确定</el-button>
      </template>
    </el-dialog>

    <!-- 图片预览对话框 -->
    <el-dialog v-model="imagePreviewVisible" width="600px" :show-close="true">
      <img :src="previewImageUrl" style="width: 100%; display: block;" alt="预览图片" />
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus } from '@element-plus/icons-vue'
import { 
  getProductList, 
  addProduct, 
  updateProduct, 
  deleteProduct,
  uploadProductImage 
} from '@/api/exchangeProduct'

const productList = ref([])
const dialogVisible = ref(false)
const dialogTitle = ref('添加商品')
const formRef = ref(null)
const imagePreviewVisible = ref(false)
const previewImageUrl = ref('')

const form = reactive({
  id: null,
  productName: '',
  brand: '',
  batteryModel: '',
  pointsRequired: 1000,
  stock: 0,
  imageUrl: '',
  description: '',
  status: 1
})

const rules = {
  productName: [{ required: true, message: '请输入商品名称', trigger: 'blur' }],
  brand: [{ required: true, message: '请输入品牌', trigger: 'blur' }],
  batteryModel: [{ required: true, message: '请输入电池型号', trigger: 'blur' }],
  pointsRequired: [{ required: true, message: '请输入所需积分', trigger: 'blur' }],
  stock: [{ required: true, message: '请输入库存', trigger: 'blur' }]
}

// 加载商品列表
const loadProducts = async () => {
  try {
    const res = await getProductList()
    productList.value = res.data
  } catch (error) {
    ElMessage.error('加载商品列表失败')
  }
}

// 添加商品
const handleAdd = () => {
  dialogTitle.value = '添加商品'
  dialogVisible.value = true
}

// 编辑商品
const handleEdit = (row) => {
  dialogTitle.value = '编辑商品'
  Object.assign(form, row)
  dialogVisible.value = true
}

// 删除商品
const handleDelete = (row) => {
  ElMessageBox.confirm('确定要删除该商品吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    try {
      await deleteProduct(row.id)
      ElMessage.success('删除成功')
      loadProducts()
    } catch (error) {
      ElMessage.error('删除失败')
    }
  })
}

// 提交表单
const handleSubmit = () => {
  formRef.value.validate(async (valid) => {
    if (valid) {
      try {
        if (form.id) {
          await updateProduct(form)
          ElMessage.success('更新成功')
        } else {
          await addProduct(form)
          ElMessage.success('添加成功')
        }
        dialogVisible.value = false
        loadProducts()
      } catch (error) {
        ElMessage.error(error.message || '操作失败')
      }
    }
  })
}

// 重置表单
const resetForm = () => {
  form.id = null
  form.productName = ''
  form.brand = ''
  form.batteryModel = ''
  form.pointsRequired = 1000
  form.stock = 0
  form.imageUrl = ''
  form.description = ''
  form.status = 1
  formRef.value?.resetFields()
}

// 上传前检查
const beforeImageUpload = (file) => {
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

// 自定义上传方法（和头像上传一样）
const handleImageUpload = async ({ file }) => {
  try {
    const res = await uploadProductImage(file)
    form.imageUrl = res.data
    ElMessage.success('图片上传成功')
  } catch (error) {
    console.error('图片上传失败：', error)
    ElMessage.error(error.message || '图片上传失败')
  }
}

// 预览图片
const previewImage = (url) => {
  previewImageUrl.value = url
  imagePreviewVisible.value = true
}

onMounted(() => {
  loadProducts()
})
</script>

<style scoped>
.exchange-product-manage {
  padding: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.avatar-uploader {
  border: 1px dashed #d9d9d9;
  border-radius: 6px;
  cursor: pointer;
  overflow: hidden;
  transition: border-color 0.3s;
}

.avatar-uploader:hover {
  border-color: #409eff;
}

.avatar-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 178px;
  height: 178px;
  text-align: center;
  line-height: 178px;
}

.avatar {
  width: 178px;
  height: 178px;
  display: block;
  object-fit: cover;
}
</style>





