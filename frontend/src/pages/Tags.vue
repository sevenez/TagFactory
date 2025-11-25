<template>
  <div class="tags-container">
    <div class="toolbar">
      <div class="title">🔖 标签管理</div>
      <div class="actions">
        <button class="btn primary">新建标签</button>
        <button class="btn secondary">导出数据</button>
      </div>
    </div>
    
    <!-- 数据库连接状态 -->
    <div class="connection-status">
      <div v-if="mysqlSource" class="status-container">
        <div class="status-info">
          <span class="source-name">{{ mysqlSource.name }}</span>
          <span :class="['status-badge', getStatusClass(connectionStatus)]">
            {{ getStatusText(connectionStatus) }}
          </span>
          <span class="last-checked" v-if="mysqlSource.last_checked_at">
            最近检查: {{ formatTime(mysqlSource.last_checked_at) }}
          </span>
        </div>
        <button 
          class="btn refresh-btn" 
          @click="handleRefresh"
          :disabled="connectionStatus === 'connecting'"
        >
          <span v-if="connectionStatus === 'connecting'">🔄 连接中...</span>
          <span v-else>🔄 刷新连接</span>
        </button>
      </div>
      
      <!-- 错误提示 -->
      <div v-if="connectionError" class="error-message">
        <span class="error-icon">⚠️</span>
        <span>{{ connectionError }}</span>
      </div>
      
      <!-- 连接状态详情 -->
      <div v-if="connectionDetails" class="connection-details">
        <div class="detail-item">
          <span class="label">活跃连接数:</span>
          <span class="value">{{ connectionDetails.active_connections }}</span>
        </div>
        <div class="detail-item">
          <span class="label">连接池大小:</span>
          <span class="value">{{ connectionDetails.pool_size }}</span>
        </div>
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
          <table class="tags-table">
            <thead>
              <tr>
                <th @click="handleSort('name')" class="sortable">
                  标签名称
                  <span class="sort-icon" v-if="sortBy === 'name'">
                    {{ sortOrder === 'asc' ? '↑' : '↓' }}
                  </span>
                </th>
                <th @click="handleSort('tag_id')" class="sortable">
                  标签ID
                  <span class="sort-icon" v-if="sortBy === 'tag_id'">
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
                  'tag-row-user': tag.type === 'USER',
                  'tag-row-merchant': tag.type === 'MERCHANT',
                  'tag-row-product': tag.type === 'PRODUCT'
                }"
              >
                <td class="tag-name">
                  <span class="tag-type-icon">{{ getTagTypeIcon(tag.type) }}</span>
                  {{ tag.name }}
                </td>
                <td class="tag-id">{{ tag.tag_id }}</td>
                <td class="tag-type">
                  <span :class="['tag-type-badge', `tag-type-${tag.type.toLowerCase()}`]">
                    {{ getTagTypeName(tag.type) }}
                  </span>
                </td>
                <td class="tag-layer">
                  <span :class="['tag-layer-badge', `tag-layer-${tag.layer.toLowerCase()}`]">
                    {{ tag.layer }}
                  </span>
                </td>
                <td class="tag-coverage">{{ formatNumber(tag.cover_users) }}</td>
                <td class="tag-status">
                  <span :class="['tag-status-badge', `tag-status-${tag.status.toLowerCase()}`]">
                    <span class="status-icon">{{ getStatusIcon(tag.status) }}</span>
                    {{ getStatusName(tag.status) }}
                  </span>
                </td>
                <td class="tag-created">{{ formatDate(tag.created_at) }}</td>
                <td class="tag-actions">
                  <button class="action-btn edit-btn" title="编辑">
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
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useRoute } from 'vue-router'
import client from '../api/client'

// 获取路由信息
const route = useRoute()

// 数据库连接管理
const sources = ref([])
const connectionStatus = ref('disconnected') // disconnected, connecting, connected, error
const connectionError = ref('')
const connectionDetails = ref(null)
const reconnectAttempts = ref(0)
const maxReconnectAttempts = ref(3)

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

// 分页设置
const pageSize = ref(20)
const currentPage = ref(1)
const totalTags = ref(0)
const sortBy = ref('created_at')
const sortOrder = ref('desc')

// 标签页配置
const tabs = [
  { key: 'all', name: '全部标签', icon: '📋' },
  { key: 'user', name: '用户标签', icon: '🧑' },
  { key: 'merchant', name: '商家标签', icon: '🏪' },
  { key: 'product', name: '商品标签', icon: '📦' }
]

