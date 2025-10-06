# GitHub Pages 部署问题排查

## 白屏问题解决方案

### ✅ 已应用的修复：

1. **切换到Hash路由模式**
   - 从 `createWebHistory` 改为 `createWebHashHistory`
   - URL会变成 `/#/about` 而不是 `/about`
   - 这是GitHub Pages最兼容的方案

2. **设置正确的base路径**
   - `base: '/hyw-tools/'` 在vite.config.ts中
   - 确保与您的仓库名一致

### 🔍 排查步骤：

#### 1. 检查仓库名称
```bash
# 如果您的仓库名不是 hyw-tools，修改 vite.config.ts
base: '/您的仓库名/'
```

#### 2. 检查GitHub Pages设置
- Settings → Pages
- Source 应该是 "GitHub Actions" 或 "Deploy from a branch"
- 如果选择branch，确保是 `gh-pages` 分支的 `/` 根目录

#### 3. 检查控制台错误
访问您的网站，按F12打开开发者工具：
- Network标签：查看是否有404错误
- Console标签：查看JavaScript错误

#### 4. 手动测试构建
```bash
bun run build
bun run preview
# 访问 http://localhost:4173/hyw-tools/ 测试
```

### 🚀 部署命令：

#### 方法一：GitHub Actions（推荐）
```bash
git add .
git commit -m "fix: 使用hash路由解决GitHub Pages白屏问题"
git push origin main
```

#### 方法二：手动部署
```bash
bun add -D gh-pages
bun run build
npx gh-pages -d dist
```

### 📱 测试URL格式：
- 首页：`https://[用户名].github.io/hyw-tools/`
- 关于页面：`https://[用户名].github.io/hyw-tools/#/about`

### 🆘 常见问题：

1. **所有资源都是404**
   - 检查 `vite.config.ts` 中的 `base` 设置
   - 确保与仓库名完全匹配

2. **页面加载但路由不工作**
   - 确保使用了Hash路由模式
   - 检查控制台是否有Vue Router错误

3. **样式不加载**
   - 检查CSS文件路径是否正确
   - 确保Tailwind CSS正确构建

4. **部署后仍然白屏**
   - 清除浏览器缓存
   - 等待几分钟让GitHub Pages生效
   - 检查Actions构建日志