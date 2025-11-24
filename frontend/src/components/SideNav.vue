<template>
  <nav class="nav">
    <div class="section primary">主功能模块</div>
    <router-link to="/tags" class="item sub">🔖 标签查询</router-link>
    <router-link to="/profile" class="item sub">👤 个体画像</router-link>
    <router-link to="/groups" class="item sub">👥 群体中心</router-link>
    <router-link to="/data" class="item sub">🗄️ 数据管理</router-link>
    <router-link to="/api" class="item sub">🔌 API 调用</router-link>
    <div class="section secondary">标签分类</div>
    <router-link to="/tags" class="item sub no-active">🏪 商家标签</router-link>
    <router-link to="/tags" class="item sub no-active">🧑 用户标签</router-link>
    <router-link to="/tags" class="item sub no-active">📦 商品标签</router-link>
    <div class="bottom">技术支持</div>
  </nav>
  
</template>

<script setup>
</script>

<style>
.nav { display: flex; flex-direction: column; padding: 16px; background: linear-gradient(180deg, #184CFF 0%, #0B2AAE 100%); height: calc(100vh - 100px); color: #fff; }
.section { margin: 10px 8px; opacity: 0.9; }
.section.primary { font-weight: 800; font-size: 15px; letter-spacing: 0.5px; }
.section.secondary { font-weight: 600; font-size: 13px; opacity: 0.85; }
.item { padding: 10px 12px; color: #e8eeff; text-decoration: none; border-radius: 6px; }
.item.sub { padding-left: 12px; }
.item.router-link-active { background: rgba(255,255,255,0.2); color: #fff; }
.item.no-active.router-link-active { background: transparent; color: #e8eeff; }
.bottom { margin-top: auto; opacity: 0.7; font-size: 12px; }
</style>
