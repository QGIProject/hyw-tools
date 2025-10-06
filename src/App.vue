<script setup lang="ts">
import Navbar from '@/components/Navbar.vue'
</script>

<template>
  <div id="app" class="min-h-screen">
    <Navbar />
    <main class="pt-20">
      <router-view />
    </main>
  </div>
</template>

<style scoped></style>
