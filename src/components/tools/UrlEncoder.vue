<template>
  <div class="space-y-6">
    <!-- URL编解码 -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
      <div class="space-y-4">
        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
            原始URL/文本
          </label>
          <textarea
            v-model="originalText"
            placeholder="输入要编码的URL或文本..."
            class="w-full h-32 p-3 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent dark:bg-gray-700 dark:text-gray-200 resize-none"
          ></textarea>
        </div>
        <button
          @click="encode"
          :disabled="!originalText.trim()"
          class="w-full px-4 py-2 bg-blue-500 hover:bg-blue-600 disabled:bg-gray-400 text-white rounded-lg transition-colors"
        >
          URL编码
        </button>
      </div>

      <div class="space-y-4">
        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
            编码结果
          </label>
          <textarea
            v-model="encodedText"
            placeholder="编码后的内容将显示在这里..."
            class="w-full h-32 p-3 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent dark:bg-gray-700 dark:text-gray-200 resize-none"
          ></textarea>
        </div>
        <button
          @click="decode"
          :disabled="!encodedText.trim()"
          class="w-full px-4 py-2 bg-green-500 hover:bg-green-600 disabled:bg-gray-400 text-white rounded-lg transition-colors"
        >
          URL解码
        </button>
      </div>
    </div>

    <!-- 解码后的结果 -->
    <div v-if="decodedText !== null" class="space-y-4">
      <div>
        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
          解码结果
        </label>
        <textarea
          v-model="decodedText"
          readonly
          class="w-full h-24 p-3 border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-50 dark:bg-gray-700 text-gray-800 dark:text-gray-200 resize-none"
        ></textarea>
      </div>
    </div>

    <!-- 操作按钮 -->
    <div class="flex flex-wrap gap-3">
      <button
        @click="clearAll"
        class="px-4 py-2 bg-gray-500 hover:bg-gray-600 text-white rounded-lg transition-colors"
      >
        清空全部
      </button>
      <button
        @click="copyOriginal"
        :disabled="!originalText"
        class="px-4 py-2 bg-blue-500 hover:bg-blue-600 disabled:bg-gray-400 text-white rounded-lg transition-colors"
      >
        复制原始内容
      </button>
      <button
        @click="copyEncoded"
        :disabled="!encodedText"
        class="px-4 py-2 bg-green-500 hover:bg-green-600 disabled:bg-gray-400 text-white rounded-lg transition-colors"
      >
        复制编码内容
      </button>
      <button
        @click="copyDecoded"
        :disabled="!decodedText"
        class="px-4 py-2 bg-purple-500 hover:bg-purple-600 disabled:bg-gray-400 text-white rounded-lg transition-colors"
      >
        复制解码内容
      </button>
    </div>

    <!-- 常见URL编码示例 -->
    <div>
      <h3 class="text-lg font-semibold text-gray-800 dark:text-gray-200 mb-3">常见编码示例</h3>
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div
          v-for="example in encodingExamples"
          :key="example.original"
          class="p-4 bg-gray-50 dark:bg-gray-700 rounded-lg"
        >
          <div class="text-sm text-gray-600 dark:text-gray-400 mb-1">原始:</div>
          <div class="font-mono text-sm mb-2 text-gray-800 dark:text-gray-200">{{ example.original }}</div>
          <div class="text-sm text-gray-600 dark:text-gray-400 mb-1">编码:</div>
          <div class="font-mono text-xs text-gray-800 dark:text-gray-200 break-all">{{ example.encoded }}</div>
        </div>
      </div>
    </div>

    <!-- 快速测试URL -->
    <div>
      <h3 class="text-lg font-semibold text-gray-800 dark:text-gray-200 mb-3">快速测试</h3>
      <div class="grid grid-cols-1 md:grid-cols-3 gap-3">
        <button
          v-for="testUrl in testUrls"
          :key="testUrl.name"
          @click="testUrl.text = testUrl.url"
          class="p-3 bg-gray-50 dark:bg-gray-700 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-600 transition-colors text-left"
        >
          <div class="font-medium text-gray-800 dark:text-gray-200">{{ testUrl.name }}</div>
          <div class="text-sm text-gray-600 dark:text-gray-400 truncate">{{ testUrl.url }}</div>
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'

const originalText = ref('')
const encodedText = ref('')
const decodedText = ref<string | null>(null)

const encodingExamples = [
  {
    original: ' ',
    encoded: '%20'
  },
  {
    original: 'https://example.com/search?q=hello world',
    encoded: 'https%3A//example.com/search%3Fq%3Dhello%20world'
  },
  {
    original: 'user@example.com',
    encoded: 'user%40example.com'
  },
  {
    original: '中文测试',
    encoded: '%E4%B8%AD%E6%96%87%E6%B5%8B%E8%AF%95'
  },
  {
    original: 'a+b=c&d=e',
    encoded: 'a%2Bb%3Dc%26d%3De'
  },
  {
    original: 'path/to/file.html',
    encoded: 'path%2Fto%2Ffile.html'
  }
]

const testUrls = [
  { name: 'Google搜索', url: 'https://www.google.com/search?q=hello world' },
  { name: '邮箱地址', url: 'user@example.com' },
  { name: '中文字符', url: '这是一个测试' }
]

const encode = () => {
  if (!originalText.value.trim()) return
  encodedText.value = encodeURIComponent(originalText.value)
}

const decode = () => {
  if (!encodedText.value.trim()) return

  try {
    decodedText.value = decodeURIComponent(encodedText.value)
  } catch (error) {
    decodedText.value = '解码失败：无效的URL编码'
  }
}

const clearAll = () => {
  originalText.value = ''
  encodedText.value = ''
  decodedText.value = null
}

const copyOriginal = async () => {
  try {
    await navigator.clipboard.writeText(originalText.value)
  } catch (err) {
    console.error('复制失败:', err)
  }
}

const copyEncoded = async () => {
  try {
    await navigator.clipboard.writeText(encodedText.value)
  } catch (err) {
    console.error('复制失败:', err)
  }
}

const copyDecoded = async () => {
  if (!decodedText.value) return
  try {
    await navigator.clipboard.writeText(decodedText.value)
  } catch (err) {
    console.error('复制失败:', err)
  }
}

// 监听编码内容变化，自动解码
watch(encodedText, () => {
  if (encodedText.value.trim()) {
    decode()
  } else {
    decodedText.value = null
  }
})
</script>