<template>
  <div class="tags-container">
    <div class="toolbar">
      <div class="title">🔖 标签管理</div>
      <div class="actions">
        <button class="btn primary" @click="openCreateTagDialog">新建标签</button>
        <button class="btn secondary">导出数据</button>
      </div>
    </div>
    
    <!-- 标签页组件 -->
    <div class="card">
      <div class="tab-container">
        <div class="tabs">
          <div 
            v-for="tab in tabs" 
            :key="tab.key"
            :class="['tab', { active: activeTab === tab.key }]"
            @click="switchTab(tab.key)"
          >
            <span class="tab-icon">{{ tab.icon }}</span>
            <span class="tab-text">{{ tab.name }}</span>
          </div>
        </div>
        
        <!-- 搜索和筛选区域 -->
        <div class="search-filters">
          <div class="search-box">
            <input 
              v-model="searchKeyword" 
              type="text" 
              placeholder="搜索标签名称..." 
              class="search-input"
              @keyup.enter="fetchTags"
            />
            <button class="search-btn" @click="fetchTags">
              <span class="search-icon">🔍</span>
            </button>
          </div>
          
          <div class="filters">
            <select v-model="status" class="select">
              <option value="">全部状态</option>
              <option value="ENABLED">已启用</option>
              <option value="PENDING">待审核</option>
              <option value="DISABLED">已停用</option>
            </select>
            <input 
              v-model="created" 
              type="date" 
              class="input date-input"
              placeholder="创建日期"
            />
            <select v-model="sortBy" class="select">
              <option value="created_at:desc">最新创建</option>
              <option value="created_at:asc">最早创建</option>
              <option value="name:asc">名称升序</option>
              <option value="name:desc">名称降序</option>
              <option value="cover_users:desc">覆盖数量降序</option>
              <option value="cover_users:asc">覆盖数量升序</option>
            </select>
            <button class="btn primary" @click="fetchTags">查询</button>
            <button class="btn ghost" @click="reset">重置</button>
          </div>
        </div>
        
        <!-- 加载状态 -->
        <div v-if="loading" class="loading-container">
          <div class="loading-spinner"></div>
          <div class="loading-text">加载中...</div>
        </div>
        
        <!-- 标签列表 -->
        <div v-else-if="filteredTags.length > 0" class="tags-list">
          <div class="tags-table-container">
            <table class="tags-table">
            <thead>
              <tr>
                <th @click="handleSort('tag_id')" class="sortable">
                  标签ID
                  <span class="sort-icon" v-if="sortBy === 'tag_id'">
                    {{ sortOrder === 'asc' ? '↑' : '↓' }}
                  </span>
                </th>
                <th @click="handleSort('name')" class="sortable">
                  标签名称
                  <span class="sort-icon" v-if="sortBy === 'name'">
                    {{ sortOrder === 'asc' ? '↑' : '↓' }}
                  </span>
                </th>
                <th @click="handleSort('type')" class="sortable">
                  类型
                  <span class="sort-icon" v-if="sortBy === 'type'">
                    {{ sortOrder === 'asc' ? '↑' : '↓' }}
                  </span>
                </th>
                <th @click="handleSort('layer')" class="sortable">
                  层级
                  <span class="sort-icon" v-if="sortBy === 'layer'">
                    {{ sortOrder === 'asc' ? '↑' : '↓' }}
                  </span>
                </th>
                <th @click="handleSort('cover_users')" class="sortable">
                  覆盖数量
                  <span class="sort-icon" v-if="sortBy === 'cover_users'">
                    {{ sortOrder === 'asc' ? '↑' : '↓' }}
                  </span>
                </th>
                <th @click="handleSort('status')" class="sortable">
                  状态
                  <span class="sort-icon" v-if="sortBy === 'status'">
                    {{ sortOrder === 'asc' ? '↑' : '↓' }}
                  </span>
                </th>
                <th @click="handleSort('created_at')" class="sortable">
                  创建时间
                  <span class="sort-icon" v-if="sortBy === 'created_at'">
                    {{ sortOrder === 'asc' ? '↑' : '↓' }}
                  </span>
                </th>
                <th>操作</th>
              </tr>
            </thead>
            <tbody>
              <tr 
                v-for="tag in filteredTags" 
                :key="tag.tag_id"
                class="tag-row"
                :class="{
                  'tag-row-user': tag.type === 'USER' || tag.type === 'CUSTOMER',
                  'tag-row-merchant': tag.type === 'MERCHANT' || tag.type === 'SELLER',
                  'tag-row-product': tag.type === 'PRODUCT'
                }"
              >
                <td class="tag-id">{{ tag.tag_id }}</td>
                <td class="tag-name">
                  {{ tag.name }}
                </td>
                <td class="tag-type">
                  <span :class="['tag-type-badge', `tag-type-${tag.type?.toLowerCase() || ''}`]">
                    {{ getTagTypeName(tag.type) }}
                  </span>
                </td>
                <td class="tag-layer">
                  <span :class="['tag-layer-badge', `tag-layer-${tag.layer?.toLowerCase() || ''}`]">
                    {{ tag.layer || '' }}
                  </span>
                </td>
                <td class="tag-coverage">{{ formatNumber(tag.cover_users) }}</td>
                <td class="tag-status">
                  <span :class="['tag-status-badge', `tag-status-${tag.status?.toLowerCase() || ''}`]">
                    <span class="status-icon">{{ getStatusIcon(tag.status) }}</span>
                    {{ getStatusName(tag.status) }}
                  </span>
                </td>
                <td class="tag-created">{{ formatDate(tag.created_at) }}</td>
                <td class="tag-actions">
                  <button class="action-btn edit-btn" title="编辑" @click="openEditTagDialog(tag)">
                    ✏️
                  </button>
                  <button 
                    v-if="tag.status !== 'ENABLED'" 
                    class="action-btn enable-btn" 
                    title="启用"
                    @click="handleEnable(tag)"
                  >
                    🟢
                  </button>
                  <button 
                    v-if="tag.status !== 'DISABLED'" 
                    class="action-btn disable-btn" 
                    title="停用"
                    @click="handleDisable(tag)"
                  >
                    🔴
                  </button>
                  <button 
                    v-if="tag.status === 'PENDING'" 
                    class="action-btn delete-btn" 
                    title="删除"
                    @click="handleDelete(tag)"
                  >
                    🗑️
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
          </div>
            
            <!-- 分页控件 -->
          <div class="pagination">
            <div class="page-info">
              显示 {{ (currentPage - 1) * pageSize + 1 }}-{{ Math.min(currentPage * pageSize, totalTags) }} 条，共 {{ totalTags }} 条
            </div>
            <div class="page-controls">
              <button 
                class="btn page-btn" 
                @click="changePage(currentPage - 1)" 
                :disabled="currentPage === 1"
              >
                上一页
              </button>
              <span class="page-numbers">
                <button 
                  v-for="page in visiblePages" 
                  :key="page"
                  class="btn page-number" 
                  :class="{ active: page === currentPage }"
                  @click="changePage(page)"
                >
                  {{ page }}
                </button>
              </span>
              <button 
                class="btn page-btn" 
                @click="changePage(currentPage + 1)" 
                :disabled="currentPage >= totalPages"
              >
                下一页
              </button>
            </div>
          </div>
        </div>
        
        <!-- 空状态 -->
        <div v-else class="empty-state">
          <div class="empty-icon">📭</div>
          <div class="empty-text">暂无标签数据</div>
          <div class="empty-subtext">尝试调整筛选条件或创建新标签</div>
        </div>
      </div>
    </div>
    
    <!-- 操作确认对话框 -->
    <div v-if="showConfirmDialog" class="confirm-overlay">
      <div class="confirm-dialog">
        <div class="confirm-title">{{ confirmTitle }}</div>
        <div class="confirm-content">{{ confirmContent }}</div>
        <div class="confirm-actions">
          <button class="btn secondary" @click="cancelAction">取消</button>
          <button class="btn danger" @click="handleConfirmAction">确认</button>
        </div>
      </div>
    </div>
    
    <!-- 标签编辑/创建对话框 -->
    <div v-if="showTagDialog" class="confirm-overlay">
      <div class="confirm-dialog" style="width: 500px;">
        <div class="confirm-title">{{ isEditMode ? '编辑标签' : '新建标签' }}</div>
        <div class="tag-form">
          <div class="form-group">
            <label class="form-label">标签名称</label>
            <input 
              v-model="tagForm.name" 
              type="text" 
              class="form-input" 
              placeholder="请输入标签名称"
              required
            />
          </div>
          
          <div class="form-row">
            <div class="form-group" style="flex: 1; margin-right: 10px;">
              <label class="form-label">标签类型</label>
              <select v-model="tagForm.type" class="form-input">
                <option value="USER">客户标签</option>
                <option value="MERCHANT">商家标签</option>
                <option value="PRODUCT">商品标签</option>
              </select>
            </div>
            
            <div class="form-group" style="flex: 1;">
              <label class="form-label">标签状态</label>
              <select v-model="tagForm.status" class="form-input">
                <option value="ENABLED">已启用</option>
                <option value="PENDING">待审核</option>
                <option value="DISABLED">已停用</option>
              </select>
            </div>
          </div>
          
          <div class="form-group">
            <label class="form-label">标签描述</label>
            <textarea 
              v-model="tagForm.description" 
              class="form-input" 
              rows="3" 
              placeholder="请输入标签描述"
            ></textarea>
          </div>
        </div>
        <div class="confirm-actions">
          <button class="btn secondary" @click="cancelTagDialog">取消</button>
          <button 
            class="btn primary" 
            @click="saveTag" 
            :disabled="savingTag"
          >
            {{ savingTag ? '保存中...' : '保存' }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useRoute } from 'vue-router'
