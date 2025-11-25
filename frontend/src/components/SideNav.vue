<template>
  <nav class="nav">
    <div class="section primary">主功能模块</div>

    <!-- 标签查询菜单，包含子菜单 -->
    <div class="menu-item">
      <div 
        class="item sub parent" 
        @click="toggleSubMenu('tags')"
        :class="{ 'active': isSubMenuActive('tags') }"
      >
        🔖 标签查询
        <span class="arrow">{{ subMenus.tags ? '▼' : '▶' }}</span>
      </div>

      <!-- 子菜单 -->
      <transition name="slide">
        <div v-if="subMenus.tags" class="sub-menu">
          <!-- 全部标签 -->
          <div 
            class="item sub child"
            :class="{ 
              'active': !$route.query.type && $route.path === '/tags',
              'inactive': $route.query.type || $route.path !== '/tags'
            }"
            @click="navigateTo('/tags')"
          >
            📋 全部标签
          </div>

          <!-- 用户标签 -->
          <div 
            class="item sub child"
            :class="{ 
              'active': $route.query.type === 'user',
              'inactive': $route.query.type !== 'user'
            }"
            @click="navigateTo('/tags?type=user')"
          >
            🧑 用户标签
          </div>

          <!-- 商家标签 -->
          <div 
            class="item sub child"
            :class="{ 
              'active': $route.query.type === 'merchant',
              'inactive': $route.query.type !== 'merchant'
            }"
            @click="navigateTo('/tags?type=merchant')"
          >
            🏪 商家标签
          </div>

          <!-- 商品标签 -->
          <div 
            class="item sub child"
            :class="{ 
              'active': $route.query.type === 'product',
              'inactive': $route.query.type !== 'product'
            }"
            @click="navigateTo('/tags?type=product')"
          >
            📦 商品标签
          </div>
        </div>
      </transition>
    </div>

    <router-link to="/approvals" class="item sub">✅ 标签审批</router-link>
    <router-link to="/profile" class="item sub">👤 个体画像</router-link>
    <router-link to="/groups" class="item sub">👥 群体中心</router-link>
    <router-link to="/data" class="item sub">🗄️ 数据管理</router-link>
    <router-link to="/api" class="item sub">🔌 API 调用</router-link>

    <div class="bottom">技术支持</div>
  </nav>
</template>

<script setup>
import { ref, computed } from 'vue';
import { useRoute, useRouter } from 'vue-router';

const route = useRoute();
const router = useRouter();

// 子菜单展开状态管理
const subMenus = ref({
  tags: true // 默认展开标签查询子菜单
});

// 切换子菜单展开/折叠
const toggleSubMenu = (menuName) => {
  subMenus.value[menuName] = !subMenus.value[menuName];
};

// 导航函数
const navigateTo = (path) => {
  router.push(path);
};

// 计算是否有子菜单项处于激活状态
const isSubMenuActive = (menuName) => {
  if (menuName === 'tags') {
    const currentPath = route.path;
    const currentType = route.query.type;
    return currentPath === '/tags' && (currentType === 'merchant' || currentType === 'user' || currentType === 'product' || !currentType);
  }
  return false;
};
</script>

<style>
.nav {
  display: flex;
  flex-direction: column;
  padding: 16px;
  background: linear-gradient(180deg, #184CFF 0%, #0B2AAE 100%);
  height: calc(100vh - 60px);
  color: #fff;
  gap: 8px;
}

.section {
  margin: 16px 8px 8px 8px;
  opacity: 0.9;
  font-weight: 800;
}

.section.primary {
  font-size: 15px;
  letter-spacing: 0.5px;
}

.section.secondary {
  font-size: 13px;
  opacity: 0.85;
}

.item {
  padding: 12px 16px;
  color: #e8eeff;
  text-decoration: none;
  border-radius: 8px;
  transition: all 0.2s ease;
  margin-bottom: 4px;
}

.item.sub {
  padding-left: 16px;
}

.item.router-link-active,
.item.active {
  background: rgba(255, 255, 255, 0.2);
  color: #fff;
}

.item.no-active.router-link-active {
  background: transparent;
  color: #e8eeff;
}

.bottom {
  margin-top: auto;
  opacity: 0.7;
  font-size: 12px;
  padding: 16px 8px 8px 8px;
}

/* 父菜单样式 */
.menu-item {
  margin-bottom: 8px;
}

.item.parent {
  display: flex;
  justify-content: space-between;
  align-items: center;
  cursor: pointer;
  padding: 12px 16px;
}

.arrow {
  font-size: 10px;
  transition: transform 0.2s ease;
  margin-left: 8px;
}

/* 子菜单样式 */
.sub-menu {
  margin-left: 12px;
  margin-top: 4px;
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.item.child {
  padding: 12px 16px 12px 32px;
  font-size: 14px;
  opacity: 0.95;
  margin-bottom: 0;
  cursor: pointer;
  transition: all 0.2s ease;
}

.item.child.active {
  background: rgba(255, 255, 255, 0.2);
  color: #fff;
  font-weight: 600;
}

.item.child.inactive {
  background: transparent;
  color: #e8eeff;
  opacity: 0.85;
}

.item.child.inactive:hover {
  background: rgba(255, 255, 255, 0.1);
  opacity: 1;
}

/* 过渡动画 */
.slide-enter-active,
.slide-leave-active {
  transition: all 0.3s ease;
  overflow: hidden;
}

.slide-enter-from,
.slide-leave-to {
  max-height: 0;
  opacity: 0;
}

.slide-enter-to,
.slide-leave-from {
  max-height: 200px;
  opacity: 1;
}
</style>
