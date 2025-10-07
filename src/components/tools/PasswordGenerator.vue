<template>
  <div class="space-y-6">
    <!-- 密码设置 -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <div class="space-y-4">
        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
            密码长度
          </label>
          <div class="flex items-center space-x-4">
            <input
              v-model="passwordLength"
              type="range"
              min="4"
              max="64"
              class="flex-1"
            >
            <span class="w-12 text-center font-medium text-gray-800 dark:text-gray-200">
              {{ passwordLength }}
            </span>
          </div>
        </div>

        <div class="space-y-3">
          <label class="flex items-center space-x-3">
            <input
              v-model="includeUppercase"
              type="checkbox"
              class="w-4 h-4 text-blue-600 rounded focus:ring-blue-500"
            >
            <span class="text-gray-700 dark:text-gray-300">包含大写字母 (A-Z)</span>
          </label>

          <label class="flex items-center space-x-3">
            <input
              v-model="includeLowercase"
              type="checkbox"
              class="w-4 h-4 text-blue-600 rounded focus:ring-blue-500"
            >
            <span class="text-gray-700 dark:text-gray-300">包含小写字母 (a-z)</span>
          </label>

          <label class="flex items-center space-x-3">
            <input
              v-model="includeNumbers"
              type="checkbox"
              class="w-4 h-4 text-blue-600 rounded focus:ring-blue-500"
            >
            <span class="text-gray-700 dark:text-gray-300">包含数字 (0-9)</span>
          </label>

          <label class="flex items-center space-x-3">
            <input
              v-model="includeSymbols"
              type="checkbox"
              class="w-4 h-4 text-blue-600 rounded focus:ring-blue-500"
            >
            <span class="text-gray-700 dark:text-gray-300">包含特殊符号 (!@#$%^&*)</span>
          </label>
        </div>

        <button
          @click="generatePassword"
          class="w-full px-4 py-3 bg-blue-500 hover:bg-blue-600 text-white rounded-lg transition-colors font-medium"
        >
          生成密码
        </button>
      </div>

      <!-- 生成的密码 -->
      <div class="space-y-4">
        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
            生成的密码
          </label>
          <div class="relative">
            <input
              v-model="generatedPassword"
              readonly
              placeholder="点击生成密码按钮..."
              class="w-full p-3 pr-20 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-800 dark:text-gray-200 font-mono"
            >
            <div class="absolute right-2 top-1/2 transform -translate-y-1/2 flex space-x-1">
              <button
                @click="() => copyPassword()"
                :disabled="!generatedPassword"
                class="px-3 py-1 text-sm bg-blue-500 hover:bg-blue-600 disabled:bg-gray-400 text-white rounded transition-colors"
              >
                复制
              </button>
            </div>
          </div>
        </div>

        <!-- 密码强度指示器 -->
        <div v-if="generatedPassword">
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
            密码强度
          </label>
          <div class="w-full bg-gray-200 dark:bg-gray-700 rounded-full h-3">
            <div
              :class="passwordStrength.color"
              :style="{ width: passwordStrength.percentage + '%' }"
              class="h-3 rounded-full transition-all duration-300"
            ></div>
          </div>
          <p class="mt-1 text-sm font-medium" :class="passwordStrength.textColor">
            {{ passwordStrength.text }}
          </p>
        </div>

        <!-- 批量生成 -->
        <div>
          <div class="flex items-center justify-between mb-2">
            <label class="text-sm font-medium text-gray-700 dark:text-gray-300">
              批量生成
            </label>
            <input
              v-model="batchCount"
              type="number"
              min="1"
              max="20"
              class="w-16 p-1 text-center border border-gray-300 dark:border-gray-600 rounded dark:bg-gray-700 dark:text-gray-200"
            >
          </div>
          <button
            @click="generateBatch"
            class="w-full px-3 py-2 bg-green-500 hover:bg-green-600 text-white rounded-lg transition-colors"
          >
            生成 {{ batchCount }} 个密码
          </button>
        </div>
      </div>
    </div>

    <!-- 批量生成的密码列表 -->
    <div v-if="batchPasswords.length > 0" class="space-y-2">
      <h3 class="text-lg font-semibold text-gray-800 dark:text-gray-200">批量生成的密码</h3>
      <div class="max-h-64 overflow-y-auto space-y-2">
        <div
          v-for="(password, index) in batchPasswords"
          :key="index"
          class="flex items-center space-x-2 p-2 bg-gray-50 dark:bg-gray-700 rounded-lg"
        >
          <span class="flex-1 font-mono text-sm text-gray-800 dark:text-gray-200">
            {{ password }}
          </span>
          <button
            @click="() => copyPassword(password)"
            class="px-2 py-1 text-xs bg-blue-500 hover:bg-blue-600 text-white rounded transition-colors"
          >
            复制
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'

const passwordLength = ref(16)
const includeUppercase = ref(true)
const includeLowercase = ref(true)
const includeNumbers = ref(true)
const includeSymbols = ref(true)
const generatedPassword = ref('')
const batchPasswords = ref<string[]>([])
const batchCount = ref(5)

const passwordStrength = computed(() => {
  if (!generatedPassword.value) {
    return { percentage: 0, color: '', text: '', textColor: '' }
  }

  const password = generatedPassword.value
  let score = 0

  // 长度评分
  if (password.length >= 8) score += 25
  if (password.length >= 12) score += 25

  // 字符类型评分
  if (/[a-z]/.test(password)) score += 10
  if (/[A-Z]/.test(password)) score += 10
  if (/[0-9]/.test(password)) score += 10
  if (/[^a-zA-Z0-9]/.test(password)) score += 20

  if (score <= 30) {
    return { percentage: 25, color: 'bg-red-500', text: '这么弱，，，', textColor: 'text-red-500' }
  } else if (score <= 60) {
    return { percentage: 50, color: 'bg-yellow-500', text: '有点弱，，', textColor: 'text-yellow-500' }
  } else if (score <= 80) {
    return { percentage: 75, color: 'bg-blue-500', text: '有点强，，', textColor: 'text-blue-500' }
  } else {
    return { percentage: 100, color: 'bg-green-500', text: '这么强！？', textColor: 'text-green-500' }
  }
})

const generatePassword = () => {
  let charset = ''
  if (includeUppercase.value) charset += 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
  if (includeLowercase.value) charset += 'abcdefghijklmnopqrstuvwxyz'
  if (includeNumbers.value) charset += '0123456789'
  if (includeSymbols.value) charset += '!@#$%^&*()_+-=[]{}|;:,.<>?'

  if (charset === '') {
    generatedPassword.value = ''
    return
  }

  let password = ''
  for (let i = 0; i < passwordLength.value; i++) {
    password += charset.charAt(Math.floor(Math.random() * charset.length))
  }

  generatedPassword.value = password
}

const generateBatch = () => {
  batchPasswords.value = []
  for (let i = 0; i < batchCount.value; i++) {
    generatePassword()
    batchPasswords.value.push(generatedPassword.value)
  }
}

const copyPassword = async (password?: string) => {
  const textToCopy = password || generatedPassword.value
  try {
    await navigator.clipboard.writeText(textToCopy)
    // 这里可以添加成功提示
  } catch (err) {
    console.error('复制失败:', err)
  }
}
</script>