import client from '../api/client'

// 获取路由信息
const route = useRoute()

// 响应式数据
const activeTab = ref('all')
const searchKeyword = ref('')
const status = ref('')
const created = ref('')
const tags = ref([])
const loading = ref(false)
const showConfirmDialog = ref(false)
const confirmAction = ref(null)
const confirmTitle = ref('')
const confirmContent = ref('')
const currentTag = ref(null)

// 标签编辑/创建相关
const showTagDialog = ref(false)
const isEditMode = ref(false)
const savingTag = ref(false)
const tagForm = ref({
  tag_id: '',
  name: '',
  type: 'USER',
  status: 'PENDING',
  description: ''
})

// 分页设置
const pageSize = ref(20)
const currentPage = ref(1)
const totalTags = ref(0)
const sortBy = ref('created_at')
const sortOrder = ref('desc')

// 标签页配置
const tabs = [
  { key: 'all', name: '全部标签', icon: '📋' },
  { key: 'user', name: '客户标签', icon: '🧑' },
  { key: 'merchant', name: '商家标签', icon: '🏪' },
  { key: 'product', name: '商品标签', icon: '📦' }
]

// 计算属性：筛选后的标签列表
const filteredTags = computed(() => {
  const result = tags.value.filter(tag => {
    // 标签类型筛选
    if (activeTab.value !== 'all') {
      const userTypes = ['USER', 'CUSTOMER']
      const merchantTypes = ['MERCHANT', 'SELLER']
      const productTypes = ['PRODUCT']
      
      if (activeTab.value === 'user') {
        return userTypes.includes(tag.type)
      } else if (activeTab.value === 'merchant') {
        return merchantTypes.includes(tag.type)
      } else if (activeTab.value === 'product') {
        return productTypes.includes(tag.type)
      }
    }
    
    // 搜索关键词筛选
    if (searchKeyword.value && !tag.name.toLowerCase().includes(searchKeyword.value.toLowerCase())) {
      return false
    }
    
    // 状态筛选
    if (status.value && tag.status !== status.value) {
      return false
    }
    
    // 创建日期筛选
    if (created.value) {
      const tagDate = tag.created_at ? tag.created_at.substring(0, 10) : ''
      if (tagDate !== created.value) {
        return false
      }
    }
    
    return true
  })
  
  return result
})

