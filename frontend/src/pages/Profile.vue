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
/* 使用全局theme.css中的样式类 */
/* 只需定义此页面特有的样式调整 */
/* 使用语义化的grid类名替代通用grid */
.grid-two-col { }
input { width: 260px; }
</style>
