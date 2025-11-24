<template>
  <div class="card">
    <div class="title">API 文档</div>
    <div class="box">
      <a href="http://127.0.0.1:8000/docs" target="_blank">打开后端 Swagger 文档</a>
    </div>
    <div class="title" style="margin-top:12px">调用统计</div>
    <table class="table">
      <thead><tr><th>方法</th><th>路径</th><th>次数</th></tr></thead>
      <tbody>
        <tr v-for="s in stats" :key="s.method + s.path"><td>{{ s.method }}</td><td>{{ s.path }}</td><td>{{ s.count }}</td></tr>
      </tbody>
    </table>
    <div class="title" style="margin-top:12px">API 密钥</div>
    <div class="row">
      <input v-model="name" placeholder="密钥名称" />
      <button class="btn" @click="createKey">生成密钥</button>
    </div>
    <ul>
      <li v-for="k in keys" :key="k.key_id">{{ k.name }}：{{ k.token }}</li>
    </ul>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import client from '../api/client'
const stats = ref([])
const keys = ref([])
const name = ref('')
const load = async () => {
  const s = await client.get('/api/stats')
  stats.value = s.data
  const k = await client.get('/api/keys')
  keys.value = k.data
}
const createKey = async () => {
  await client.post('/api/keys', null, { params: { name: name.value } })
  load()
}
onMounted(load)
</script>

<style>
.card { background: #FFFFFF; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); padding: 16px; }
.title { font-weight: 600; margin-bottom: 8px; }
.box { padding: 8px; background: #FFFFFF; border: 1px solid #f0f0f0; border-radius: 8px; }
.table { width: 100%; border-collapse: collapse; }
.table th, .table td { padding: 8px; border-bottom: 1px solid #f0f0f0; }
.btn { background: #1890FF; color: #FFFFFF; border: none; padding: 6px 10px; border-radius: 4px; cursor: pointer; }
.row { display: flex; gap: 8px; margin: 8px 0; }
input { border: 1px solid #ddd; border-radius: 4px; padding: 6px 8px; }
</style>