// 计算总页数
const totalPages = computed(() => {
  return Math.ceil(totalTags.value / pageSize.value) || 1
})

// 计算可见页码范围
const visiblePages = computed(() => {
  const pages = []
  const maxVisiblePages = 5
  let startPage = Math.max(1, currentPage.value - Math.floor(maxVisiblePages / 2))
  let endPage = Math.min(totalPages.value, startPage + maxVisiblePages - 1)
  
  // 调整起始页码，确保显示足够的页码
  if (endPage - startPage + 1 < maxVisiblePages) {
    startPage = Math.max(1, endPage - maxVisiblePages + 1)
  }
  
  for (let i = startPage; i <= endPage; i++) {
    pages.push(i)
  }
  return pages
})

// 标签类型映射
const getTagTypeName = (type) => {
  const typeMap = {
    'USER': '客户标签',
    'CUSTOMER': '客户标签',
    'MERCHANT': '商家标签',
    'SELLER': '商家标签',
    'PRODUCT': '商品标签'
  }
  return typeMap[type] || type
}

// 标签类型图标
const getTagTypeIcon = (type) => {
  const iconMap = {
    'USER': '👤',
    'CUSTOMER': '👤',
    'MERCHANT': '🏪',
    'SELLER': '🏪',
    'PRODUCT': '📦'
  }
  return iconMap[type] || '🏷️'
}

