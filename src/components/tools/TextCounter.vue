<template>
  <div class="space-y-6">
    <div>
      <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
        输入文本
      </label>
      <textarea
        v-model="inputText"
        placeholder="在此输入或粘贴要统计的文本..."
        class="w-full h-32 p-3 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent dark:bg-gray-700 dark:text-gray-200 resize-none"
      ></textarea>
    </div>

    <!-- 统计结果 -->
    <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
      <div class="bg-blue-50 dark:bg-blue-900/20 rounded-lg p-4 text-center">
        <div class="text-2xl font-bold text-blue-600 dark:text-blue-400">{{ stats.characters }}</div>
        <div class="text-sm text-gray-600 dark:text-gray-400">字符数</div>
      </div>
      <div class="bg-green-50 dark:bg-green-900/20 rounded-lg p-4 text-center">
        <div class="text-2xl font-bold text-green-600 dark:text-green-400">{{ stats.charactersNoSpaces }}</div>
        <div class="text-sm text-gray-600 dark:text-gray-400">字符数(无空格)</div>
      </div>
      <div class="bg-purple-50 dark:bg-purple-900/20 rounded-lg p-4 text-center">
        <div class="text-2xl font-bold text-purple-600 dark:text-purple-400">{{ stats.words }}</div>
        <div class="text-sm text-gray-600 dark:text-gray-400">单词数</div>
      </div>
      <div class="bg-orange-50 dark:bg-orange-900/20 rounded-lg p-4 text-center">
        <div class="text-2xl font-bold text-orange-600 dark:text-orange-400">{{ stats.lines }}</div>
        <div class="text-sm text-gray-600 dark:text-gray-400">行数</div>
      </div>
    </div>

    <!-- 详细统计 -->
    <div class="border-t border-gray-200 dark:border-gray-700 pt-4">
      <h3 class="text-lg font-semibold text-gray-800 dark:text-gray-200 mb-3">详细统计</h3>
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4 text-sm">
        <div class="flex justify-between py-2 border-b border-gray-100 dark:border-gray-700">
          <span class="text-gray-600 dark:text-gray-400">中文字符数</span>
          <span class="font-medium text-gray-800 dark:text-gray-200">{{ stats.chineseChars }}</span>
        </div>
        <div class="flex justify-between py-2 border-b border-gray-100 dark:border-gray-700">
          <span class="text-gray-600 dark:text-gray-400">英文字符数</span>
          <span class="font-medium text-gray-800 dark:text-gray-200">{{ stats.englishChars }}</span>
        </div>
        <div class="flex justify-between py-2 border-b border-gray-100 dark:border-gray-700">
          <span class="text-gray-600 dark:text-gray-400">数字个数</span>
          <span class="font-medium text-gray-800 dark:text-gray-200">{{ stats.numbers }}</span>
        </div>
        <div class="flex justify-between py-2 border-b border-gray-100 dark:border-gray-700">
          <span class="text-gray-600 dark:text-gray-400">标点符号数</span>
          <span class="font-medium text-gray-800 dark:text-gray-200">{{ stats.punctuation }}</span>
        </div>
      </div>
    </div>

    <!-- 操作按钮 -->
    <div class="flex space-x-3">
      <button
        @click="copyText"
        class="px-4 py-2 bg-blue-500 hover:bg-blue-600 text-white rounded-lg transition-colors"
      >
        复制文本
      </button>
      <button
        @click="clearText"
        class="px-4 py-2 bg-gray-500 hover:bg-gray-600 text-white rounded-lg transition-colors"
      >
        清空
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue'

const inputText = ref('')

const stats = computed(() => {
  const text = inputText.value

  // 基本统计
  const characters = text.length
  const charactersNoSpaces = text.replace(/\s/g, '').length
  const words = text.trim() === '' ? 0 : text.trim().split(/\s+/).length
  const lines = text === '' ? 0 : text.split('\n').length

  // 详细统计
  const chineseChars = (text.match(/[\u4e00-\u9fa5]/g) || []).length
  const englishChars = (text.match(/[a-zA-Z]/g) || []).length
  const numbers = (text.match(/[0-9]/g) || []).length
  const punctuation = (text.match(/[.,;:!?'"(){}[\]<>]/g) || []).length

  return {
    characters,
    charactersNoSpaces,
    words,
    lines,
    chineseChars,
    englishChars,
    numbers,
    punctuation
  }
})

const copyText = async () => {
  try {
    await navigator.clipboard.writeText(inputText.value)
    // 这里可以添加成功提示
  } catch (err) {
    console.error('复制失败:', err)
  }
}

const clearText = () => {
  inputText.value = ''
}
</script>