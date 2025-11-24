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
/* 使用全局theme.css中的样式类 */
/* 所有基础样式已在theme.css中定义 */
</style>
