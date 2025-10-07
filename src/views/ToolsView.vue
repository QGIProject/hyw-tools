<template>
  <div class="min-h-screen bg-gradient-to-br from-blue-50 to-gray-100 dark:from-gray-900 dark:to-gray-800 transition-colors duration-300">
    <!-- 手机端侧栏遮罩 -->
    <div
      v-if="sidebarOpen"
      @click="sidebarOpen = false"
      class="fixed inset-0 pt-20 bg-black bg-opacity-50 z-40 lg:hidden"
    ></div>

    <div class="flex pt-20 min-h-screen">
      <!-- 桌面端侧栏导航 -->
      <aside class="hidden lg:block w-64 bg-white dark:bg-gray-800 shadow-lg flex-shrink-0">
        <div class="h-full overflow-y-auto">
          <div class="p-6">
            <h2 class="text-xl font-bold text-gray-800 dark:text-gray-200 mb-6">工具分类</h2>
            <nav class="space-y-2">
              <div v-for="category in toolCategories" :key="category.id" class="mb-4">
                <h3 class="text-sm font-semibold text-gray-600 dark:text-gray-400 uppercase tracking-wider mb-2">
                  {{ category.name }}
                </h3>
                <ul class="space-y-1">
                  <li v-for="tool in category.tools" :key="tool.id">
                    <button
                      @click="selectTool(tool)"
                      :class="[
                        'w-full text-left px-3 py-2 rounded-lg text-sm transition-all duration-200',
                        selectedTool?.id === tool.id
                          ? 'bg-blue-100 dark:bg-blue-900/30 text-blue-700 dark:text-blue-300 border-l-4 border-blue-500'
                          : 'hover:bg-gray-100 dark:hover:bg-gray-700 text-gray-700 dark:text-gray-300'
                      ]"
                    >
                      <span class="flex items-center space-x-2">
                        <span class="text-lg">{{ tool.icon }}</span>
                        <span>{{ tool.name }}</span>
                      </span>
                    </button>
                  </li>
                </ul>
              </div>
            </nav>
          </div>
        </div>
      </aside>

      <!-- 手机端侧栏导航 -->
      <aside
        v-if="sidebarOpen"
        class="lg:hidden fixed top-20 left-0 bottom-0 z-50 w-64 bg-white dark:bg-gray-800 shadow-lg transform transition-transform duration-300 ease-in-out"
      >
        <div class="p-6">
          <div class="flex items-center justify-between mb-6">
            <h2 class="text-xl font-bold text-gray-800 dark:text-gray-200">工具分类</h2>
            <!-- 手机端关闭按钮 -->
            <button
              @click="sidebarOpen = false"
              class="lg:hidden p-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
            >
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
              </svg>
            </button>
          </div>

          <!-- 工具分类导航 -->
          <nav class="space-y-2">
            <div v-for="category in toolCategories" :key="category.id" class="mb-4">
              <h3 class="text-sm font-semibold text-gray-600 dark:text-gray-400 uppercase tracking-wider mb-2">
                {{ category.name }}
              </h3>
              <ul class="space-y-1">
                <li v-for="tool in category.tools" :key="tool.id">
                  <button
                    @click="selectTool(tool)"
                    :class="[
                      'w-full text-left px-3 py-2 rounded-lg text-sm transition-all duration-200',
                      selectedTool?.id === tool.id
                        ? 'bg-blue-100 dark:bg-blue-900/30 text-blue-700 dark:text-blue-300 border-l-4 border-blue-500'
                        : 'hover:bg-gray-100 dark:hover:bg-gray-700 text-gray-700 dark:text-gray-300'
                    ]"
                  >
                    <span class="flex items-center space-x-2">
                      <span class="text-lg">{{ tool.icon }}</span>
                      <span>{{ tool.name }}</span>
                    </span>
                  </button>
                </li>
              </ul>
            </div>
          </nav>
        </div>
      </aside>

      <!-- 手机端汉堡菜单按钮 -->
      <div class="lg:hidden fixed top-20 left-4 z-30">
        <button
          @click="sidebarOpen = !sidebarOpen"
          class="p-2 bg-white dark:bg-gray-800 rounded-lg shadow-lg hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
        >
          <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path v-if="!sidebarOpen" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path>
            <path v-else stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
          </svg>
        </button>
      </div>

      <!-- 主内容区域 -->
      <main class="flex-1 p-6 overflow-y-auto">
        <div v-if="selectedTool" class="max-w-4xl mx-auto">
          <!-- 工具标题 -->
          <div class="mb-8">
            <h1 class="text-3xl font-bold text-gray-800 dark:text-gray-200 mb-2">
              <span class="flex items-center space-x-3">
                <span class="text-4xl">{{ selectedTool.icon }}</span>
                <span>{{ selectedTool.name }}</span>
              </span>
            </h1>
            <p class="text-gray-600 dark:text-gray-400">{{ selectedTool.description }}</p>
          </div>

          <!-- 工具内容 -->
          <div class="bg-white dark:bg-gray-800 rounded-xl shadow-lg p-6">
            <component :is="selectedTool.component" />
          </div>
        </div>

        <!-- 默认欢迎页面 -->
        <div v-else class="max-w-4xl mx-auto text-center py-16">
          <div class="mb-8">
            <span class="text-6xl">🛠️</span>
          </div>
          <h1 class="text-3xl font-bold text-gray-800 dark:text-gray-200 mb-4">
            欢迎使用何意味工具站
          </h1>
          <p class="text-lg text-gray-600 dark:text-gray-400 mb-8">
            请从左侧选择一个工具开始使用，或在移动端从下拉菜单中选择
          </p>

          <!-- 快速访问卡片 -->
          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mt-12">
            <div
              v-for="category in toolCategories.slice(0, 3)"
              :key="category.id"
              class="bg-white dark:bg-gray-800 rounded-lg shadow-md p-6 hover:shadow-lg transition-shadow cursor-pointer"
              @click="selectTool(category.tools[0])"
            >
              <div class="text-3xl mb-4">{{ category.tools[0].icon }}</div>
              <h3 class="text-lg font-semibold text-gray-800 dark:text-gray-200 mb-2">
                {{ category.tools[0].name }}
              </h3>
              <p class="text-sm text-gray-600 dark:text-gray-400">
                {{ category.tools[0].description }}
              </p>
            </div>
          </div>
        </div>
      </main>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, markRaw } from 'vue'