// 状态名称映射
const getStatusName = (status) => {
  const statusMap = {
    'ENABLED': '已启用',
    'PENDING': '待审核',
    'DISABLED': '已停用'
  }
  return statusMap[status] || status
}

// 状态图标映射
const getStatusIcon = (status) => {
  const iconMap = {
    'ENABLED': '✅',
    'PENDING': '⏳',
    'DISABLED': '❌'
  }
  return iconMap[status] || ''
}

// 切换标签页
const switchTab = (tabKey) => {
  activeTab.value = tabKey
  currentPage.value = 1
  fetchTags()
}

// 获取标签数据
const fetchTags = async () => {
  loading.value = true
  try {
    // 根据当前活跃页签设置标签类型筛选条件
    const type = activeTab.value !== 'all' ? {
      'user': ['USER', 'CUSTOMER'],
      'merchant': ['MERCHANT', 'SELLER'],
      'product': ['PRODUCT']
    }[activeTab.value] : ''
    
    // 构建查询参数
    const params = {
      page: currentPage.value,
      page_size: pageSize.value,
      name: searchKeyword.value,
      status: status.value,
      created_at: created.value,
      sort_by: sortBy.value,
      sort_order: sortOrder.value
    }
    
    // 构建URL，处理数组参数
    let url = '/tags?'
    const queryParams = []
    
    // 添加基本参数
    for (const [key, value] of Object.entries(params)) {
      if (value !== '' && value !== null && value !== undefined) {
        queryParams.push(`${encodeURIComponent(key)}=${encodeURIComponent(value)}`)
      }
    }
    
    // 添加类型参数，处理数组
    if (type && type.length > 0) {
      for (const t of type) {
        queryParams.push(`type=${encodeURIComponent(t)}`)
      }
    }
    
    // 构建完整URL
    url += queryParams.join('&')
    
    console.log('=== 开始请求标签数据 ===')
    console.log('当前活跃页签:', activeTab.value)
    console.log('标签类型:', type)
    console.log('请求URL:', url)
    
    const response = await client.get(url)
    
    console.log('=== 标签数据请求成功 ===')
    console.log('响应数据:', response.data)
    
    if (response.data) {
      tags.value = response.data.data || []
      totalTags.value = response.data.total || 0
      console.log('处理后的数据:', {
        tags: tags.value,
        totalTags: totalTags.value,
        tagsLength: tags.value.length
      })
    }
  } catch (error) {
    console.error('=== 获取标签数据失败 ===')
    console.error('错误信息:', error)
    console.error('错误类型:', error.type)
    console.error('错误状态:', error.status)
    console.error('错误响应:', error.response)
    // 显示错误信息给用户
    alert('获取标签数据失败，请稍后重试')
  } finally {
    loading.value = false
  }
}

