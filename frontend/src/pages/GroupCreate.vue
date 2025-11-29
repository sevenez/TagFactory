<template>
  <div class="card">
    <h2>创建新群体</h2>
    
    <!-- 群体创建表单 -->
    <div class="create-group-form">
      <div class="form-row">
        <div class="form-group">
          <label>群体名称</label>
          <input v-model="groupForm.name" placeholder="请输入群体名称" required />
        </div>
        
        <div class="form-group">
          <label>实体类型</label>
          <select v-model="groupForm.entity_type" @change="handleEntityTypeChange">
            <option value="CUSTOMER">用户</option>
            <option value="PRODUCT">商品</option>
            <option value="SELLER">商家</option>
          </select>
        </div>
        
        <div class="form-group">
          <label>创建方式</label>
          <select v-model="groupForm.method">
            <option value="RULE">规则创建</option>
            <option value="BEHAVIOR">行为创建</option>
            <option value="IMPORT">外部导入</option>
          </select>
        </div>
      </div>
      
      <div class="form-row">
        <div class="form-group full-width">
          <label>群体描述</label>
          <textarea v-model="groupForm.description" placeholder="请输入群体描述"></textarea>
        </div>
      </div>
      
      <!-- 标签选择区域 -->
      <div class="form-row">
        <div class="form-group full-width">
          <label>选择标签 <span class="required">*</span></label>
          <div class="tag-selector">
            <div class="tag-filter">
              <input v-model="tagFilter" placeholder="搜索标签" />
            </div>
            
            <div class="tag-list">
              <div 
                v-for="tag in filteredTags" 
                :key="tag.tag_id" 
                class="tag-item"
                :class="{ selected: selectedTags.includes(tag) }"
                @click="toggleTag(tag)"
              >
                <span class="tag-name">{{ tag.name }}</span>
                <span class="tag-type">{{ tag.type }}</span>
              </div>
            </div>
            
            <!-- 已选择标签 -->
            <div class="selected-tags" v-if="selectedTags.length > 0">
              <h4>已选择标签 ({{ selectedTags.length }})</h4>
              <div class="selected-tag-list">
                <div 
                  v-for="tag in selectedTags" 
                  :key="tag.tag_id" 
                  class="selected-tag-item"
                >
                  <span>{{ tag.name }}</span>
                  <button class="remove-tag" @click="removeTag(tag)">×</button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- 错误提示 -->
      <div v-if="errorMessage" class="error-message">{{ errorMessage }}</div>
      
      <div class="form-actions">
        <button class="btn primary" @click="createGroup" :disabled="selectedTags.length === 0">创建群体</button>
        <button class="btn secondary" @click="resetForm">重置</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import client from '../api/client'

// 标签数据
const tags = ref([])
const tagFilter = ref('')
const selectedTags = ref([])

// 群体创建表单
const groupForm = ref({
  name: '',
  entity_type: 'CUSTOMER',
  method: 'RULE',
  description: ''
})

// 错误信息
const errorMessage = ref('')

// 加载标签列表
const loadTags = async () => {
  try {
    const response = await client.get('/tags')
    tags.value = response.data.data
  } catch (error) {
    console.error('加载标签列表失败:', error)
  }
}

// 过滤标签
const filteredTags = computed(() => {
  let result = tags.value
  
  // 按实体类型过滤
  result = result.filter(tag => tag.type === groupForm.value.entity_type)
  
  // 按关键词过滤
  if (tagFilter.value) {
    const filter = tagFilter.value.toLowerCase()
    result = result.filter(tag => 
      tag.name.toLowerCase().includes(filter) || 
      tag.tag_id.toLowerCase().includes(filter)
    )
  }
  
  return result
})

// 处理实体类型变化
const handleEntityTypeChange = () => {
  // 清空已选择的标签，因为实体类型变化了
  selectedTags.value = []
  errorMessage.value = ''
}

// 切换标签选择状态
const toggleTag = (tag) => {
  const index = selectedTags.value.findIndex(t => t.tag_id === tag.tag_id)
  if (index > -1) {
    selectedTags.value.splice(index, 1)
  } else {
    // 验证标签类型是否与群体实体类型一致
    if (tag.type !== groupForm.value.entity_type) {
      errorMessage.value = '标签类型必须与群体实体类型一致'
      return
    }
    selectedTags.value.push(tag)
    errorMessage.value = ''
  }
}

// 移除已选择的标签
const removeTag = (tag) => {
  const index = selectedTags.value.findIndex(t => t.tag_id === tag.tag_id)
  if (index > -1) {
    selectedTags.value.splice(index, 1)
  }
}

