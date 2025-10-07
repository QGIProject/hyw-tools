<template>
  <div class="space-y-6">
    <!-- Base64编解码 -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
      <div class="space-y-4">
        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
            原始文本
          </label>
          <textarea
            v-model="originalText"
            placeholder="输入要编码的文本..."
            class="w-full h-32 p-3 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent dark:bg-gray-700 dark:text-gray-200 resize-none"
          ></textarea>
        </div>
        <button
          @click="encodeToBase64"
          :disabled="!originalText.trim()"
          class="w-full px-4 py-2 bg-blue-500 hover:bg-blue-600 disabled:bg-gray-400 text-white rounded-lg transition-colors"
        >
          编码为Base64
        </button>
      </div>

      <div class="space-y-4">
        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
            Base64编码
          </label>
          <textarea
            v-model="base64Text"
            placeholder="Base64编码内容..."
            class="w-full h-32 p-3 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent dark:bg-gray-700 dark:text-gray-200 resize-none"
          ></textarea>
        </div>
        <button
          @click="decodeFromBase64"
          :disabled="!base64Text.trim()"
          class="w-full px-4 py-2 bg-green-500 hover:bg-green-600 disabled:bg-gray-400 text-white rounded-lg transition-colors"
        >
          从Base64解码
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

    <!-- 文件上传和Base64转换 -->
    <div class="border-t border-gray-200 dark:border-gray-700 pt-6">
      <h3 class="text-lg font-semibold text-gray-800 dark:text-gray-200 mb-4">文件Base64转换</h3>
      <div class="space-y-4">
        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
            选择文件
          </label>
          <input
            type="file"
            @change="handleFileUpload"
            class="w-full p-3 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent dark:bg-gray-700 dark:text-gray-200"
          >
        </div>

        <div v-if="selectedFile">
          <div class="p-4 bg-gray-50 dark:bg-gray-700 rounded-lg">
            <div class="text-sm text-gray-600 dark:text-gray-400">
              <p><strong>文件名:</strong> {{ selectedFile.name }}</p>
              <p><strong>文件大小:</strong> {{ formatFileSize(selectedFile.size) }}</p>
              <p><strong>文件类型:</strong> {{ selectedFile.type || '未知' }}</p>
            </div>
          </div>
        </div>

        <div v-if="fileBase64">
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
            文件Base64编码
          </label>
          <textarea
            v-model="fileBase64"
            readonly
            class="w-full h-32 p-3 border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-50 dark:bg-gray-700 text-gray-800 dark:text-gray-200 resize-none font-mono text-xs"
          ></textarea>
          <div class="mt-2 flex space-x-3">
            <button
              @click="copyFileBase64"
              class="px-4 py-2 bg-blue-500 hover:bg-blue-600 text-white rounded-lg transition-colors"
            >
              复制Base64
            </button>
            <button
              @click="downloadFromBase64"
              class="px-4 py-2 bg-green-500 hover:bg-green-600 text-white rounded-lg transition-colors"
            >
              下载文件
            </button>
          </div>
        </div>
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
        @click="copyBase64"
        :disabled="!base64Text"
        class="px-4 py-2 bg-green-500 hover:bg-green-600 disabled:bg-gray-400 text-white rounded-lg transition-colors"
      >
        复制Base64
      </button>
      <button
        @click="copyDecoded"
        :disabled="!decodedText"
        class="px-4 py-2 bg-purple-500 hover:bg-purple-600 disabled:bg-gray-400 text-white rounded-lg transition-colors"
      >
        复制解码内容
      </button>
    </div>

    <!-- Base64示例 -->
    <div>
      <h3 class="text-lg font-semibold text-gray-800 dark:text-gray-200 mb-3">Base64编码示例</h3>
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div
          v-for="example in base64Examples"
          :key="example.original"
          class="p-4 bg-gray-50 dark:bg-gray-700 rounded-lg"
        >
          <div class="text-sm text-gray-600 dark:text-gray-400 mb-1">原始:</div>
          <div class="font-mono text-sm mb-2 text-gray-800 dark:text-gray-200">{{ example.original }}</div>
          <div class="text-sm text-gray-600 dark:text-gray-400 mb-1">Base64:</div>
          <div class="font-mono text-xs text-gray-800 dark:text-gray-200 break-all">{{ example.encoded }}</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'

const originalText = ref('')
const base64Text = ref('')
const decodedText = ref<string | null>(null)
const selectedFile = ref<File | null>(null)
const fileBase64 = ref('')

const base64Examples = [
  {
    original: 'Hello World',
    encoded: 'SGVsbG8gV29ybGQ='
  },
  {
    original: 'Base64编码',
    encoded: 'QmFzZTY05LqL6YCS57qB'
  },
  {
    original: '123456789',
    encoded: 'MTIzNDU2Nzg5'
  },
  {
    original: 'a+b=c',
    encoded: 'YStiPWM='
  }
]

const encodeToBase64 = () => {
  if (!originalText.value.trim()) return
  base64Text.value = btoa(unescape(encodeURIComponent(originalText.value)))
}

const decodeFromBase64 = () => {
  if (!base64Text.value.trim()) return

  try {
    decodedText.value = decodeURIComponent(escape(atob(base64Text.value)))
  } catch (error) {
    decodedText.value = '解码失败：无效的Base64编码'
  }
}

const handleFileUpload = (event: Event) => {
  const file = (event.target as HTMLInputElement).files?.[0]
  if (!file) return

  selectedFile.value = file
  const reader = new FileReader()

  reader.onload = (e) => {
    const result = e.target?.result as string
    // 移除data:image/...;base64,前缀
    const base64Data = result.split(',')[1]
    fileBase64.value = base64Data || result
  }

  reader.readAsDataURL(file)
}

const formatFileSize = (bytes: number): string => {
  if (bytes === 0) return '0 Bytes'
  const k = 1024
  const sizes = ['Bytes', 'KB', 'MB', 'GB']
  const i = Math.floor(Math.log(bytes) / Math.log(k))
  return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i]
}

const downloadFromBase64 = () => {
  if (!fileBase64.value || !selectedFile.value) return

  try {
    const byteCharacters = atob(fileBase64.value)
    const byteNumbers = new Array(byteCharacters.length)
    for (let i = 0; i < byteCharacters.length; i++) {
      byteNumbers[i] = byteCharacters.charCodeAt(i)
    }
    const byteArray = new Uint8Array(byteNumbers)
    const blob = new Blob([byteArray], { type: selectedFile.value.type || 'application/octet-stream' })

    const link = document.createElement('a')
    link.href = URL.createObjectURL(blob)
    link.download = selectedFile.value.name
    document.body.appendChild(link)
    link.click()
    document.body.removeChild(link)
    URL.revokeObjectURL(link.href)
  } catch (error) {
    console.error('下载失败:', error)
  }
}

const clearAll = () => {
  originalText.value = ''
  base64Text.value = ''
  decodedText.value = null
  selectedFile.value = null
  fileBase64.value = ''
}

const copyOriginal = async () => {
  try {
    await navigator.clipboard.writeText(originalText.value)
  } catch (err) {
    console.error('复制失败:', err)
  }
}

const copyBase64 = async () => {
  try {
    await navigator.clipboard.writeText(base64Text.value)
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

const copyFileBase64 = async () => {
  try {
    await navigator.clipboard.writeText(fileBase64.value)
  } catch (err) {
    console.error('复制失败:', err)
  }
}

// 监听Base64内容变化，自动解码
watch(base64Text, () => {
  if (base64Text.value.trim()) {
    decodeFromBase64()
  } else {
    decodedText.value = null
  }
})
</script>