<template>
  <div>
    <div class="card">
      <div class="title">演示信息</div>
      <div>用户名：演示帐号</div>
      <div>邮箱：DEMO@tagfactory.com</div>
    </div>
    <div class="title" style="margin-top: 24px; margin-bottom: 16px;">主功能模块</div>
    <div class="grid">
      <router-link to="/tags" class="module-card">
        <div class="icon">🔖</div>
        <div class="text">标签查询</div>
      </router-link>
      <router-link to="/profile" class="module-card">
        <div class="icon">👤</div>
        <div class="text">个体画像</div>
      </router-link>
      <router-link to="/groups" class="module-card">
        <div class="icon">👥</div>
        <div class="text">群体中心</div>
      </router-link>
      <router-link to="/data" class="module-card">
        <div class="icon">🗄️</div>
        <div class="text">数据管理</div>
      </router-link>
      <router-link to="/api" class="module-card">
        <div class="icon">🔌</div>
        <div class="text">API 模块</div>
      </router-link>
    </div>
  </div>
</template>

<script setup>
</script>

<style>
.card { background: #FFFFFF; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); padding: 16px; margin-bottom: 16px; }
.title { font-weight: 600; margin-bottom: 8px; }
.grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; }

/* 主功能模块卡片样式 */
.module-card {
  background: var(--color-panel);
  border-radius: var(--radius);
  box-shadow: var(--shadow);
  padding: 24px;
  text-align: center;
  text-decoration: none;
  color: var(--color-text);
  transition: all 0.3s ease;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-height: 120px;
  border: 2px solid transparent;
}

.module-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 12px 28px rgba(0,0,0,0.12);
  border-color: var(--color-primary);
}

.module-card .icon {
  font-size: 36px;
  margin-bottom: 12px;
}

.module-card .text {
  font-size: 16px;
  font-weight: 600;
  color: var(--color-text);
}
</style>
