<template>
  <div class="card">
    <div class="title">标签审批</div>
    
    <!-- 审批状态统计 -->
    <div class="stats-container">
      <div class="stat-card">
        <div class="count">{{ pendingCount || 0 }}</div>
        <div class="label">待审批</div>
      </div>
      <div class="stat-card">
        <div class="count">{{ approvedCount || 0 }}</div>
        <div class="label">已通过</div>
      </div>
      <div class="stat-card">
        <div class="count">{{ rejectedCount || 0 }}</div>
        <div class="label">已拒绝</div>
      </div>
      <div class="stat-card">
        <div class="count">{{ totalCount || 0 }}</div>
        <div class="label">总计</div>
      </div>
    </div>
    
    <!-- 筛选区域 -->
    <div class="filter-section">
      <input 
        v-model="filters.name" 
        type="text" 
        placeholder="搜索标签名称..." 
        class="filter-input"
      />
      <select v-model="filters.status" class="filter-select">
        <option value="">全部状态</option>
        <option value="pending">待审批</option>
        <option value="approved">已通过</option>
        <option value="rejected">已拒绝</option>
      </select>
      <select v-model="filters.category" class="filter-select">
        <option value="">全部类型</option>
        <option value="商家标签">商家标签</option>
        <option value="用户标签">用户标签</option>
        <option value="商品标签">商品标签</option>
      </select>
      <button @click="loadApprovals" class="refresh-btn">
        🔄 刷新
      </button>
    </div>
    
    <!-- 审批列表 -->
    <div class="approval-list">
      <div v-if="loading" class="loading-state">
        <div class="spinner"></div>
        <span>加载中...</span>
      </div>
      
      <div v-else-if="approvals.length > 0" class="approval-items">
        <div v-for="approval in approvals" :key="approval.tag_id" class="approval-item">
          <div class="approval-info">
            <div class="tag-header">
              <h3 class="tag-name">{{ approval.name }}</h3>
              <span :class="['status-badge', getStatusClass(approval.status)]">
                {{ getStatusText(approval.status) }}
              </span>
            </div>
            <div class="tag-details">
              <span class="tag-category">{{ approval.category || '未分类' }}</span>
              <span class="tag-type">{{ approval.type || '普通标签' }}</span>
              <span class="tag-creator">创建者: {{ approval.creator || '系统' }}</span>
            </div>
            <div class="tag-description">
              {{ approval.description || '暂无描述' }}
            </div>
            <div class="tag-meta">
              <span class="create-time">创建时间: {{ formatTime(approval.create_time) }}</span>
              <span class="usage-count">使用次数: {{ approval.usage_count || 0 }}</span>
            </div>
          </div>
          
          <div class="approval-actions" v-if="approval.status === 'pending'">
            <button @click="approveTag(approval.tag_id)" class="approve-btn">
              ✓ 通过
            </button>
            <button @click="rejectTag(approval.tag_id)" class="reject-btn">
              ✕ 拒绝
            </button>
          </div>
          
          <div class="approval-result" v-else>
            <div class="result-info">
              <span class="processed-by">处理人: {{ approval.processor || '系统' }}</span>
              <span class="processed-time">处理时间: {{ formatTime(approval.processed_time) }}</span>
            </div>
            <div v-if="approval.remark" class="approval-remark">
              <strong>备注:</strong> {{ approval.remark }}
            </div>
          </div>
        </div>
      </div>
      
      <div v-else class="empty-state">
        <div class="empty-icon">📋</div>
        <div class="empty-text">暂无审批记录</div>
        <div class="empty-subtitle">当有新的标签提交审批时，会在此处显示</div>
      </div>
    </div>
    
    <!-- 分页 -->
    <div class="pagination" v-if="totalPages > 1">
      <span class="page-info">
        显示 {{ approvals.length > 0 ? ((currentPage - 1) * pageSize + 1) : 0 }}-{{ Math.min(currentPage * pageSize, totalCount) }} 条，共 {{ totalCount }} 条
      </span>
      <div class="page-buttons">
        <button @click="changePage(currentPage - 1)" :disabled="currentPage === 1">上一页</button>
        <button @click="changePage(currentPage + 1)" :disabled="currentPage >= totalPages">下一页</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed, watch } from 'vue'
