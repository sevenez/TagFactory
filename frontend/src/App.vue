<template>
  <div class="layout">
    <header class="topbar"><TopInfoBar /></header>
    <div class="content">
      <aside class="sidenav"><SideNav /></aside>
      <main class="main">
        <div class="container">
          <router-view />
        </div>
      </main>
    </div>
    <footer class="footer"><FooterBar /></footer>
  </div>
</template>

<script setup>
import TopInfoBar from './components/TopInfoBar.vue'
import SideNav from './components/SideNav.vue'
import FooterBar from './components/FooterBar.vue'
</script>

<style>
.layout { display: flex; flex-direction: column; height: 100vh; }
.topbar {
  height: 60px !important;
  background: var(--color-panel);
}
.content { display: flex; flex: 1; }
.sidenav { width: 160px; }
.main { flex: 1; }
.footer { height: 40px; }
</style>
