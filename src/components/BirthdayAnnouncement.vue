<template>
  <teleport to="body">
    <transition name="fade">
      <div v-if="showModal" class="fixed inset-0 z-50 flex items-center justify-center p-4">
        <!-- 背景遮罩 -->
        <div class="absolute inset-0 bg-black bg-opacity-50 backdrop-blur-sm" @click="closeModal"></div>

        <!-- 弹窗内容 -->
        <div class="relative bg-white dark:bg-gray-800 rounded-2xl shadow-2xl max-w-md w-full mx-4 transform transition-all duration-300 scale-100 animate-bounce-in">
          <!-- 彩带画布 -->
          <canvas ref="confettiCanvas" class="absolute inset-0 pointer-events-none rounded-2xl"></canvas>

          <!-- 关闭按钮 -->
          <button @click="closeModal" class="absolute top-4 right-4 z-10 w-8 h-8 bg-gray-100 dark:bg-gray-700 rounded-full flex items-center justify-center hover:bg-gray-200 dark:hover:bg-gray-600 transition-colors duration-200">
            <svg class="w-5 h-5 text-gray-600 dark:text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
            </svg>
          </button>

          <!-- 内容区域 -->
          <div class="relative z-10 p-8 text-center">
            <!-- 生日蛋糕图标 -->
            <div class="mb-6">
              <div class="text-6xl mb-4">🎂</div>
              <div class="text-4xl mb-2">🎉</div>
              <div class="text-3xl">🎊</div>
            </div>

            <!-- 生日祝福文字 -->
            <h2 class="text-2xl font-bold text-gray-800 dark:text-white mb-4">
              🎂 生日快乐！🎂
            </h2>

            <p class="text-lg text-gray-600 dark:text-gray-300 mb-6 leading-relaxed">
              祝我们最最最可爱的<br>
              <span class="text-xl font-semibold text-pink-500 dark:text-pink-400">何意味妈咪kumo</span><br>
              生日快乐！🎉
            </p>

            <!-- 装饰元素 -->
            <div class="flex justify-center space-x-2 mb-6">
              <span class="text-2xl">🌟</span>
              <span class="text-2xl">✨</span>
              <span class="text-2xl">🌟</span>
              <span class="text-2xl">✨</span>
              <span class="text-2xl">🌟</span>
            </div>

            <!-- 关闭提示 -->
            <p class="text-sm text-gray-500 dark:text-gray-400">
              {{ countdown }}秒后自动关闭
            </p>
          </div>
        </div>
      </div>
    </transition>
  </teleport>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted, watch } from 'vue'

const props = defineProps<{
  show: boolean
}>()

const emit = defineEmits<{
  close: []
}>()

const showModal = ref(props.show)
const confettiCanvas = ref<HTMLCanvasElement | null>(null)
const countdown = ref(3)
let countdownInterval: number | null = null
let animationId: number | null = null

// 彩带粒子类
class ConfettiParticle {
  x: number
  y: number
  vx: number
  vy: number
  color: string
  size: number
  angle: number
  angleVelocity: number
  life: number

  constructor(x: number, y: number) {
    this.x = x
    this.y = y
    this.vx = (Math.random() - 0.5) * 8
    this.vy = Math.random() * -15 - 5
    this.color = this.getRandomColor()
    this.size = Math.random() * 6 + 3
    this.angle = Math.random() * 360
    this.angleVelocity = (Math.random() - 0.5) * 0.2
    this.life = 1
  }

  getRandomColor(): string {
    const colors = [
      '#ff6b6b', '#4ecdc4', '#45b7d1', '#96ceb4', '#ffeaa7',
      '#dda0dd', '#98d8c8', '#f7dc6f', '#bb8fce', '#85c1e9'
    ]
    return colors[Math.floor(Math.random() * colors.length)] || '#ff6b6b'
  }

  update() {
    this.x += this.vx
    this.y += this.vy
    this.vy += 0.5 // 重力
    this.angle += this.angleVelocity
    this.life -= 0.01
  }

  draw(ctx: CanvasRenderingContext2D) {
    ctx.save()
    ctx.translate(this.x, this.y)
    ctx.rotate(this.angle)
    ctx.globalAlpha = this.life
    ctx.fillStyle = this.color
    ctx.fillRect(-this.size / 2, -this.size / 2, this.size, this.size)
    ctx.restore()
  }
}

const confettiParticles: ConfettiParticle[] = []

// 初始化彩带
const initConfetti = () => {
  if (!confettiCanvas.value) return

  const canvas = confettiCanvas.value
  const rect = canvas.getBoundingClientRect()
  canvas.width = rect.width
  canvas.height = rect.height

  // 创建彩带粒子
  for (let i = 0; i < 50; i++) {
    confettiParticles.push(new ConfettiParticle(
      Math.random() * canvas.width,
      Math.random() * canvas.height
    ))
  }
}

// 动画循环
const animate = () => {
  if (!confettiCanvas.value) return

  const canvas = confettiCanvas.value
  const ctx = canvas.getContext('2d')
  if (!ctx) return

  ctx.clearRect(0, 0, canvas.width, canvas.height)

  // 更新和绘制彩带粒子
  for (let i = confettiParticles.length - 1; i >= 0; i--) {
    const particle = confettiParticles[i]
    if (particle) {
      particle.update()
      particle.draw(ctx)

      // 移除生命值耗尽的粒子
      if (particle.life <= 0) {
        confettiParticles.splice(i, 1)
      }
    }
  }

  // 添加新的彩带粒子
  if (Math.random() < 0.1) {
    confettiParticles.push(new ConfettiParticle(
      Math.random() * canvas.width,
      -10
    ))
  }

  animationId = requestAnimationFrame(animate)
}

// 开始倒计时
const startCountdown = () => {
  countdown.value = 3
  countdownInterval = setInterval(() => {
    countdown.value--
    if (countdown.value <= 0) {
      closeModal()
    }
  }, 1000)
}

// 关闭弹窗
const closeModal = () => {
  showModal.value = false
  emit('close')

  // 清理定时器和动画
  if (countdownInterval) {
    clearInterval(countdownInterval)
    countdownInterval = null
  }

  if (animationId) {
    cancelAnimationFrame(animationId)
    animationId = null
  }

  // 清空彩带粒子
  confettiParticles.length = 0
}

// 监听props变化
const handleShowChange = (newValue: boolean) => {
  showModal.value = newValue
  if (newValue) {
    // 弹窗显示时初始化彩带和开始倒计时
    setTimeout(() => {
      initConfetti()
      animate()
      startCountdown()
    }, 100)
  }
}

// 生命周期钩子
onMounted(() => {
  handleShowChange(props.show)
})

onUnmounted(() => {
  if (countdownInterval) {
    clearInterval(countdownInterval)
  }
  if (animationId) {
    cancelAnimationFrame(animationId)
  }
})

// 监听props变化
const propsRef = ref(props)
watch(() => props.show, handleShowChange)
</script>

<style scoped>
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

@keyframes bounce-in {
  0% {
    transform: scale(0.3);
    opacity: 0;
  }
  50% {
    transform: scale(1.05);
  }
  70% {
    transform: scale(0.9);
  }
  100% {
    transform: scale(1);
    opacity: 1;
  }
}

.animate-bounce-in {
  animation: bounce-in 0.6s ease-out;
}
</style>