import client from '../api/client'

// 响应式数据
const approvals = ref([])
const loading = ref(false)
const currentPage = ref(1)
const pageSize = ref(20)
const totalCount = ref(0)

const filters = ref({
  name: '',
  status: '',
  category: ''
})

// 计算属性
const totalPages = computed(() => Math.ceil(totalCount.value / pageSize.value))

const pendingCount = computed(() => approvals.value.filter(a => a.status === 'pending').length)
const approvedCount = computed(() => approvals.value.filter(a => a.status === 'approved').length)
const rejectedCount = computed(() => approvals.value.filter(a => a.status === 'rejected').length)

// 方法
const loadApprovals = async () => {
  try {
    loading.value = true
    
    const params = {
      page: currentPage.value,
      page_size: pageSize.value,
      ...(filters.value.name && { name: filters.value.name }),
      ...(filters.value.status && { status: filters.value.status }),
      ...(filters.value.category && { category: filters.value.category })
    }
    
    const response = await client.get('/data/approvals/tags', { params })
    
    if (response.data) {
      approvals.value = response.data.data || []
      totalCount.value = response.data.total || 0
    }
  } catch (error) {
    console.error('加载审批列表失败:', error)
  } finally {
    loading.value = false
  }
}

const approveTag = async (tagId) => {
  try {
    await client.post(`/data/approvals/tags/${tagId}/approve`)
    await loadApprovals()
  } catch (error) {
    console.error('审批通过失败:', error)
    alert('审批通过失败，请稍后重试')
  }
}

const rejectTag = async (tagId) => {
  try {
    const remark = prompt('请输入拒绝原因:')
    if (!remark) return
    
    await client.post(`/data/approvals/tags/${tagId}/reject`, { remark })
    await loadApprovals()
  } catch (error) {
    console.error('审批拒绝失败:', error)
    alert('审批拒绝失败，请稍后重试')
  }
}

const changePage = async (page) => {
  currentPage.value = page
  await loadApprovals()
}

const getStatusClass = (status) => {
  const statusClasses = {
    pending: 'status-pending',
    approved: 'status-approved',
    rejected: 'status-rejected'
  }
  return statusClasses[status] || 'status-pending'
}

const getStatusText = (status) => {
  const statusTexts = {
    pending: '待审批',
    approved: '已通过',
    rejected: '已拒绝'
  }
  return statusTexts[status] || '未知'
}

const formatTime = (timeString) => {
  if (!timeString) return ''
  try {
    const date = new Date(timeString)
    return date.toLocaleString('zh-CN')
  } catch {
    return timeString
  }
}

// 监听筛选条件变化
watch(filters, () => {
  currentPage.value = 1
  loadApprovals()
}, { deep: true })

// 组件挂载时加载数据
onMounted(loadApprovals)
</script>

<style scoped>
.card {
  padding: 20px;
  background: var(--color-panel);
  border-radius: 8px;
  border: 1px solid var(--border-color);
}

.title {
  font-size: 20px;
  font-weight: 600;
  color: var(--color-text);
  margin-bottom: 24px;
}

/* 统计卡片 */
.stats-container {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 16px;
  margin-bottom: 24px;
}

.stat-card {
  background: var(--color-bg);
  border: 1px solid var(--border-color);
  border-radius: 8px;
  padding: 20px;
  text-align: center;
}

.stat-card .count {
  font-size: 32px;
  font-weight: 700;
  color: var(--color-primary);
  margin-bottom: 8px;
}

.stat-card .label {
  font-size: 14px;
  color: var(--color-subtext);
}

/* 筛选区域 */
.filter-section {
  display: flex;
  gap: 12px;
  margin-bottom: 24px;
  flex-wrap: wrap;
}

.filter-input {
  flex: 1;
  min-width: 200px;
  padding: 8px 12px;
  border: 1px solid var(--border-color);
  border-radius: 6px;
  background: var(--color-bg);
  color: var(--color-text);
}

.filter-select {
  padding: 8px 12px;
  border: 1px solid var(--border-color);
  border-radius: 6px;
  background: var(--color-bg);
  color: var(--color-text);
  min-width: 150px;
}