// 重置筛选条件
const reset = () => {
  searchKeyword.value = ''
  status.value = ''
  created.value = ''
  sortBy.value = 'created_at'
  sortOrder.value = 'desc'
  currentPage.value = 1
  fetchTags()
}

// 切换页码
const changePage = (page) => {
  currentPage.value = page
  fetchTags()
}

// 处理排序
const handleSort = (field) => {
  if (sortBy.value === field) {
    // 如果点击的是当前排序字段，则切换排序顺序
    sortOrder.value = sortOrder.value === 'asc' ? 'desc' : 'asc'
  } else {
    // 否则设置新的排序字段和默认排序顺序
    sortBy.value = field
    sortOrder.value = 'desc'
  }
  currentPage.value = 1
  fetchTags()
}

// 启用标签
const enableTag = async (tagId) => {
  try {
    await client.put(`/tags/${tagId}/enable`)
    await fetchTags()
  } catch (error) {
    console.error('启用标签失败:', error)
    alert('启用标签失败，请稍后重试')
  }
}

// 停用标签
const disableTag = async (tagId) => {
  try {
    await client.put(`/tags/${tagId}/disable`)
    await fetchTags()
  } catch (error) {
    console.error('停用标签失败:', error)
    alert('停用标签失败，请稍后重试')
  }
}

// 删除标签
const deleteTag = async (tagId) => {
  try {
    await client.delete(`/tags/${tagId}`)
    await fetchTags()
  } catch (error) {
    console.error('删除标签失败:', error)
    alert('删除标签失败，请稍后重试')
  }
}

// 显示确认对话框
const showConfirm = (title, content, action, tag) => {
  confirmTitle.value = title
  confirmContent.value = content
  confirmAction.value = action
  currentTag.value = tag
  showConfirmDialog.value = true
}

// 确认操作
const handleConfirmAction = async () => {
  if (confirmAction.value && currentTag.value) {
    await confirmAction.value(currentTag.value.tag_id)
  }
  showConfirmDialog.value = false
  currentTag.value = null
  confirmAction.value = null
}

// 取消操作
const cancelAction = () => {
  showConfirmDialog.value = false
  currentTag.value = null
  confirmAction.value = null
}

// 处理启用操作
const handleEnable = (tag) => {
  showConfirm(
    '启用标签',
    `确定要启用标签 "${tag.name}" 吗？`,
    enableTag,
    tag
  )
}

// 处理停用操作
const handleDisable = (tag) => {
  showConfirm(
    '停用标签',
    `确定要停用标签 "${tag.name}" 吗？`,
    disableTag,
    tag
  )
}

// 处理删除操作
const handleDelete = (tag) => {
  showConfirm(
    '删除标签',
    `确定要删除标签 "${tag.name}" 吗？此操作不可恢复。`,
    deleteTag,
    tag
  )
}

// 打开创建标签对话框
const openCreateTagDialog = () => {
  isEditMode.value = false
  tagForm.value = {
    tag_id: '',
    name: '',
    type: 'USER',
    status: 'PENDING',
    description: ''
  }
  showTagDialog.value = true
}

// 打开编辑标签对话框
const openEditTagDialog = (tag) => {
  isEditMode.value = true
  tagForm.value = {
    tag_id: tag.tag_id,
    name: tag.name,
    type: tag.type,
    status: tag.status,
    description: tag.description || ''
  }
  showTagDialog.value = true
}

// 保存标签
const saveTag = async () => {
  if (!tagForm.value.name.trim()) {
    alert('标签名称不能为空')
    return
  }
  
  savingTag.value = true
  try {
    if (isEditMode.value) {
      // 更新标签
      await client.put(`/tags/${tagForm.value.tag_id}`, tagForm.value)
    } else {
      // 创建标签
      await client.post('/tags', tagForm.value)
    }
    
    // 关闭对话框
    showTagDialog.value = false
    
    // 刷新标签列表
    await fetchTags()
    
    // 显示成功消息
    alert(isEditMode.value ? '标签更新成功' : '标签创建成功')
  } catch (error) {
    console.error(isEditMode.value ? '更新标签失败:' : '创建标签失败:', error)
    alert(isEditMode.value ? '更新标签失败，请稍后重试' : '创建标签失败，请稍后重试')
  } finally {
    savingTag.value = false
  }
}

