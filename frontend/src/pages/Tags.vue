<template>
  <div>
    <div class="toolbar">
      <div class="title">🔖 标签查询</div>
      <div class="actions">
        <button class="btn">新建标签</button>
        <button class="btn secondary">导出数据</button>
      </div>
    </div>
    <div class="card">
      <div class="filters">
        <select v-model="type" class="select">
          <option value="">全部类型</option>
          <option value="USER">用户标签</option>
          <option value="MERCHANT">商家标签</option>
          <option value="PRODUCT">商品标签</option>
        </select>
        <select v-model="status" class="select">
          <option value="">全部状态</option>
          <option value="ENABLED">已启用</option>
          <option value="PENDING">待审核</option>
          <option value="DISABLED">已停用</option>
        </select>
        <input v-model="created" class="input" placeholder="yyyy/mm/日" />
        <button class="btn" @click="fetchTags">查询</button>
        <button class="btn ghost" @click="reset">重置</button>
      </div>
      <table class="table">
        <thead>
          <tr>
            <th>标签名称</th>
            <th>标签ID</th>
            <th>类型</th>
            <th>覆盖用户数</th>
            <th>状态</th>
            <th>创建时间</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="t in tags" :key="t.tag_id">
            <td class="name">{{ t.name }}</td>
            <td>{{ t.tag_id }}</td>
            <td>
              <span class="badge info" v-if="t.type==='USER'">用户标签</span>
              <span class="badge info" v-else-if="t.type==='MERCHANT'">商家标签</span>
              <span class="badge info" v-else>商品标签</span>
            </td>
            <td>{{ formatNumber(t.cover_users) }}</td>
            <td>
              <span class="badge success" v-if="t.status==='ENABLED'">已启用</span>
              <span class="badge warning" v-else-if="t.status==='PENDING'">待审核</span>
              <span class="badge danger" v-else>已停用</span>
            </td>
            <td>{{ formatDate(t.created_at) }}</td>
            <td class="ops">
              <a class="link">编辑</a>
              <a class="link" v-if="t.status!=='ENABLED'" @click="enable(t.tag_id)">启用</a>
              <a class="link" v-if="t.status!=='DISABLED'" @click="disable(t.tag_id)">停用</a>
              <a class="link danger" v-if="t.status==='PENDING'" @click="remove(t.tag_id)">删除</a>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import client from '../api/client'
const type = ref('')
const status = ref('')
const created = ref('')
const tags = ref([])
const fetchTags = async () => {
  const params = {}
  if (type.value) params.type = type.value
  if (status.value) params.status = status.value
  if (created.value) params.created_start = created.value
  const r = await client.get('/tags', { params })
  tags.value = r.data
}
const reset = () => { type.value = ''; status.value = ''; created.value = ''; fetchTags() }
const enable = async (id) => { await client.put(`/tags/${id}/enable`); fetchTags() }
const disable = async (id) => { await client.put(`/tags/${id}/disable`); fetchTags() }
const remove = async (id) => { await client.delete(`/tags/${id}`); fetchTags() }
onMounted(fetchTags)
const formatDate = (s) => s ? s.substring(0, 10) : ''
const formatNumber = (n) => Intl.NumberFormat().format(n)
</script>

<style>
/* 使用全局theme.css中的样式类 */
/* 只需定义此页面特有的样式调整 */
.title { font-weight: 700; }
.filters { gap: 10px; }
</style>