.refresh-btn {
  padding: 8px 16px;
  background: var(--color-primary);
  color: white;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  font-weight: 500;
  transition: background-color 0.2s;
}

.refresh-btn:hover {
  background: var(--color-primary-hover);
}

/* 审批列表 */
.approval-list {
  min-height: 400px;
}

.loading-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px 20px;
  color: var(--color-subtext);
}

.spinner {
  width: 32px;
  height: 32px;
  border: 3px solid var(--border-color);
  border-top: 3px solid var(--color-primary);
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin-bottom: 16px;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.approval-items {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.approval-item {
  background: var(--color-bg);
  border: 1px solid var(--border-color);
  border-radius: 8px;
  padding: 20px;
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
}

.approval-info {
  flex: 1;
  margin-right: 20px;
}

.tag-header {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 12px;
}

.tag-name {
  font-size: 18px;
  font-weight: 600;
  color: var(--color-text);
  margin: 0;
}

.status-badge {
  padding: 4px 12px;
  border-radius: 16px;
  font-size: 12px;
  font-weight: 500;
}

.status-pending {
  background: rgba(250, 173, 20, 0.1);
  color: var(--color-warning);
}

.status-approved {
  background: rgba(82, 196, 26, 0.1);
  color: var(--color-success);
}

.status-rejected {
  background: rgba(245, 34, 45, 0.1);
  color: var(--color-danger);
}

.tag-details {
  display: flex;
  gap: 16px;
  margin-bottom: 8px;
  font-size: 14px;
}

.tag-category, .tag-type, .tag-creator {
  padding: 2px 8px;
  background: rgba(0, 0, 0, 0.05);
  border-radius: 4px;
  font-size: 12px;
}

.tag-description {
  color: var(--color-subtext);
  line-height: 1.5;
  margin-bottom: 12px;
}

.tag-meta {
  display: flex;
  gap: 20px;
  font-size: 12px;
  color: var(--color-subtext);
}

.approval-actions {
  display: flex;
  flex-direction: column;
  gap: 8px;
  min-width: 100px;
}

.approve-btn {
  padding: 8px 16px;
  background: var(--color-success);
  color: white;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  font-weight: 500;
}

.reject-btn {
  padding: 8px 16px;
  background: var(--color-danger);
  color: white;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  font-weight: 500;
}

.approval-result {
  display: flex;
  flex-direction: column;
  gap: 8px;
  min-width: 200px;
  font-size: 12px;
}

.result-info {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.approval-remark {
  padding: 8px;
  background: rgba(245, 34, 45, 0.05);
  border-radius: 4px;
  border-left: 3px solid var(--color-danger);
}

/* 空状态 */
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px 20px;
  color: var(--color-subtext);
}

.empty-icon {
  font-size: 48px;
  margin-bottom: 16px;
}

.empty-text {
  font-size: 16px;
  font-weight: 500;
  margin-bottom: 8px;
}

.empty-subtitle {
  font-size: 14px;
  opacity: 0.7;
}

/* 分页 */
.pagination {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 24px;
  padding-top: 16px;
  border-top: 1px solid var(--border-color);
}

.page-info {
  color: var(--color-subtext);
  font-size: 14px;
}

.page-buttons {
  display: flex;
  gap: 8px;
}

.page-buttons button {
  padding: 6px 12px;
  border: 1px solid var(--border-color);
  background: var(--color-bg);
  color: var(--color-text);
  border-radius: 4px;
  cursor: pointer;
  transition: all 0.2s;
}

.page-buttons button:hover:not(:disabled) {
  background: var(--color-primary);
  color: white;
  border-color: var(--color-primary);
}

.page-buttons button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

/* 响应式 */
@media (max-width: 768px) {
  .stats-container {
    grid-template-columns: repeat(2, 1fr);
  }
  
  .filter-section {
    flex-direction: column;
  }
  
  .filter-input, .filter-select {
    width: 100%;
  }
  
  .approval-item {
    flex-direction: column;
    gap: 16px;
  }
  
  .approval-info {
    margin-right: 0;
  }
  
  .approval-actions, .approval-result {
    width: 100%;
  }
  
  .tag-details {
    flex-wrap: wrap;
  }
}
</style>