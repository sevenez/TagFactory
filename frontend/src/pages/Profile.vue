<template>
  <div class="profile-container">
    <!-- 页面标题 -->
    <div class="toolbar">
      <div class="title">👤 个体画像</div>
    </div>
    
    <!-- 搜索区域 -->
    <div class="card search-card">
      <div class="search-filters">
        <div class="search-item">
          <label class="search-label">用户ID</label>
          <input 
            v-model="userId" 
            type="text" 
            placeholder="输入用户ID" 
            class="search-input"
            @keyup.enter="search"
          />
        </div>
        <div class="search-item">
          <label class="search-label">手机号</label>
          <input 
            v-model="phone" 
            type="text" 
            placeholder="输入手机号（支持模糊查询）" 
            class="search-input"
            @keyup.enter="search"
          />
        </div>
        <div class="search-actions">
          <button 
            class="btn primary" 
            @click="search"
            :disabled="loading"
          >
            <span v-if="loading" class="loading-spinner-small"></span>
            <span v-else>🔍 检索</span>
          </button>
          <button class="btn ghost" @click="reset">重置</button>
        </div>
      </div>
    </div>
    
    <!-- 错误提示 -->
    <div v-if="error" class="error-message">
      <span class="error-icon">⚠️</span>
      <span>{{ error }}</span>
      <button class="error-close" @click="error = ''">×</button>
    </div>
    
    <!-- 加载状态 -->
    <div v-if="loading" class="loading-container">
      <div class="loading-spinner"></div>
      <div class="loading-text">正在检索客户画像...</div>
    </div>
    
    <!-- 无结果提示 -->
    <div v-else-if="!user && hasSearched" class="no-result">
      <div class="no-result-icon">🔍</div>
      <div class="no-result-text">未找到匹配的客户信息</div>
      <div class="no-result-hint">请检查输入的客户ID或手机号是否正确</div>
    </div>
    
    <!-- 客户画像信息 -->
    <div v-else-if="user" class="profile-content">
      <!-- 基础信息 -->
      <div class="profile-section">
        <div class="section-header" @click="toggleSection('basic')">
          <div class="section-icon">📋</div>
          <div class="section-title">基础信息</div>
          <div class="section-toggle">
            <span v-if="expandedSections.basic">▼</span>
            <span v-else>▶</span>
          </div>
        </div>
        <div v-if="expandedSections.basic" class="section-content">
          <div class="basic-info-grid">
            <div class="info-item">
              <span class="info-label">用户ID</span>
              <span class="info-value">{{ user.user_id }}</span>
            </div>
            <div class="info-item">
              <span class="info-label">手机号</span>
              <span class="info-value">{{ user.phone }}</span>
            </div>
            <div class="info-item">
              <span class="info-label">注册时间</span>
              <span class="info-value">{{ user.registered_at }}</span>
            </div>
            <div class="info-item">
              <span class="info-label">最近活跃时间</span>
              <span class="info-value">{{ user.last_active_at }}</span>
            </div>
            <!-- 基础标签 -->
            <div class="info-item full-width">
              <span class="info-label">基础标签</span>
              <div class="tags-container">
                <span 
                  v-for="(value, key) in user.basic_tags" 
                  :key="key"
                  class="tag-item"
                >
                  {{ key }}：{{ value }}
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- 统计信息 -->
      <div class="profile-section">
        <div class="section-header" @click="toggleSection('stats')">
          <div class="section-icon">📊</div>
          <div class="section-title">统计信息</div>
          <div class="section-toggle">
            <span v-if="expandedSections.stats">▼</span>
            <span v-else>▶</span>
          </div>
        </div>
        <div v-if="expandedSections.stats" class="section-content">
          <div class="stats-grid">
            <!-- 行为标签 -->
            <div class="stats-column">
              <div class="column-title">行为统计</div>
              <div 
                v-for="(value, key) in user.behavior_tags" 
                :key="key"
                class="stats-item"
              >
                <span class="stats-label">{{ key }}</span>
                <span class="stats-value">{{ value }}</span>
              </div>
            </div>
            <!-- 统计标签 -->
            <div class="stats-column">
              <div class="column-title">消费统计</div>
              <div 
                v-for="(value, key) in user.stats_tags" 
                :key="key"
                class="stats-item"
              >
                <span class="stats-label">{{ key }}</span>
                <span class="stats-value">{{ value }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- 衍生信息 -->
      <div class="profile-section">
        <div class="section-header" @click="toggleSection('derived')">
          <div class="section-icon">🔮</div>
          <div class="section-title">衍生信息</div>
          <div class="section-toggle">
            <span v-if="expandedSections.derived">▼</span>
            <span v-else>▶</span>
          </div>
        </div>
        <div v-if="expandedSections.derived" class="section-content">
          <div class="derived-info">
            <div 
              v-for="(value, key) in user.derived_tags" 
              :key="key"
              class="derived-item"
            >
              <div class="derived-label">{{ key }}</div>
              <div class="derived-value">{{ value }}</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import client from '../api/client'

// 响应式数据
const userId = ref('')
const phone = ref('')
const user = ref(null)
const loading = ref(false)
const error = ref('')
const hasSearched = ref(false)

// 展开/折叠状态
const expandedSections = reactive({
  basic: true,
  stats: true,
  derived: true
})

// 缓存相关
const cache = ref({})
const CACHE_KEY_PREFIX = 'profile_cache_'
const CACHE_EXPIRY = 30 * 60 * 1000 // 30分钟

// 切换展开/折叠状态
const toggleSection = (section) => {
  expandedSections[section] = !expandedSections[section]
}

// 从缓存获取数据
const getFromCache = (key) => {
  const cacheKey = CACHE_KEY_PREFIX + key
  const cachedData = localStorage.getItem(cacheKey)
  if (cachedData) {
    const { data, timestamp } = JSON.parse(cachedData)
    if (Date.now() - timestamp < CACHE_EXPIRY) {
      return data
    } else {
      // 缓存过期，删除
      localStorage.removeItem(cacheKey)
    }
  }
  return null
}

// 保存到缓存
const saveToCache = (key, data) => {
  const cacheKey = CACHE_KEY_PREFIX + key
  const cacheData = {
    data,
    timestamp: Date.now()
  }
  localStorage.setItem(cacheKey, JSON.stringify(cacheData))
}

// 搜索用户
const search = async () => {
  // 验证输入
  if (!userId.value && !phone.value) {
    error.value = '请输入用户ID或手机号'
    return
  }
  
  // 清除之前的错误
  error.value = ''
  loading.value = true
  hasSearched.value = true
  
  try {
    // 构建缓存键
    const cacheKey = `userId:${userId.value}_phone:${phone.value}`
    
    // 尝试从缓存获取
    const cachedUser = getFromCache(cacheKey)
    if (cachedUser) {
      user.value = cachedUser
      loading.value = false
      return
    }
    
    // 构建请求参数
    const params = {}
    if (userId.value) {
      params.user_id = userId.value
    }
    if (phone.value) {
      params.phone = phone.value
    }
    
    // 发送请求
    const response = await client.get('/users/lookup', { params })
    
    // 保存到缓存
    saveToCache(cacheKey, response.data)
    
    // 更新用户数据
    user.value = response.data
  } catch (err) {
    console.error('搜索用户失败:', err)
    error.value = err.response?.data?.message || '搜索用户失败，请稍后重试'
    user.value = null
  } finally {
    loading.value = false
  }
}

// 重置搜索
const reset = () => {
  userId.value = ''
  phone.value = ''
  user.value = null
  error.value = ''
  hasSearched.value = false
}

// 组件挂载时检查URL参数
onMounted(() => {
  // 可以从URL参数中获取用户ID或手机号
  const urlParams = new URLSearchParams(window.location.search)
  const userIdParam = urlParams.get('userId')
  const phoneParam = urlParams.get('phone')
  
  if (userIdParam) {
    userId.value = userIdParam
    search()
  } else if (phoneParam) {
    phone.value = phoneParam
    search()
  }
})
</script>

<style scoped>
.profile-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

/* 工具栏样式 */
.toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.title {
  font-size: 24px;
  font-weight: 600;
  color: #2c3e50;
}

/* 搜索区域样式 */
.search-card {
  margin-bottom: 20px;
}

.search-filters {
  display: flex;
  flex-wrap: wrap;
  gap: 16px;
  align-items: end;
}

.search-item {
  display: flex;
  flex-direction: column;
  gap: 6px;
  min-width: 200px;
}

.search-label {
  font-size: 14px;
  font-weight: 500;
  color: #606266;
}

.search-input {
  width: 260px;
  padding: 8px 12px;
  border: 1px solid #dcdfe6;
  border-radius: 4px;
  font-size: 14px;
  transition: border-color 0.2s;
}

.search-input:focus {
  outline: none;
  border-color: #409eff;
  box-shadow: 0 0 0 2px rgba(64, 158, 255, 0.2);
}

.search-actions {
  display: flex;
  gap: 10px;
}

/* 按钮样式 */
.btn {
  padding: 8px 16px;
  border: 1px solid transparent;
  border-radius: 4px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
}

.btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.btn.primary {
  background-color: #409eff;
  color: white;
  border-color: #409eff;
}

.btn.primary:hover:not(:disabled) {
  background-color: #66b1ff;
  border-color: #66b1ff;
}

.btn.ghost {
  background-color: transparent;
  color: #606266;
  border-color: #dcdfe6;
}

.btn.ghost:hover {
  color: #409eff;
  border-color: #c6e2ff;
  background-color: #ecf5ff;
}

/* 错误提示样式 */
.error-message {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 12px 16px;
  background-color: #fef0f0;
  border: 1px solid #fbc4ab;
  border-radius: 4px;
  color: #f56c6c;
  margin-bottom: 20px;
  font-size: 14px;
}

.error-icon {
  font-size: 16px;
}

.error-close {
  margin-left: auto;
  background: none;
  border: none;
  color: #f56c6c;
  cursor: pointer;
  font-size: 18px;
  line-height: 1;
  padding: 0;
  width: 20px;
  height: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  transition: all 0.2s;
}

.error-close:hover {
  background-color: rgba(245, 108, 108, 0.1);
}

/* 加载状态样式 */
.loading-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px 20px;
  gap: 16px;
}