// 取消标签对话框
const cancelTagDialog = () => {
  showTagDialog.value = false
}

// 格式化日期
const formatDate = (dateString) => {
  return dateString ? dateString.substring(0, 10) : ''
}

// 格式化数字
const formatNumber = (number) => {
  return Intl.NumberFormat().format(number)
}

// 监听路由参数变化，自动切换标签页
watch(
  () => route.query.type,
  (newType) => {
    if (newType) {
      activeTab.value = newType
    } else {
      activeTab.value = 'all'
    }
  },
  { immediate: true }
)

// 监听筛选条件变化，自动重新加载数据
watch([searchKeyword, status, created, sortBy, sortOrder], () => {
  currentPage.value = 1
  fetchTags()
}, { deep: true })

// 组件挂载时获取数据
onMounted(fetchTags)
</script>

<style scoped>
.tags-container {
  width: 100%;
  padding: 20px;
  background-color: #f5f7fa;
  box-sizing: border-box;
  overflow: hidden;
}

.toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.title {
  font-size: 24px;
  font-weight: 700;
  color: #333;
}

.actions {
  display: flex;
  gap: 10px;
}

.btn {
  padding: 10px 20px;
  border: none;
  border-radius: 6px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s ease;
}

.btn.primary {
  background-color: #409eff;
  color: white;
}

.btn.primary:hover {
  background-color: #66b1ff;
}

.btn.secondary {
  background-color: #67c23a;
  color: white;
}

.btn.secondary:hover {
  background-color: #85ce61;
}

.btn.danger {
  background-color: #f56c6c;
  color: white;
}

.btn.danger:hover {
  background-color: #f78989;
}

.btn.ghost {
  background-color: transparent;
  border: 1px solid #dcdfe6;
  color: #606266;
}

.btn.ghost:hover {
  background-color: #f5f7fa;
}

.card {
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
  padding: 20px;
}

/* 标签页样式 */
.tab-container {
  width: 100%;
}

.tabs {
  display: flex;
  border-bottom: 2px solid #e4e7ed;
  margin-bottom: 20px;
  background-color: #fafafa;
  border-radius: 6px 6px 0 0;
  overflow: hidden;
}

.tab {
  display: flex;
  align-items: center;
  padding: 12px 24px;
  cursor: pointer;
  transition: all 0.3s ease;
  border-bottom: 2px solid transparent;
  font-weight: 500;
  color: #606266;
}

.tab:hover {
  color: #409eff;
  background-color: #ecf5ff;
}

.tab.active {
  color: #409eff;
  border-bottom-color: #409eff;
  background-color: white;
}

.tab-icon {
  margin-right: 6px;
  font-size: 16px;
}

.tab-text {
  font-size: 14px;
}

/* 搜索和筛选区域 */
.search-filters {
  display: flex;
  flex-wrap: wrap;
  gap: 15px;
  margin-bottom: 20px;
  align-items: center;
}

.search-box {
  display: flex;
  flex: 1;
  min-width: 300px;
}

.search-input {
  flex: 1;
  padding: 10px 15px;
  border: 1px solid #dcdfe6;
  border-radius: 6px 0 0 6px;
  font-size: 14px;
  transition: all 0.3s ease;
}

.search-input:focus {
  outline: none;
  border-color: #409eff;
  box-shadow: 0 0 0 2px rgba(64, 158, 255, 0.2);
}

.search-btn {
  padding: 10px 15px;
  background-color: #409eff;
  color: white;
  border: none;
  border-radius: 0 6px 6px 0;
  cursor: pointer;
  transition: all 0.3s ease;
}

.search-btn:hover {
  background-color: #66b1ff;
}

.search-icon {
  font-size: 16px;
}

