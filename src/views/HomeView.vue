<template>
  <div class="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 dark:from-gray-900 dark:to-gray-800 transition-colors duration-300 flex flex-col">
    <!-- 生日公告弹窗 -->
    <BirthdayAnnouncement
      :show="showBirthdayModal"
      @close="handleBirthdayModalClose"
    />

    <!-- Hero Section -->
    <div class="hero flex-1">
      <div class="hero-content text-center">
        <div class="max-w-2xl">
          <!-- Typing Effect -->
          <div class="mb-6">
            <!-- 优化后的标题 -->
            <h1 class="text-center font-bold mb-4">
              <div class="inline-flex flex-col sm:flex-row items-center justify-center gap-2 sm:gap-3">
                <span class="bg-gradient-to-r from-blue-700 to-blue-400 bg-clip-text text-transparent text-4xl sm:text-5xl md:text-6xl lg:text-7xl">
                  <span class="typed-text inline-block text-center">{{ typedText }}</span>
                  <span class="cursor">|</span>
                </span>
                <span class="text-3xl sm:text-4xl md:text-5xl text-gray-700 dark:text-gray-300">工具站</span>
              </div>
            </h1>
          </div>
          <p class="text-xl text-base-content/80 mb-8">
            一个集成多种实用工具的在线工具箱，为您提供便捷的日常工具服务
          </p>
          <div class="space-x-4">
            <router-link to="/tools" class="btn btn-primary btn-lg">开始使用</router-link>
            <router-link to="/about" class="btn btn-outline btn-lg">了解更多</router-link>
          </div>
        </div>
      </div>
    </div>

    <!-- 页脚 -->
    <footer class="mt-auto py-8 text-center text-base-content/60">
      <div class="container mx-auto px-4">
        <p>&copy; 2024 何意味工具站. All rights reserved.</p>
        <p class="mt-2 text-sm">🛠️ 为您提供便捷的在线工具服务</p>
      </div>
    </footer>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import BirthdayAnnouncement from '@/components/BirthdayAnnouncement.vue'

const typedText = ref('')
const showBirthdayModal = ref(false)
const normalTexts = ['何意味']
const specialTexts = ['ohno妈咪何意味', '救命何意味', '好康何意味', '这是什么何意味']
let charIndex = 0
let textIndex = 0
let isDeleting = false
let typingSpeed = 150
let deletingSpeed = 100
let pauseTime = 2000
let timeoutId: number | null = null
let currentText = ''

const getRandomText = (): string => {
  // 80%概率显示正常的"何意味"，20%概率显示特殊文字
  if (Math.random() < 0.8) {
    return normalTexts[0] || '何意味'
  } else {
    const randomIndex = Math.floor(Math.random() * specialTexts.length)
    return specialTexts[randomIndex] || '何意味'
  }
}

const typeEffect = () => {
  if (charIndex === 0 && !isDeleting) {
    // 开始新的文字时随机选择
    currentText = getRandomText()
  }

  if (isDeleting) {
    // 删除字符
    typedText.value = currentText.substring(0, charIndex - 1)
    charIndex--

    if (charIndex === 0) {
      isDeleting = false
      // 重置textIndex，因为每次都重新随机选择
      textIndex = 0
      timeoutId = setTimeout(typeEffect, 500) // 删除后短暂停顿
    } else {
      timeoutId = setTimeout(typeEffect, deletingSpeed)
    }
  } else {
    // 添加字符
    typedText.value = currentText.substring(0, charIndex + 1)
    charIndex++

    if (charIndex === currentText.length) {
      isDeleting = true
      timeoutId = setTimeout(typeEffect, pauseTime) // 完成后长时间停顿
    } else {
      timeoutId = setTimeout(typeEffect, typingSpeed)
    }
  }
}

// 检查是否在生日期间（显示到2025年10月10日0点中国标准时间）
const isBirthdayPeriod = (): boolean => {
  const now = new Date()
  const endDate = new Date('2025-12-03T00:00:00+08:00') // 2025年10月10日0点中国标准时间
  return now < endDate
}

onMounted(() => {
  typeEffect()

  // 检查是否在生日期间，如果是则显示生日弹窗
  if (isBirthdayPeriod()) {
    setTimeout(() => {
      showBirthdayModal.value = true
    }, 1000)
  }
})

onUnmounted(() => {
  if (timeoutId) {
    clearTimeout(timeoutId)
  }
})

// 处理生日弹窗关闭事件
const handleBirthdayModalClose = () => {
  showBirthdayModal.value = false
}
</script>

<style scoped>
.cursor {
  animation: blink 1s infinite;
  font-weight: 300;
}

@keyframes blink {
  0%, 50% { opacity: 1; }
  51%, 100% { opacity: 0; }
}

/* 简化的打字文字样式 */
.typed-text {
  max-width: 200px; /* 限制最大宽度 */
  text-align: center;
  transition: all 0.2s ease;
}

/* 小屏幕优化 */
@media (max-width: 640px) {
  .typed-text {
    max-width: 150px; /* 手机端减少宽度 */
  }
}
</style>