.loading-spinner {
  width: 48px;
  height: 48px;
  border: 4px solid #f3f3f3;
  border-top: 4px solid #409eff;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

.loading-spinner-small {
  display: inline-block;
  width: 16px;
  height: 16px;
  border: 2px solid rgba(255, 255, 255, 0.3);
  border-top: 2px solid white;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin-right: 6px;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.loading-text {
  font-size: 16px;
  color: #606266;
}

/* 无结果提示样式 */
.no-result {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px 20px;
  gap: 12px;
  text-align: center;
}

.no-result-icon {
  font-size: 48px;
  color: #c0c4cc;
}

.no-result-text {
  font-size: 18px;
  font-weight: 500;
  color: #606266;
}

.no-result-hint {
  font-size: 14px;
  color: #909399;
}

/* 个人画像内容样式 */
.profile-content {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

/* 画像章节样式 */
.profile-section {
  background-color: white;
  border: 1px solid #e4e7ed;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.05);
}

.section-header {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 16px 20px;
  background-color: #fafafa;
  border-bottom: 1px solid #e4e7ed;
  cursor: pointer;
  transition: all 0.2s;
}

.section-header:hover {
  background-color: #f5f7fa;
}

.section-icon {
  font-size: 20px;
}

.section-title {
  font-size: 16px;
  font-weight: 600;
  color: #303133;
  flex: 1;
}

.section-toggle {
  font-size: 14px;
  color: #909399;
  transition: transform 0.2s;
}

.section-content {
  padding: 20px;
}

/* 基础信息样式 */
.basic-info-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 16px;
}

.info-item {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.info-item.full-width {
  grid-column: 1 / -1;
}

.info-label {
  font-size: 14px;
  color: #909399;
}

.info-value {
  font-size: 16px;
  font-weight: 500;
  color: #303133;
}

/* 标签容器样式 */
.tags-container {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin-top: 8px;
}

.tag-item {
  display: inline-block;
  padding: 4px 12px;
  background-color: #ecf5ff;
  color: #409eff;
  border: 1px solid #d9ecff;
  border-radius: 16px;
  font-size: 13px;
  transition: all 0.2s;
}

.tag-item:hover {
  background-color: #d9ecff;
  border-color: #adc6ff;
}

/* 统计信息样式 */
.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 20px;
}

.stats-column {
  background-color: #fafafa;
  padding: 16px;
  border-radius: 8px;
  border: 1px solid #e4e7ed;
}

.column-title {
  font-size: 14px;
  font-weight: 600;
  color: #606266;
  margin-bottom: 16px;
  padding-bottom: 8px;
  border-bottom: 1px solid #e4e7ed;
}

.stats-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 8px 0;
  border-bottom: 1px solid #f0f0f0;
}

.stats-item:last-child {
  border-bottom: none;
}

.stats-label {
  font-size: 14px;
  color: #606266;
}

.stats-value {
  font-size: 16px;
  font-weight: 500;
  color: #303133;
}

/* 衍生信息样式 */
.derived-info {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
  gap: 16px;
}

.derived-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 20px;
  background-color: #fafafa;
  border: 1px solid #e4e7ed;
  border-radius: 8px;
  text-align: center;
  transition: all 0.2s;
}

.derived-item:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
}

.derived-label {
  font-size: 14px;
  color: #909399;
  margin-bottom: 8px;
}

.derived-value {
  font-size: 24px;
  font-weight: 600;
  color: #409eff;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .profile-container {
    padding: 10px;
  }
  
  .search-filters {
    flex-direction: column;
    align-items: stretch;
  }
  
  .search-item {
    min-width: auto;
  }
  
  .search-input {
    width: 100%;
  }
  
  .search-actions {
    justify-content: center;
  }
  
  .basic-info-grid {
    grid-template-columns: 1fr;
  }
  
  .stats-grid {
    grid-template-columns: 1fr;
  }
  
  .derived-info {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 480px) {
  .derived-info {
    grid-template-columns: 1fr;
  }
}
</style>
