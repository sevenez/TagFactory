<template>
  <div class="card">
    <div class="filters">
      <input v-model="name" placeholder="群体名称" />
      <select v-model="method">
        <option value="RULE">规则创建</option>
        <option value="BEHAVIOR">行为创建</option>
        <option value="IMPORT">外部导入</option>
      </select>
      <input v-model="rule" placeholder="规则描述" />
      <button class="btn" @click="create">创建群体</button>
    </div>
    <table class="table">
      <thead>
        <tr>
          <th>群体名称</th><th>创建方式</th><th>规则描述</th><th>用户数</th><th>状态</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="g in groups" :key="g.group_id">
          <td>{{ g.name }}</td><td>{{ g.method }}</td><td>{{ g.rule }}</td><td>{{ g.users }}</td><td>{{ g.status }}</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import client from '../api/client'
const groups = ref([])
const name = ref('')
const method = ref('RULE')
const rule = ref('')
const load = async () => { const r = await client.get('/groups'); groups.value = r.data }
const create = async () => { await client.post('/groups', null, { params: { name: name.value, method: method.value, rule: rule.value } }); load() }
onMounted(load)
</script>

<style>
.card { background: #FFFFFF; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); padding: 16px; }
.filters { display: flex; gap: 8px; margin-bottom: 12px; }
.table { width: 100%; border-collapse: collapse; }
.table th, .table td { padding: 8px; border-bottom: 1px solid #f0f0f0; }
.btn { background: #1890FF; color: #FFFFFF; border: none; padding: 6px 10px; border-radius: 4px; cursor: pointer; }
input, select { border: 1px solid #ddd; border-radius: 4px; padding: 6px 8px; }
</style>