// 计算属性：筛选后的标签列表
const filteredTags = computed(() => {
  return tags.value.filter(tag => {
    // 标签类型筛选
    if (activeTab.value !== 'all') {
      const tagTypeMap = {
        'user': 'USER',
        'merchant': 'MERCHANT',
        'product': 'PRODUCT'
      }
      if (tag.type !== tagTypeMap[activeTab.value]) {
        return false
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

// 计算属性：MySQL数据源
const mysqlSource = computed(() => {
  return sources.value.find(s => s.source_id === 'DS_MYSQL')
})

// 数据库连接状态样式
const getStatusClass = (status) => {
  const statusClasses = {
    connected: 'status-connected',
    connecting: 'status-connecting',
    disconnected: 'status-disconnected',
    error: 'status-error'
  }
  return statusClasses[status] || 'status-disconnected'
}

// 数据库连接状态文本
const getStatusText = (status) => {
  const statusTexts = {
    connected: '已连接',
    connecting: '连接中',
    disconnected: '未连接',
    error: '连接错误'
  }
  return statusTexts[status] || '未知状态'
}

// 格式化时间
const formatTime = (timeString) => {
  if (!timeString) return ''
  try {
    const date = new Date(timeString)
    return date.toLocaleString('zh-CN')
  } catch {
    return timeString
  }
}

// 标签类型映射
const getTagTypeName = (type) => {
  const typeMap = {
    'USER': '用户标签',
    'MERCHANT': '商家标签',
    'PRODUCT': '商品标签'
  }
  return typeMap[type] || type
}

// 标签类型图标
const getTagTypeIcon = (type) => {
  const iconMap = {
    'USER': '👤',
    'MERCHANT': '🏪',
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

// 加载数据源和连接状态
const load = async () => {
  try {
    // 获取数据源状态
    const s = await client.get('/data/sources')
    sources.value = s.data
    
    // 获取连接状态详情
    await loadConnectionStatus()
    
    // 如果连接成功，加载标签数据
    if (connectionStatus.value === 'connected') {
      await fetchTags()
    }
  } catch (error) {
    console.error('加载数据失败:', error)
    connectionError.value = error.response?.data?.message || '加载数据失败，请稍后重试'
  }
}

// 加载数据库连接状态
const loadConnectionStatus = async () => {
  try {
    const response = await client.get('/data/connection/status')
    if (response.data && response.data.status) {
      connectionDetails.value = response.data.status
      connectionStatus.value = response.data.status.connected ? 'connected' : 'disconnected'
      connectionError.value = response.data.status.error || ''
    }
  } catch (error) {
    console.error('获取连接状态失败:', error)
    connectionStatus.value = 'error'
    if (error.response) {
      connectionError.value = `服务器错误: ${error.response.status} - ${error.response.statusText}`;
    } else if (error.request) {
      connectionError.value = '网络错误: 无法连接到服务器，请检查后端服务是否启动';
    } else {
      connectionError.value = `请求错误: ${error.message}`;
    }
  }
}

// 自动重连功能
const autoReconnect = async () => {
  reconnectAttempts.value++
  
  if (reconnectAttempts.value <= maxReconnectAttempts.value) {
    // 更新状态为连接中
    connectionStatus.value = 'connecting'
    connectionError.value = `正在尝试第 ${reconnectAttempts.value} 次重连...`
    
    try {
      // 等待一小段时间后再尝试重连
      await new Promise(resolve => setTimeout(resolve, 1000))
      
      // 再次触发刷新连接
      const response = await client.post('/data/connection/refresh')
      
      if (response.data) {
        if (response.data.connected) {
          // 重连成功
          connectionStatus.value = 'connected'
          connectionError.value = ''
          await fetchTags()
        } else {
          // 重连失败，继续尝试
          await autoReconnect()
        }
      }
    } catch (error) {
      console.error(`第 ${reconnectAttempts.value} 次重连失败:`, error)
      // 重连失败，继续尝试
      await autoReconnect()
    }
  } else {
    // 达到最大重连次数
    connectionStatus.value = 'error'
    connectionError.value = '达到最大重连次数（3次），请检查数据库配置和网络连接后手动重试'
  }
}

// 刷新数据库连接 - 与模板中的调用名称匹配
const handleRefresh = async () => {
  // 设置为连接中状态
  connectionStatus.value = 'connecting'
  connectionError.value = ''
  reconnectAttempts.value = 0
  
  try {
    const response = await client.post('/data/connection/refresh')
    
    if (response.data) {
      // 更新连接状态
      if (response.data.connected) {
        connectionStatus.value = 'connected'
        connectionError.value = ''
        // 刷新数据
        await load()
      } else {
        connectionStatus.value = 'error'
        const errorMsg = response.data.error || '连接失败，请检查数据库配置';
        connectionError.value = `连接失败: ${errorMsg}`;
        // 尝试自动重连
        await autoReconnect()
      }
    }
  } catch (error) {
    console.error('刷新连接失败:', error)
    connectionStatus.value = 'error'
    if (error.response) {
      connectionError.value = `服务器错误: ${error.response.status} - ${error.response.statusText}`;
    } else if (error.request) {
      connectionError.value = '网络错误: 无法连接到服务器，请检查后端服务是否启动';
    } else {
      connectionError.value = `请求错误: ${error.message}`;
    }
    // 尝试自动重连
    await autoReconnect()
  }
}

// 获取标签数据
const fetchTags = async () => {
  loading.value = true
  try {
    // 确保数据库连接正常
    if (connectionStatus.value !== 'connected') {
      await loadConnectionStatus()
      if (connectionStatus.value !== 'connected') {
        throw new Error('数据库连接失败，请检查连接状态')
      }
    }
    
    const params = {
      page: currentPage.value,
      page_size: pageSize.value,
      type: activeTab.value === 'all' ? '' : {
        'user': 'USER',
        'merchant': 'MERCHANT',
        'product': 'PRODUCT'
      }[activeTab.value],
      name: searchKeyword.value,
      status: status.value,
      created_at: created.value,
      sort_by: sortBy.value,
      sort_order: sortOrder.value
    }
    
    const response = await client.get('/tags', { params })
    if (response.data) {
      tags.value = response.data.data || []
      totalTags.value = response.data.total || 0
    }
  } catch (error) {
    console.error('获取标签数据失败:', error)
    connectionError.value = error.response?.data?.error || error.message || '获取标签数据失败，请稍后重试'
    connectionStatus.value = 'error'
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

// 获取连接状态样式类
const getConnectionStatusClass = (status) => {
  const statusClasses = {
    connected: 'status-connected',
    connecting: 'status-connecting',
    disconnected: 'status-disconnected',
    error: 'status-error'
  }
  return statusClasses[status] || 'status-disconnected'
}

// 获取连接状态文本
const getConnectionStatusText = (status) => {
  const statusTexts = {
    connected: '已连接',
    connecting: '连接中',
    disconnected: '未连接',
    error: '连接错误'
  }
  return statusTexts[status] || '未知状态'
}

// 启用标签
const enableTag = async (tagId) => {
  try {
    await client.put(`/tags/${tagId}/enable`)
    await fetchTags()
  } catch (error) {
    console.error('启用标签失败:', error)
  }
}

// 停用标签
const disableTag = async (tagId) => {
  try {
    await client.put(`/tags/${tagId}/disable`)
    await fetchTags()
  } catch (error) {
    console.error('停用标签失败:', error)
  }
}

// 删除标签
const deleteTag = async (tagId) => {
  try {
    await client.delete(`/tags/${tagId}`)
    await fetchTags()
  } catch (error) {
    console.error('删除标签失败:', error)
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
onMounted(load)
</script>

<style scoped>
.tags-container {
  width: 100%;
  padding: 20px;
  background-color: #f5f7fa;
  min-height: 100vh;
}

/* 数据库连接状态样式 */
.connection-status {
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
  padding: 16px;
  margin-bottom: 20px;
}

.status-info {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 12px;
}

.status-label {
  font-weight: 500;
  color: #606266;
}

.status-badge {
  padding: 6px 12px;
  border-radius: 16px;
  font-size: 14px;
  font-weight: 500;
}

.status-connected {
  background: rgba(82, 196, 26, 0.1);
  color: #67c23a;
}

.status-connecting {
  background: rgba(250, 173, 20, 0.1);
  color: #e6a23c;
}

.status-disconnected {
  background: rgba(245, 34, 45, 0.1);
  color: #f56c6c;
}

.status-error {
  background: rgba(245, 34, 45, 0.1);
  color: #f56c6c;
}

.refresh-btn {
  padding: 6px 12px;
  font-size: 14px;
}

.error-message {
  background: rgba(245, 34, 45, 0.08);
  border: 1px solid rgba(245, 34, 45, 0.2);
  border-radius: 6px;
  padding: 12px;
  margin-bottom: 12px;
  display: flex;
  align-items: center;
  gap: 8px;
  color: #f56c6c;
  font-size: 14px;
}

.error-icon {
  font-size: 16px;
}

.connection-details {
  display: flex;
  gap: 24px;
  padding: 8px 0;
  font-size: 14px;
}

.detail-item {
  display: flex;
  gap: 6px;
}

.detail-label {
  color: #909399;
}

.detail-value {
  font-weight: 600;
  color: #303133;
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
}

.tags-table {
  width: 100%;
  border-collapse: collapse;
  background-color: white;
  border-radius: 6px;
  overflow: hidden;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.05);
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

.tag-row {
  transition: all 0.3s ease;
  border-bottom: 1px solid #ebeef5;
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
}

/* 标签名称样式 */
.tag-name {
  display: flex;
  align-items: center;
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

.tag-type-user {
  background-color: #ecf5ff;
  color: #409eff;
}

.tag-type-merchant {
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
}

/* 响应式设计 */
@media (max-width: 768px) {
  .tags-container {
    padding: 10px;
  }
  
  .connection-status {
    padding: 12px;
  }
  
  .status-info {
    flex-wrap: wrap;
    gap: 8px;
  }
  
  .connection-details {
    flex-direction: column;
    gap: 8px;
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
