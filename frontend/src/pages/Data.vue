<template>
  <div class="card">
    <div class="title">数据源连接状态</div>
    <table class="table">
      <thead>
        <tr><th>数据源</th><th>连接状态</th><th>最近检查</th></tr>
      </thead>
      <tbody>
        <tr v-for="s in sources" :key="s.source_id">
          <td>{{ s.name }}</td>
          <td>
            <span :class="s.connected ? 'ok' : 'bad'">{{ s.connected ? '已连接' : '未连接' }}</span>
          </td>
          <td>{{ s.last_checked_at }}</td>
        </tr>
      </tbody>
    </table>
    <div class="title" style="margin-top:12px">标签审批</div>
    <ul>
      <li v-for="t in approvals" :key="t.tag_id">{{ t.name }}（{{ t.status }}）</li>
    </ul>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import client from '../api/client'
const sources = ref([])
const approvals = ref([])
const load = async () => {
  const s = await client.get('/data/sources')
  sources.value = s.data
  const a = await client.get('/data/approvals/tags')
  approvals.value = a.data
}
onMounted(load)
</script>

<style>
/* 使用全局theme.css中的样式类 */
/* 只需定义此页面特有的样式调整 */
/* 重命名状态类以匹配全局命名规范 */
.ok { color: var(--color-success); }
.bad { color: var(--color-danger); }
</style>
