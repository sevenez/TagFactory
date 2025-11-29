<template>
  <div>
    <div class="card">
      <div class="title">演示信息</div>
      <div>用户名：演示帐号</div>
      <div>邮箱：DEMO@tagfactory.com</div>
    </div>
    
    <!-- 数据库连接状态卡片 -->
    <div class="card" style="margin-top: 16px;">
      <div class="title">数据库连接状态</div>
      <div class="db-status">
        <div class="status-item">
          <span class="label">连接状态：</span>
          <span class="status-value" :class="dbStatus.connected ? 'connected' : 'disconnected'">
            {{ dbStatus.connected ? '已连接' : '未连接' }}
          </span>
        </div>
        <div class="status-item">
          <span class="label">活跃连接数：</span>
          <span class="status-value">{{ dbStatus.active_connections }}</span>
        </div>
        <div class="status-item">
          <span class="label">连接池大小：</span>
          <span class="status-value">{{ dbStatus.pool_size }}</span>
        </div>
        <div class="status-item">
          <span class="label">最后检查时间：</span>
          <span class="status-value">{{ lastCheckedTime }}</span>
        </div>
      </div>
      <div class="refresh-btn" @click="checkDbConnection">
        <span class="icon">🔄</span>
        <span>刷新状态</span>
      </div>
    </div>
    
    <div class="title" style="margin-top: 24px; margin-bottom: 16px;">主功能模块</div>
    <div class="grid-cards">
      <router-link to="/tags" class="module-card">
        <div class="icon">🔖</div>
        <div class="text">标签查询</div>
      </router-link>
      <router-link to="/approvals" class="module-card">
        <div class="icon">✅</div>
        <div class="text">标签审批</div>
      </router-link>
      <router-link to="/profile" class="module-card">
        <div class="icon">👤</div>
        <div class="text">个体画像</div>
      </router-link>
      <router-link to="/groups" class="module-card">
        <div class="icon">👥</div>
        <div class="text">群体中心</div>
      </router-link>
      <router-link to="/data" class="module-card">
        <div class="icon">🗄️</div>
        <div class="text">数据管理</div>
      </router-link>
      <router-link to="/api" class="module-card">
        <div class="icon">🔌</div>
        <div class="text">API 模块</div>
      </router-link>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import client from '../api/client.js'

// 数据库连接状态
const dbStatus = ref({
  connected: false,
  active_connections: 0,
  pool_size: 0,
  error: null
})

// 最后检查时间
const lastCheckedTime = ref('')

// 定时器ID
let checkInterval = null

// 检查数据库连接状态
const checkDbConnection = async () => {
  try {
    const response = await client.get('/data/connection/status')
    dbStatus.value = response.data.status
    
    // 更新最后检查时间
    const now = new Date()
    lastCheckedTime.value = now.toLocaleString('zh-CN')
  } catch (error) {
    console.error('获取数据库连接状态失败:', error)
    dbStatus.value = {
      connected: false,
      active_connections: 0,
      pool_size: 0,
      error: error.message
    }
    
    // 更新最后检查时间
    const now = new Date()
    lastCheckedTime.value = now.toLocaleString('zh-CN')
  }
}

// 组件挂载时执行
onMounted(() => {
  // 立即检查一次
  checkDbConnection()
  
  // 设置定期检查，每30秒检查一次
  checkInterval = setInterval(checkDbConnection, 30000)
})

// 组件卸载时清理
onUnmounted(() => {
  if (checkInterval) {
    clearInterval(checkInterval)
  }
})
</script>

<style>
/* 使用全局theme.css中的样式类 */
/* 只需定义此页面特有的样式调整 */

/* 确保卡片在容器中正确排列 */
.grid-cards {
  margin: 0;
  padding: 0;
}

/* 确保router-link正确应用module-card样式 */
router-link {
  display: block;
}

/* 数据库状态样式 */
.db-status {
  margin: 12px 0;
}

.status-item {
  margin: 8px 0;
  display: flex;
  align-items: center;
}

.label {
  font-weight: 500;
  margin-right: 8px;
  width: 120px;
}

.status-value {
  font-weight: 600;
}

.status-value.connected {
  color: #67C23A;
}

.status-value.disconnected {
  color: #F56C6C;
}

.refresh-btn {
  margin-top: 12px;
  padding: 8px 16px;
  background-color: #409EFF;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  display: inline-flex;
  align-items: center;
  gap: 4px;
  font-size: 14px;
  transition: background-color 0.3s;
}

.refresh-btn:hover {
  background-color: #66B1FF;
}

.refresh-btn .icon {
  font-size: 16px;
}
</style>