import TextCounter from '@/components/tools/TextCounter.vue'
import ColorPicker from '@/components/tools/ColorPicker.vue'
import QRCodeGenerator from '@/components/tools/QRCodeGenerator.vue'
import PasswordGenerator from '@/components/tools/PasswordGenerator.vue'
import UrlEncoder from '@/components/tools/UrlEncoder.vue'
import Base64Converter from '@/components/tools/Base64Converter.vue'

interface Tool {
  id: string
  name: string
  description: string
  icon: string
  component: any
}

interface ToolCategory {
  id: string
  name: string
  tools: Tool[]
}

const selectedTool = ref<Tool | null>(null)
const selectedToolId = ref<string>('')
const sidebarOpen = ref(false)

const toolCategories: ToolCategory[] = [
  {
    id: 'text',
    name: '文本工具',
    tools: [
      {
        id: 'text-counter',
        name: '字数统计',
        description: '统计文本字符数、单词数、行数等信息',
        icon: '📝',
        component: markRaw(TextCounter)
      }
    ]
  },
  {
    id: 'design',
    name: '设计工具',
    tools: [
      {
        id: 'color-picker',
        name: '颜色选择器',
        description: '选择颜色并获取各种格式的颜色值',
        icon: '🎨',
        component: markRaw(ColorPicker)
      },
      {
        id: 'qr-code',
        name: '二维码生成',
        description: '将文本或链接转换为二维码',
        icon: '📱',
        component: markRaw(QRCodeGenerator)
      }
    ]
  },
  {
    id: 'security',
    name: '安全工具',
    tools: [
      {
        id: 'password-generator',
        name: '密码生成器',
        description: '生成安全的随机密码',
        icon: '🔐',
        component: markRaw(PasswordGenerator)
      }
    ]
  },
  {
    id: 'encoding',
    name: '编码工具',
    tools: [
      {
        id: 'url-encoder',
        name: 'URL编解码',
        description: 'URL编码和解码工具',
        icon: '🔗',
        component: markRaw(UrlEncoder)
      },
      {
        id: 'base64-converter',
        name: 'Base64编解码',
        description: 'Base64编码和解码工具',
        icon: '🔄',
        component: markRaw(Base64Converter)
      }
    ]
  }
]

const selectTool = (tool: Tool) => {
  selectedTool.value = tool
  selectedToolId.value = tool.id
  sidebarOpen.value = false // 选择工具后关闭侧栏
}

const selectToolById = (toolId: string) => {
  const tool = toolCategories
    .flatMap(category => category.tools)
    .find(t => t.id === toolId)

  if (tool) {
    selectTool(tool)
  }
}

onMounted(() => {
  // 默认选择第一个工具
  if (toolCategories.length > 0 && toolCategories[0].tools.length > 0) {
    selectTool(toolCategories[0].tools[0])
  }
})
</script>

<style scoped>
/* 自定义滚动条样式 */
aside::-webkit-scrollbar {
  width: 6px;
}

aside::-webkit-scrollbar-track {
  background: transparent;
}

aside::-webkit-scrollbar-thumb {
  background: #cbd5e0;
  border-radius: 3px;
}

aside::-webkit-scrollbar-thumb:hover {
  background: #a0aec0;
}

.dark aside::-webkit-scrollbar-thumb {
  background: #4a5568;
}

.dark aside::-webkit-scrollbar-thumb:hover {
  background: #718096;
}
</style>