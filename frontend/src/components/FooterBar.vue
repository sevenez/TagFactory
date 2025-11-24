<template>
  <div class="bar">
    <div>© 2025 标签工厂管理系统 | 版本 {{ version }} | 技术支持：support@tagfactory.com</div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import client from '../api/client'
const version = ref('')
onMounted(async () => { try { const r = await client.get('/api/version'); version.value = r.data.version } catch {} })
</script>

<style>
.bar { height: 40px; display: flex; align-items: center; justify-content: center; color: #999; font-size: 12px; }
</style>
