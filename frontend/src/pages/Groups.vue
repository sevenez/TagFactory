<template>
  <div class="card">
    <h2>群体中心</h2>
    
    <!-- 导航菜单 -->
    <div class="navigation-menu">
      <div class="menu-item">
        <router-link to="/groups/list" class="menu-link">
          <div class="menu-icon">📋</div>
          <div class="menu-text">群体列表</div>
        </router-link>
      </div>
      <div class="menu-item">
        <router-link to="/groups/create" class="menu-link">
          <div class="menu-icon">➕</div>
          <div class="menu-text">创建群体</div>
        </router-link>
      </div>
    </div>
    
    <!-- 欢迎信息 -->
    <div class="welcome-section">
      <h3>欢迎使用群体中心</h3>
      <p>群体中心是标签工厂系统的核心模块，用于管理和创建用户群体。</p>
      <p>请从左侧菜单选择您需要的功能：</p>
      <ul>
        <li><strong>群体列表</strong>：查看和管理所有已创建的群体</li>
        <li><strong>创建群体</strong>：根据标签规则创建新的用户群体</li>
      </ul>
    </div>
  </div>
</template>

<script setup>
// 群体中心入口页面，提供导航功能
</script>

<style scoped>
.card {
  background: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
  padding: 20px;
  margin: 20px;
}

h2 {
  margin-top: 0;
  margin-bottom: 30px;
  color: #333;
  font-size: 24px;
  text-align: center;
}

/* 导航菜单样式 */
.navigation-menu {
  display: flex;
  gap: 20px;
  margin-bottom: 30px;
  justify-content: center;
  flex-wrap: wrap;
}

.menu-item {
  flex: 1;
  min-width: 200px;
  max-width: 300px;
}

.menu-link {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  padding: 20px;
  background: #f0f2f5;
  border-radius: 8px;
  text-decoration: none;
  color: #333;
  transition: all 0.3s;
  border: 2px solid transparent;
}

.menu-link:hover {
  background: #e6f7ff;
  border-color: #1890ff;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(24, 144, 255, 0.2);
}

.menu-icon {
  font-size: 24px;
}

.menu-text {
  font-size: 16px;
  font-weight: 500;
}

/* 欢迎信息样式 */
.welcome-section {
  background: #fafafa;
  border-radius: 8px;
  padding: 20px;
  border: 1px solid #e0e0e0;
  text-align: center;
}

.welcome-section h3 {
  margin-top: 0;
  margin-bottom: 15px;
  color: #555;
  font-size: 18px;
}

.welcome-section p {
  margin-bottom: 10px;
  color: #666;
  line-height: 1.6;
}

.welcome-section ul {
  text-align: left;
  margin: 20px auto;
  max-width: 500px;
  padding-left: 20px;
}

.welcome-section li {
  margin-bottom: 8px;
  color: #666;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .card {
    margin: 10px;
    padding: 15px;
  }
  
  .navigation-menu {
    flex-direction: column;
    gap: 15px;
  }
  
  .menu-item {
    min-width: auto;
    max-width: none;
  }
  
  .menu-link {
    padding: 15px;
  }
}
</style>
