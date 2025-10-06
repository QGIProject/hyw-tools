<template>
  <div class="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100">
    <!-- Hero Section -->
    <div class="hero min-h-[80vh]">
      <div class="hero-content text-center">
        <div class="max-w-2xl">
          <!-- Typing Effect -->
          <div class="mb-6">
            <h1 class="text-6xl md:text-7xl font-bold mb-4">
              <span class="bg-gradient-to-r from-blue-600 via-purple-600 to-pink-600 bg-clip-text text-transparent">
                <span class="typed-text">{{ typedText }}</span>
                <span class="cursor">|</span>
              </span>
              <span class="text-4xl md:text-5xl ml-2 text-gray-700">工具站</span>
            </h1>
          </div>
          <p class="text-xl text-base-content/80 mb-8">
            一个集成多种实用工具的在线工具箱，为您提供便捷的日常工具服务
          </p>
          <div class="space-x-4">
            <button class="btn btn-primary btn-lg">开始使用</button>
            <button class="btn btn-outline btn-lg">了解更多</button>
          </div>
        </div>
      </div>
    </div>

    <!-- Tools Section -->
    <div class="container mx-auto px-4 py-16">
      <h2 class="text-3xl font-bold text-center mb-12">热门工具</h2>
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <div class="card bg-base-100 shadow-xl hover:shadow-2xl transition-shadow">
          <div class="card-body">
            <h3 class="card-title">
              <div class="w-8 h-8 bg-blue-500 rounded-lg flex items-center justify-center text-white">🔧</div>
              工具名称
            </h3>
            <p>这是一个工具的简短描述，介绍它的功能和用途。</p>
            <div class="card-actions justify-end">
              <button class="btn btn-primary">使用工具</button>
            </div>
          </div>
        </div>

        <div class="card bg-base-100 shadow-xl hover:shadow-2xl transition-shadow">
          <div class="card-body">
            <h3 class="card-title">
              <div class="w-8 h-8 bg-green-500 rounded-lg flex items-center justify-center text-white">📝</div>
              工具名称
            </h3>
            <p>这是一个工具的简短描述，介绍它的功能和用途。</p>
            <div class="card-actions justify-end">
              <button class="btn btn-primary">使用工具</button>
            </div>
          </div>
        </div>

        <div class="card bg-base-100 shadow-xl hover:shadow-2xl transition-shadow">
          <div class="card-body">
            <h3 class="card-title">
              <div class="w-8 h-8 bg-purple-500 rounded-lg flex items-center justify-center text-white">🎨</div>
              工具名称
            </h3>
            <p>这是一个工具的简短描述，介绍它的功能和用途。</p>
            <div class="card-actions justify-end">
              <button class="btn btn-primary">使用工具</button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Features Section -->
    <div class="bg-base-200 py-16">
      <div class="container mx-auto px-4">
        <h2 class="text-3xl font-bold text-center mb-12">为什么选择我们？</h2>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
          <div class="text-center">
            <div class="w-16 h-16 bg-primary/20 rounded-full flex items-center justify-center mx-auto mb-4">
              <span class="text-2xl">⚡</span>
            </div>
            <h3 class="text-xl font-semibold mb-2">快速便捷</h3>
            <p class="text-base-content/70">无需注册，即开即用，提供流畅的使用体验</p>
          </div>
          <div class="text-center">
            <div class="w-16 h-16 bg-primary/20 rounded-full flex items-center justify-center mx-auto mb-4">
              <span class="text-2xl">🔒</span>
            </div>
            <h3 class="text-xl font-semibold mb-2">安全可靠</h3>
            <p class="text-base-content/70">所有数据处理都在本地完成，保护您的隐私安全</p>
          </div>
          <div class="text-center">
            <div class="w-16 h-16 bg-primary/20 rounded-full flex items-center justify-center mx-auto mb-4">
              <span class="text-2xl">🆓</span>
            </div>
            <h3 class="text-xl font-semibold mb-2">完全免费</h3>
            <p class="text-base-content/70">所有工具完全免费使用，没有任何隐藏费用</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'

const typedText = ref('')
const normalTexts = ['何意味']
const specialTexts = ['ohno妈咪何意味', '救命何意味', '好康何意味', '这是什么何意味']
let charIndex = 0
let textIndex = 0
let isDeleting = false
let typingSpeed = 150
let deletingSpeed = 100
let pauseTime = 2000
let timeoutId: NodeJS.Timeout | null = null
let currentText = ''

const getRandomText = () => {
  // 80%概率显示正常的"何意味"，20%概率显示特殊文字
  if (Math.random() < 0.8) {
    return normalTexts[0]
  } else {
    const randomIndex = Math.floor(Math.random() * specialTexts.length)
    return specialTexts[randomIndex]
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

onMounted(() => {
  typeEffect()
})

onUnmounted(() => {
  if (timeoutId) {
    clearTimeout(timeoutId)
  }
})
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

.typed-text {
  display: inline-block;
  min-width: 280px; /* 增加宽度以容纳更长的特殊文字 */
  text-align: left;
}
</style>