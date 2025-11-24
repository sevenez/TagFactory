<template>
  <div class="bar">
    <div class="left">
      <router-link to="/" class="logo-link">
        <div class="logo">标签工厂管理系统</div>
      </router-link>
      <span class="pill">{{ version }}</span>
    </div>
    <div class="center">
      <input class="input search" placeholder="搜索标签或用户" />
    </div>
    <div class="right">
      <div class="icon">🔔</div>
      <div class="user">
        <div class="avatar"></div>
        <div class="info">
          <div class="name">管理员</div>
          <div class="email">admin@tagfactory.com</div>
        </div>
      </div>
    </div>
  </div>
  
</template>

<script setup>
import { ref, onMounted } from 'vue'
import client from '../api/client'
const version = ref('')
onMounted(async () => { try { const r = await client.get('/api/version'); version.value = r.data.version } catch {} })
</script>

<style>
.bar { height: 60px !important; display: flex; align-items: center; justify-content: space-between; padding: 0 20px; background: var(--color-panel); box-shadow: var(--shadow); }
.left { display: flex; align-items: center; gap: 12px; }
.logo { font-weight: 700; color: var(--color-primary); font-size: 28px; }
.logo-link { text-decoration: none; cursor: pointer; }
.center { flex: 1; display: flex; justify-content: center; }
.search { width: 480px; }
.right { display: flex; align-items: center; gap: 16px; }
.user { display: flex; align-items: center; gap: 8px; }
.avatar { width: 40px; height: 40px; border-radius: 50%; background: #999999; }
.info { display: flex; flex-direction: column; }
.name { font-size: 14px; }
.email { font-size: 12px; color: #666666; }
.icon { font-size: 16px; }
</style>
