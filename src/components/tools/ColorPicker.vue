<template>
  <div class="space-y-6">
    <!-- 颜色选择器 -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <div>
        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
          选择颜色
        </label>
        <div class="flex items-center space-x-4">
          <input
            v-model="selectedColor"
            type="color"
            class="w-20 h-20 border-2 border-gray-300 dark:border-gray-600 rounded-lg cursor-pointer"
          >
          <input
            v-model="selectedColor"
            type="text"
            placeholder="#000000"
            class="flex-1 p-3 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent dark:bg-gray-700 dark:text-gray-200"
          >
        </div>
      </div>

      <!-- 颜色预览 -->
      <div>
        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
          颜色预览
        </label>
        <div
          :style="{ backgroundColor: selectedColor }"
          class="w-full h-20 rounded-lg border-2 border-gray-300 dark:border-gray-600"
        ></div>
      </div>
    </div>

    <!-- 颜色格式 -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
      <div class="bg-gray-50 dark:bg-gray-700 rounded-lg p-4">
        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
          HEX
        </label>
        <div class="flex items-center space-x-2">
          <input
            :value="colorFormats.hex"
            readonly
            class="flex-1 p-2 bg-white dark:bg-gray-600 border border-gray-300 dark:border-gray-500 rounded text-sm"
          >
          <button
            @click="copyToClipboard(colorFormats.hex)"
            class="p-2 text-blue-500 hover:text-blue-600 transition-colors"
          >
            📋
          </button>
        </div>
      </div>

      <div class="bg-gray-50 dark:bg-gray-700 rounded-lg p-4">
        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
          RGB
        </label>
        <div class="flex items-center space-x-2">
          <input
            :value="colorFormats.rgb"
            readonly
            class="flex-1 p-2 bg-white dark:bg-gray-600 border border-gray-300 dark:border-gray-500 rounded text-sm"
          >
          <button
            @click="copyToClipboard(colorFormats.rgb)"
            class="p-2 text-blue-500 hover:text-blue-600 transition-colors"
          >
            📋
          </button>
        </div>
      </div>

      <div class="bg-gray-50 dark:bg-gray-700 rounded-lg p-4">
        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
          HSL
        </label>
        <div class="flex items-center space-x-2">
          <input
            :value="colorFormats.hsl"
            readonly
            class="flex-1 p-2 bg-white dark:bg-gray-600 border border-gray-300 dark:border-gray-500 rounded text-sm"
          >
          <button
            @click="copyToClipboard(colorFormats.hsl)"
            class="p-2 text-blue-500 hover:text-blue-600 transition-colors"
          >
            📋
          </button>
        </div>
      </div>

      <div class="bg-gray-50 dark:bg-gray-700 rounded-lg p-4">
        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
          HSV
        </label>
        <div class="flex items-center space-x-2">
          <input
            :value="colorFormats.hsv"
            readonly
            class="flex-1 p-2 bg-white dark:bg-gray-600 border border-gray-300 dark:border-gray-500 rounded text-sm"
          >
          <button
            @click="copyToClipboard(colorFormats.hsv)"
            class="p-2 text-blue-500 hover:text-blue-600 transition-colors"
          >
            📋
          </button>
        </div>
      </div>
    </div>

    <!-- 预设颜色 -->
    <div>
      <h3 class="text-lg font-semibold text-gray-800 dark:text-gray-200 mb-3">预设颜色</h3>
      <div class="grid grid-cols-8 md:grid-cols-12 gap-2">
        <button
          v-for="color in presetColors"
          :key="color"
          @click="selectedColor = color"
          :style="{ backgroundColor: color }"
          :title="color"
          class="w-full aspect-square rounded-lg border-2 border-gray-300 dark:border-gray-600 hover:border-blue-500 transition-colors cursor-pointer"
        ></button>
      </div>
    </div>

    <!-- 最近使用的颜色 -->
    <div v-if="recentColors.length > 0">
      <h3 class="text-lg font-semibold text-gray-800 dark:text-gray-200 mb-3">最近使用</h3>
      <div class="grid grid-cols-8 md:grid-cols-12 gap-2">
        <button
          v-for="color in recentColors"
          :key="color"
          @click="selectedColor = color"
          :style="{ backgroundColor: color }"
          :title="color"
          class="w-full aspect-square rounded-lg border-2 border-gray-300 dark:border-gray-600 hover:border-blue-500 transition-colors cursor-pointer"
        ></button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'

const selectedColor = ref('#3B82F6')
const recentColors = ref<string[]>([])

const presetColors = [
  '#000000', '#FFFFFF', '#FF0000', '#00FF00', '#0000FF', '#FFFF00', '#FF00FF', '#00FFFF',
  '#800000', '#008000', '#000080', '#808000', '#800080', '#008080', '#C0C0C0', '#808080',
  '#FF6B6B', '#4ECDC4', '#45B7D1', '#96CEB4', '#FFEAA7', '#DDA0DD', '#98D8C8', '#F7DC6F',
  '#BB8FCE', '#85C1E9', '#F8B739', '#52C234', '#FF6B9D', '#C44569', '#524763', '#F07167'
]

const colorFormats = computed(() => {
  const hex = selectedColor.value

  // 转换为RGB
  const r = parseInt(hex.slice(1, 3), 16)
  const g = parseInt(hex.slice(3, 5), 16)
  const b = parseInt(hex.slice(5, 7), 16)

  // RGB格式
  const rgb = `rgb(${r}, ${g}, ${b})`

  // 转换为HSL
  const rNorm = r / 255
  const gNorm = g / 255
  const bNorm = b / 255

  const max = Math.max(rNorm, gNorm, bNorm)
  const min = Math.min(rNorm, gNorm, bNorm)
  const delta = max - min

  let h = 0
  let s = 0
  const l = (max + min) / 2

  if (delta !== 0) {
    s = l > 0.5 ? delta / (2 - max - min) : delta / (max + min)

    if (max === rNorm) {
      h = ((gNorm - bNorm) / delta + (gNorm < bNorm ? 6 : 0)) / 6
    } else if (max === gNorm) {
      h = ((bNorm - rNorm) / delta + 2) / 6
    } else {
      h = ((rNorm - gNorm) / delta + 4) / 6
    }
  }

  const hsl = `hsl(${Math.round(h * 360)}, ${Math.round(s * 100)}%, ${Math.round(l * 100)}%)`

  // 转换为HSV
  const v = max
  const sHsv = max === 0 ? 0 : delta / max

  let hHsv = 0
  if (delta !== 0) {
    if (max === rNorm) {
      hHsv = ((gNorm - bNorm) / delta + (gNorm < bNorm ? 6 : 0)) / 6
    } else if (max === gNorm) {
      hHsv = ((bNorm - rNorm) / delta + 2) / 6
    } else {
      hHsv = ((rNorm - gNorm) / delta + 4) / 6
    }
  }

  const hsv = `hsv(${Math.round(hHsv * 360)}, ${Math.round(sHsv * 100)}%, ${Math.round(v * 100)}%)`

  return {
    hex: hex.toUpperCase(),
    rgb,
    hsl,
    hsv
  }
})

// 监听颜色变化，添加到最近使用
watch(selectedColor, (newColor) => {
  if (!recentColors.value.includes(newColor)) {
    recentColors.value.unshift(newColor)
    if (recentColors.value.length > 24) {
      recentColors.value = recentColors.value.slice(0, 24)
    }
  }
})

const copyToClipboard = async (text: string) => {
  try {
    await navigator.clipboard.writeText(text)
    // 这里可以添加成功提示
  } catch (err) {
    console.error('复制失败:', err)
  }
}
</script>