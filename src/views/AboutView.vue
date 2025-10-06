<template>
  <div class="min-h-screen bg-gradient-to-br from-gray-50 to-gray-100">
    <div class="container mx-auto px-4 py-16">
      <!-- Header Section -->
      <div class="text-center mb-16">
        <h1 class="text-4xl font-bold mb-4">关于何意味工具站</h1>
        <p class="text-xl text-base-content/80 max-w-2xl mx-auto">
          致力于为用户提供最便捷、实用的在线工具服务
        </p>
      </div>

      <!-- About Content -->
      <div class="grid grid-cols-1 lg:grid-cols-2 gap-12 mb-16">
        <div class="space-y-6">
          <h2 class="text-2xl font-semibold">我们的使命</h2>
          <p class="text-base-content/80 leading-relaxed">
            何意味工具站诞生于对效率和便捷性的追求。我们注意到，在日常工作和生活中，
            经常需要使用各种小工具，但往往需要在不同的网站之间切换，浪费了大量时间。
          </p>
          <p class="text-base-content/80 leading-relaxed">
            因此，我们决定创建一个集成了多种常用工具的一站式平台，让用户能够在一个地方
            完成所有需要的任务，提高工作效率，简化生活流程。
          </p>
        </div>

        <div class="bg-base-100 rounded-lg shadow-lg p-8">
          <h3 class="text-xl font-semibold mb-4">平台特色</h3>
          <ul class="space-y-3">
            <li class="flex items-start">
              <span class="text-success mr-3">✓</span>
              <span>界面简洁现代，操作直观易懂</span>
            </li>
            <li class="flex items-start">
              <span class="text-success mr-3">✓</span>
              <span>响应式设计，支持多设备访问</span>
            </li>
            <li class="flex items-start">
              <span class="text-success mr-3">✓</span>
              <span>持续更新，不断增加新功能</span>
            </li>
            <li class="flex items-start">
              <span class="text-success mr-3">✓</span>
              <span>注重用户隐私，数据本地处理</span>
            </li>
          </ul>
        </div>
      </div>

      <!-- Statistics Section -->
      <div class="bg-primary/10 rounded-lg p-8 mb-16">
        <h2 class="text-2xl font-semibold text-center mb-8">平台数据</h2>
        <div class="grid grid-cols-1 md:grid-cols-4 gap-6 text-center">
          <div>
            <div class="text-3xl font-bold text-primary mb-2">10+</div>
            <div class="text-base-content/70">实用工具</div>
          </div>
          <div>
            <div class="text-3xl font-bold text-primary mb-2">1000+</div>
            <div class="text-base-content/70">用户使用</div>
          </div>
          <div>
            <div class="text-3xl font-bold text-primary mb-2">24/7</div>
            <div class="text-base-content/70">在线服务</div>
          </div>
          <div>
            <div class="text-3xl font-bold text-primary mb-2">100%</div>
            <div class="text-base-content/70">免费使用</div>
          </div>
        </div>
      </div>

      <!-- Contact Section -->
      <div class="text-center">
        <h2 class="text-2xl font-semibold mb-6">联系我们</h2>
        <p class="text-base-content/80 mb-8">
          如果您有任何建议、问题或合作意向，欢迎与我们联系
        </p>
        <div class="space-x-4">
          <button class="btn btn-primary">发送邮件</button>
          <button class="btn btn-outline">GitHub</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
// 关于页面逻辑
</script>