// 创建群体
const createGroup = async () => {
  try {
    // 表单验证
    if (!groupForm.value.name) {
      errorMessage.value = '请输入群体名称'
      return
    }
    
    if (selectedTags.value.length === 0) {
      errorMessage.value = '请至少选择一个标签'
      return
    }
    
    // 验证所有选择的标签类型是否一致
    const tagTypes = [...new Set(selectedTags.value.map(tag => tag.type))]
    if (tagTypes.length > 1) {
      errorMessage.value = '所有选择的标签必须属于同一类型'
      return
    }
    
    // 验证标签类型是否与群体实体类型一致
    if (tagTypes[0] !== groupForm.value.entity_type) {
      errorMessage.value = '标签类型必须与群体实体类型一致'
      return
    }
    
    // 准备标签数据
    const tags = selectedTags.value.map(tag => ({
      tag_code: tag.tag_code,
      tag_value: '', // 这里可以根据实际情况获取标签值
      operator: 'AND'
    }))
    
    // 准备请求参数
    const params = {
      name: groupForm.value.name,
      entity_type: groupForm.value.entity_type,
      method: groupForm.value.method,
      description: groupForm.value.description,
      tags: JSON.stringify(tags) // 将标签列表转换为JSON字符串
    }
    
    // 创建群体
    const groupResponse = await client.post('/groups', null, { params })
    
    // 重置表单
    resetForm()
    
    // 跳转到群体列表页面
    window.location.href = '/groups/list'
  } catch (error) {
    console.error('创建群体失败:', error)
    errorMessage.value = error.response?.data?.detail || '创建群体失败，请稍后重试'
  }
}

// 重置表单
const resetForm = () => {
  groupForm.value = {
    name: '',
    entity_type: 'CUSTOMER',
    method: 'RULE',
    description: ''
  }
  selectedTags.value = []
  tagFilter.value = ''
  errorMessage.value = ''
}

// 初始化数据
onMounted(() => {
  loadTags()
})
</script>

<style scoped>
.card {
  background: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
  padding: 20px;
  margin: 20px;
}

h2 {
  margin-top: 0;
  margin-bottom: 20px;
  color: #333;
  font-size: 24px;
}

/* 表单样式 */
.create-group-form {
  background: #f9f9f9;
  border-radius: 8px;
  padding: 20px;
  border: 1px solid #e0e0e0;
}

.form-row {
  display: flex;
  gap: 20px;
  margin-bottom: 15px;
  flex-wrap: wrap;
}

.form-group {
  flex: 1;
  min-width: 200px;
}

.form-group.full-width {
  flex: 1 1 100%;
}

.form-group label {
  display: block;
  margin-bottom: 5px;
  font-weight: 500;
  color: #555;
}

.form-group input,
.form-group select,
.form-group textarea {
  width: 100%;
  padding: 8px 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
}

.form-group textarea {
  resize: vertical;
  min-height: 80px;
}

.required {
  color: #ff4d4f;
}

/* 标签选择器样式 */
.tag-selector {
  background: #fff;
  border: 1px solid #ddd;
  border-radius: 4px;
  padding: 15px;
}

.tag-filter {
  margin-bottom: 15px;
}

.tag-list {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  max-height: 200px;
  overflow-y: auto;
  padding: 10px;
  background: #f5f5f5;
  border-radius: 4px;
  margin-bottom: 15px;
}

.tag-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 8px 12px;
  background: #fff;
  border: 1px solid #ddd;
  border-radius: 20px;
  cursor: pointer;
  transition: all 0.2s;
  font-size: 14px;
}

.tag-item:hover {
  border-color: #1890ff;
  box-shadow: 0 2px 8px rgba(24, 144, 255, 0.2);
}

.tag-item.selected {
  background: #e6f7ff;
  border-color: #1890ff;
  color: #1890ff;
}

.tag-name {
  margin-right: 8px;
}

.tag-type {
  font-size: 12px;
  color: #999;
  background: #f0f0f0;
  padding: 2px 6px;
  border-radius: 10px;
}

/* 已选择标签样式 */
.selected-tags {
  margin-top: 15px;
}

.selected-tags h4 {
  margin: 0 0 10px 0;
  font-size: 14px;
  color: #666;
}

.selected-tag-list {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.selected-tag-item {
  display: flex;
  align-items: center;
  padding: 6px 10px;
  background: #e6f7ff;
  border: 1px solid #91d5ff;
  border-radius: 16px;
  font-size: 14px;
  color: #1890ff;
}

.remove-tag {
  background: none;
  border: none;
  color: #ff4d4f;
  font-size: 16px;
  cursor: pointer;
  margin-left: 6px;
  padding: 0;
  width: 16px;
  height: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  transition: all 0.2s;
}

.remove-tag:hover {
  background: #ff4d4f;
  color: #fff;
}

/* 错误信息样式 */
.error-message {
  color: #ff4d4f;
  margin: 10px 0;
  font-size: 14px;
  padding: 8px 12px;
  background: #fff2f0;
  border: 1px solid #ffccc7;
  border-radius: 4px;
}

/* 表单操作按钮样式 */
.form-actions {
  display: flex;
  gap: 10px;
  justify-content: flex-end;
  margin-top: 20px;
}

/* 按钮样式 */
.btn {
  padding: 8px 16px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
  transition: all 0.2s;
}

.btn.primary {
  background: #1890ff;
  color: #fff;
}

.btn.primary:hover {
  background: #40a9ff;
}

.btn.primary:disabled {
  background: #d9d9d9;
  cursor: not-allowed;
}

.btn.secondary {
  background: #f0f0f0;
  color: #555;
}

.btn.secondary:hover {
  background: #e0e0e0;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .card {
    margin: 10px;
    padding: 15px;
  }
  
  .form-row {
    flex-direction: column;
    gap: 15px;
  }
  
  .form-group {
    min-width: auto;
  }
  
  .tag-list {
    max-height: 150px;
  }
}
</style>