.filters {
  display: flex;
  gap: 10px;
  align-items: center;
  flex-wrap: wrap;
}

.select, .input {
  padding: 10px 12px;
  border: 1px solid #dcdfe6;
  border-radius: 6px;
  font-size: 14px;
  transition: all 0.3s ease;
}

.select:focus, .input:focus {
  outline: none;
  border-color: #409eff;
  box-shadow: 0 0 0 2px rgba(64, 158, 255, 0.2);
}

.date-input {
  min-width: 150px;
}

/* 标签列表样式 */
.tags-list {
  overflow-x: auto;
  border-radius: 6px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.05);
}

.tags-table-container {
  height: 600px;
  overflow: auto;
  border-radius: 6px;
}

.tags-table {
  width: 100%;
  border-collapse: collapse;
  background-color: white;
  table-layout: fixed;
}

.tags-table thead {
  position: sticky;
  top: 0;
  z-index: 10;
  background-color: #f5f7fa;
}

.tags-table th {
  background-color: #f5f7fa;
  padding: 12px 15px;
  text-align: left;
  font-weight: 600;
  color: #303133;
  font-size: 14px;
  border-bottom: 2px solid #e4e7ed;
  cursor: pointer;
  transition: all 0.3s ease;
  position: relative;
}

.tags-table th:hover {
  background-color: #ecf5ff;
  color: #409eff;
}

.sortable {
  position: relative;
}

.sort-icon {
  margin-left: 6px;
  font-size: 12px;
  color: #909399;
}

.tags-table tbody {
  display: table-row-group;
}

.tags-table thead tr,
.tags-table tbody tr {
  display: table-row;
  width: 100%;
  table-layout: fixed;
}

.tag-row {
  transition: all 0.3s ease;
}

.tag-row:hover {
  background-color: #f5f7fa;
  transform: translateY(-1px);
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.05);
}

.tag-row-user:hover {
  background-color: #ecf5ff;
}

.tag-row-merchant:hover {
  background-color: #f0f9eb;
}

.tag-row-product:hover {
  background-color: #fef0f0;
}

.tag-row td {
  padding: 15px;
  font-size: 14px;
  color: #606266;
  border-bottom: 1px solid #ebeef5;
}

/* 标签名称样式 */
.tag-name {
  font-weight: 500;
  color: #303133;
}

.tag-type-icon {
  margin-right: 8px;
  font-size: 16px;
}

/* 标签ID样式 */
.tag-id {
  color: #909399;
  font-family: 'Courier New', Courier, monospace;
}

/* 标签类型样式 */
.tag-type-badge {
  padding: 4px 12px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 500;
}

.tag-type-user,
.tag-type-customer {
  background-color: #ecf5ff;
  color: #409eff;
}

.tag-type-merchant,
.tag-type-seller {
  background-color: #f0f9eb;
  color: #67c23a;
}

.tag-type-product {
  background-color: #fef0f0;
  color: #f56c6c;
}

/* 标签层级样式 */
.tag-layer-badge {
  padding: 4px 12px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 500;
}

.tag-layer-基础 {
  background-color: #ecf5ff;
  color: #409eff;
}

.tag-layer-统计 {
  background-color: #f0f9eb;
  color: #67c23a;
}

.tag-layer-衍生 {
  background-color: #fef0f0;
  color: #f56c6c;
}

.tag-layer-行为 {
  background-color: #fdf6ec;
  color: #e6a23c;
}

/* 标签状态样式 */
.tag-status-badge {
  padding: 4px 12px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 500;
  display: flex;
  align-items: center;
  gap: 4px;
}

.tag-status-enabled {
  background-color: #f0f9eb;
  color: #67c23a;
}

.tag-status-pending {
  background-color: #fdf6ec;
  color: #e6a23c;
}

.tag-status-disabled {
  background-color: #f5f7fa;
  color: #909399;
}

.status-icon {
  font-size: 10px;
}

/* 操作按钮样式 */
.tag-actions {
  display: flex;
  gap: 8px;
}

