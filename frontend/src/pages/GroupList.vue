<template>
  <div class="card">
    <h2>群体列表</h2>
    
    <!-- 群体列表 -->
    <div class="group-list">
      <div class="table-container">
        <table class="table">
          <thead>
            <tr>
              <th>群体名称</th>
              <th>实体类型</th>
              <th>创建方式</th>
              <th>标签数量</th>
              <th>实体数量</th>
              <th>状态</th>
              <th>创建时间</th>
              <th>操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="group in groups" :key="group.group_id">
              <td>{{ group.name }}</td>
              <td>{{ group.entity_type || 'N/A' }}</td>
              <td>{{ group.method }}</td>
              <td>{{ group.tag_count || 0 }}</td>
              <td>{{ group.users }}</td>
              <td>
                <span class="status-badge" :class="group.status.toLowerCase()">
                  {{ group.status }}
                </span>
              </td>
              <td>{{ formatDate(group.created_at) }}</td>
              <td>
                <button class="btn small" @click="viewGroupDetails(group)">查看详情</button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import client from '../api/client'

// 群体列表数据
const groups = ref([])

// 加载群体列表
const loadGroups = async () => {
  try {
    const response = await client.get('/groups')
    groups.value = response.data.data || []
  } catch (error) {
    console.error('加载群体列表失败:', error)
  }
}

// 查看群体详情
const viewGroupDetails = (group) => {
  console.log('查看群体详情:', group)
  // 这里可以跳转到群体详情页面或显示详情弹窗
}

// 格式化日期
const formatDate = (dateString) => {
  if (!dateString) return ''
  const date = new Date(dateString)
  return date.toLocaleString()
}

// 初始化数据
onMounted(() => {
  loadGroups()
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

/* 群体列表样式 */
.group-list {
  margin-top: 30px;
}

.table-container {
  overflow-x: auto;
}

.table {
  width: 100%;
  border-collapse: collapse;
  background: #fff;
}

.table th,
.table td {
  padding: 12px;
  text-align: left;
  border-bottom: 1px solid #e8e8e8;
}

.table th {
  background: #fafafa;
  font-weight: 500;
  color: #333;
  white-space: nowrap;
}

.table tr:hover {
  background: #f5f5f5;
}

/* 状态标签样式 */
.status-badge {
  padding: 2px 8px;
  border-radius: 10px;
  font-size: 12px;
  font-weight: 500;
}

.status-badge.enabled {
  background: #f6ffed;
  color: #52c41a;
  border: 1px solid #b7eb8f;
}

.status-badge.disabled {
  background: #fff2f0;
  color: #ff4d4f;
  border: 1px solid #ffccc7;
}

.status-badge.running {
  background: #e6f7ff;
  color: #1890ff;
  border: 1px solid #91d5ff;
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

.btn.small {
  padding: 4px 8px;
  font-size: 12px;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .card {
    margin: 10px;
    padding: 15px;
  }
  
  .table {
    font-size: 14px;
  }
  
  .table th,
  .table td {
    padding: 8px;
  }
}
</style>