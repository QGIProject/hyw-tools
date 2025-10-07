<script setup lang="ts">
import { onMounted } from 'vue'
import Navbar from '@/components/Navbar.vue'

// 初始化主题
onMounted(() => {
  const savedTheme = localStorage.getItem('theme')
  const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches
  const isDark = savedTheme === 'dark' || (!savedTheme && prefersDark)

  const html = document.documentElement
  if (isDark) {
    html.classList.add('dark')
    html.setAttribute('data-theme', 'dark')
  } else {
    html.classList.remove('dark')
    html.setAttribute('data-theme', 'light')
  }
})
</script>

<template>
  <div id="app" class="min-h-screen bg-white dark:bg-gray-900 transition-colors duration-300 flex flex-col">
    <Navbar />
    <main class="flex-1">
      <router-view />
    </main>
  </div>
</template>

<style scoped></style>