.action-btn {
  width: 32px;
  height: 32px;
  border: none;
  border-radius: 50%;
  cursor: pointer;
  font-size: 14px;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
}

.action-btn:hover {
  transform: scale(1.1);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
}

.edit-btn {
  background-color: #ecf5ff;
  color: #409eff;
}

.enable-btn {
  background-color: #f0f9eb;
  color: #67c23a;
}

.disable-btn {
  background-color: #fef0f0;
  color: #f56c6c;
}

.delete-btn {
  background-color: #fef0f0;
  color: #f56c6c;
}

/* 分页样式 */
.pagination {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px 0;
  font-size: 14px;
}

.page-info {
  color: #606266;
}

.page-controls {
  display: flex;
  align-items: center;
  gap: 12px;
}

.page-btn {
  padding: 6px 12px;
  font-size: 14px;
}

.page-numbers {
  display: flex;
  gap: 4px;
}

.page-number {
  padding: 6px 12px;
  font-size: 14px;
  min-width: 32px;
  text-align: center;
}

.page-number.active {
  background-color: #409eff;
  color: white;
}

/* 加载状态 */
.loading-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px 20px;
  color: #909399;
}

.loading-spinner {
  width: 40px;
  height: 40px;
  border: 4px solid #f3f3f3;
  border-top: 4px solid #409eff;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin-bottom: 15px;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.loading-text {
  font-size: 14px;
  color: #909399;
}

/* 空状态 */
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px 20px;
  color: #909399;
}

.empty-icon {
  font-size: 48px;
  margin-bottom: 15px;
  opacity: 0.5;
}

.empty-text {
  font-size: 16px;
  font-weight: 500;
  margin-bottom: 8px;
  color: #606266;
}

.empty-subtext {
  font-size: 14px;
  color: #909399;
}

/* 确认对话框 */
.confirm-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.confirm-dialog {
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
  width: 400px;
  max-width: 90%;
  padding: 20px;
}

.confirm-title {
  font-size: 16px;
  font-weight: 600;
  color: #303133;
  margin-bottom: 15px;
}

.confirm-content {
  font-size: 14px;
  color: #606266;
  margin-bottom: 20px;
  line-height: 1.5;
}

.confirm-actions {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  margin-top: 20px;
}

/* 标签表单样式 */
.tag-form {
  margin-top: 15px;
}

.form-group {
  margin-bottom: 15px;
}

.form-row {
  display: flex;
  gap: 10px;
  margin-bottom: 15px;
}

.form-label {
  display: block;
  font-size: 14px;
  font-weight: 500;
  color: #303133;
  margin-bottom: 8px;
}

.form-input {
  width: 100%;
  padding: 8px 12px;
  border: 1px solid #dcdfe6;
  border-radius: 6px;
  font-size: 14px;
  color: #606266;
  transition: all 0.3s ease;
}

.form-input:focus {
  outline: none;
  border-color: #409eff;
  box-shadow: 0 0 0 2px rgba(64, 158, 255, 0.2);
}

.form-input[type="text"],
.form-input[type="number"] {
  height: 36px;
}

.form-input[type="textarea"] {
  resize: vertical;
  min-height: 80px;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .tags-container {
    padding: 10px;
  }
  
  .toolbar {
    flex-direction: column;
    align-items: flex-start;
    gap: 10px;
  }
  
  .search-filters {
    flex-direction: column;
    align-items: stretch;
  }
  
  .search-box {
    min-width: auto;
  }
  
  .filters {
    flex-direction: column;
    align-items: stretch;
  }
  
  .select, .input {
    width: 100%;
  }
  
  .pagination {
    flex-direction: column;
    gap: 12px;
    align-items: center;
  }
  
  .page-controls {
    flex-wrap: wrap;
    justify-content: center;
  }
  
  .tags-table {
    font-size: 12px;
  }
  
  .tag-row td {
    padding: 10px 8px;
  }
  
  .tag-actions {
    flex-direction: column;
    gap: 4px;
  }
  
  .action-btn {
    width: 28px;
    height: 28px;
    font-size: 12px;
  }
}
</style>
