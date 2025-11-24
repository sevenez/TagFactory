<template>
  <div class="card">
    <div class="filters">
      <input v-model="query" placeholder="输入用户ID或手机号" />
      <button class="btn" @click="search">搜索</button>
    </div>
    <div v-if="user">
      <div class="grid">
        <div class="box">
          <div>用户ID：{{ user.user_id }}</div>
          <div>手机号：{{ user.phone }}</div>
          <div>注册时间：{{ user.registered_at }}</div>
          <div>最近活跃时间：{{ user.last_active_at }}</div>
        </div>
        <div class="box">
          <div class="title">基础标签</div>
          <div v-for="(v,k) in user.basic_tags" :key="k" class="tag">{{ k }}：{{ v }}</div>
        </div>
        <div class="box">
          <div class="title">行为标签</div>
          <div v-for="(v,k) in user.behavior_tags" :key="k" class="tag">{{ k }}：{{ v }}</div>
        </div>
        <div class="box">
          <div class="title">统计标签</div>
          <div v-for="(v,k) in user.stats_tags" :key="k" class="tag">{{ k }}：{{ v }}</div>
        </div>
        <div class="box">
          <div class="title">衍生标签</div>
          <div v-for="(v,k) in user.derived_tags" :key="k" class="tag">{{ k }}：{{ v }}</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import client from '../api/client'
const query = ref('')
const user = ref(null)
const search = async () => {
  const isPhone = /^\d{3}/.test(query.value)
  const params = isPhone ? { phone: query.value } : { user_id: query.value }
  const r = await client.get('/users/lookup', { params })
  user.value = r.data
}
</script>

<style>
.card { background: #FFFFFF; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); padding: 16px; }
.filters { display: flex; gap: 8px; margin-bottom: 12px; }
.grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 12px; }
.box { background: #FFFFFF; border: 1px solid #f0f0f0; border-radius: 8px; padding: 12px; }
.title { font-weight: 600; margin-bottom: 8px; }
.tag { display: inline-block; background: #e6f4ff; color: #1890FF; padding: 4px 8px; border-radius: 4px; margin: 4px; }
.btn { background: #1890FF; color: #FFFFFF; border: none; padding: 6px 10px; border-radius: 4px; cursor: pointer; }
input { border: 1px solid #ddd; border-radius: 4px; padding: 6px 8px; width: 260px; }
</style>
