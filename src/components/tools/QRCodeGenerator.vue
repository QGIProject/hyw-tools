<template>
  <div class="space-y-6">
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
      <!-- 输入区域 -->
      <div class="space-y-4">
        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
            输入内容
          </label>
          <textarea
            v-model="inputText"
            placeholder="输入要生成二维码的文本或链接..."
            class="w-full h-32 p-3 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent dark:bg-gray-700 dark:text-gray-200 resize-none"
          ></textarea>
        </div>

        <!-- 二维码设置 -->
        <div class="grid grid-cols-2 gap-4">
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
              大小
            </label>
            <select
              v-model="qrSize"
              class="w-full p-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent dark:bg-gray-700 dark:text-gray-200"
            >
              <option :value="200">小 (200x200)</option>
              <option :value="300">中 (300x300)</option>
              <option :value="400">大 (400x400)</option>
            </select>
          </div>

          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
              前景色
            </label>
            <input
              v-model="foregroundColor"
              type="color"
              class="w-full h-10 border border-gray-300 dark:border-gray-600 rounded-lg cursor-pointer"
            >
          </div>
        </div>

        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
            背景色
          </label>
          <input
            v-model="backgroundColor"
            type="color"
            class="w-full h-10 border border-gray-300 dark:border-gray-600 rounded-lg cursor-pointer"
          >
        </div>

        <!-- 操作按钮 -->
        <div class="flex space-x-3">
          <button
            @click="generateQR"
            :disabled="!inputText.trim()"
            class="px-4 py-2 bg-blue-500 hover:bg-blue-600 disabled:bg-gray-400 text-white rounded-lg transition-colors"
          >
            生成二维码
          </button>
          <button
            @click="clearAll"
            class="px-4 py-2 bg-gray-500 hover:bg-gray-600 text-white rounded-lg transition-colors"
          >
            清空
          </button>
        </div>
      </div>

      <!-- 二维码显示区域 -->
      <div class="space-y-4">
        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
            二维码预览
          </label>
          <div class="flex justify-center items-center p-8 bg-white dark:bg-gray-700 rounded-lg border-2 border-dashed border-gray-300 dark:border-gray-600">
            <div v-if="qrCodeUrl" class="text-center">
              <img :src="qrCodeUrl" alt="QR Code" class="mx-auto rounded-lg shadow-lg">
              <p class="mt-2 text-sm text-gray-600 dark:text-gray-400">
                {{ qrSize }}x{{ qrSize }} 像素
              </p>
            </div>
            <div v-else class="text-center">
              <div class="text-6xl mb-4">📱</div>
              <p class="text-gray-500 dark:text-gray-400">输入内容后点击生成二维码</p>
            </div>
          </div>
        </div>

        <!-- 下载按钮 -->
        <div v-if="qrCodeUrl" class="text-center">
          <button
            @click="downloadQR"
            class="px-4 py-2 bg-green-500 hover:bg-green-600 text-white rounded-lg transition-colors"
          >
            下载二维码
          </button>
        </div>
      </div>
    </div>

    <!-- 常用链接 -->
    <div>
      <h3 class="text-lg font-semibold text-gray-800 dark:text-gray-200 mb-3">快速链接</h3>
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-3">
        <button
          v-for="link in quickLinks"
          :key="link.name"
          @click="useQuickLink(link.url)"
          class="p-3 bg-gray-50 dark:bg-gray-700 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-600 transition-colors text-left"
        >
          <div class="font-medium text-gray-800 dark:text-gray-200">{{ link.name }}</div>
          <div class="text-sm text-gray-600 dark:text-gray-400 truncate">{{ link.url }}</div>
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const inputText = ref('')
const qrSize = ref(300)
const foregroundColor = ref('#000000')
const backgroundColor = ref('#FFFFFF')
const qrCodeUrl = ref('')

const quickLinks = [
  { name: 'GitHub', url: 'https://github.com' },
  { name: 'Google', url: 'https://google.com' },
  { name: '百度', url: 'https://baidu.com' },
  { name: '微信', url: 'https://weixin.qq.com' },
  { name: '微博', url: 'https://weibo.com' },
  { name: '知乎', url: 'https://zhihu.com' }
]

const generateQR = () => {
  if (!inputText.value.trim()) return

  const qrApiUrl = `https://api.qrserver.com/v1/create-qr-code/?size=${qrSize.value}x${qrSize.value}&data=${encodeURIComponent(inputText.value)}&color=${foregroundColor.value.slice(1)}&bgcolor=${backgroundColor.value.slice(1)}`

  qrCodeUrl.value = qrApiUrl
}

const clearAll = () => {
  inputText.value = ''
  qrCodeUrl.value = ''
}

const useQuickLink = (url: string) => {
  inputText.value = url
  generateQR()
}

const downloadQR = () => {
  if (!qrCodeUrl.value) return

  const link = document.createElement('a')
  link.href = qrCodeUrl.value
  link.download = `qrcode-${Date.now()}.png`
  document.body.appendChild(link)
  link.click()
  document.body.removeChild(link)
}
</script>