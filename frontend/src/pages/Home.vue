<template>
  <div>
    <div class="card">
      <div class="title">演示信息</div>
      <div>用户名：演示帐号</div>
      <div>邮箱：DEMO@tagfactory.com</div>
    </div>
    <div class="title" style="margin-top: 24px; margin-bottom: 16px;">主功能模块</div>
    <div class="grid-cards">
      <router-link to="/tags" class="module-card">
        <div class="icon">🔖</div>
        <div class="text">标签查询</div>
      </router-link>
      <router-link to="/approvals" class="module-card">
        <div class="icon">✅</div>
        <div class="text">标签审批</div>
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
/* 使用全局theme.css中的样式类 */
/* 只需定义此页面特有的样式调整 */
/* 由于主要样式已在theme.css中定义，此处仅保留页面特定调整 */

/* 确保卡片在容器中正确排列 */
.grid-cards {
  margin: 0;
  padding: 0;
}

/* 确保router-link正确应用module-card样式 */
router-link {
  display: block;
}
</style>
