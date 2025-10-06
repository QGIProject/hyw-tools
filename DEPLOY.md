# GitHub Pages 部署指南

## 方法一：使用 GitHub Actions 自动部署（推荐）

### 1. 推送代码到 GitHub
确保您的代码已经推送到 GitHub 仓库的 main 分支。

### 2. 启用 GitHub Pages
1. 进入您的 GitHub 仓库
2. 点击 Settings 选项卡
3. 在左侧菜单中找到 Pages
4. 在 Source 下选择 GitHub Actions

### 3. 自动部署
- 当您推送代码到 `main` 分支时，GitHub Actions 会自动构建并部署到 GitHub Pages
- 部署完成后，您的网站将在：`https://[您的用户名].github.io/hyw-tools/`

## 方法二：手动部署

### 1. 安装 gh-pages
```bash
bun add -D gh-pages
```

### 2. 构建项目
```bash
bun run build
```

### 3. 部署到 GitHub Pages
```bash
bun run deploy
```

## 配置说明

### Vite 配置 (vite.config.ts)
- `base: '/hyw-tools/'` - 设置为您的仓库名称
- 如果您的仓库名不同，请相应修改

### GitHub Actions 配置
- 文件位置：`.github/workflows/deploy.yml`
- 自动在每次推送到 main 分支时触发部署
- 支持手动触发部署

## 注意事项

1. **仓库名称**：如果您的仓库名不是 `hyw-tools`，请修改 `vite.config.ts` 中的 `base` 配置
2. **分支名称**：默认使用 `main` 分支，如果使用 `master` 分支，请修改工作流文件
3. **权限设置**：确保 GitHub 仓库启用了 Pages 功能并具有适当权限
4. **构建时间**：首次部署可能需要几分钟时间

## 部署后检查

部署完成后，访问您的 GitHub Pages URL 检查：
- 页面是否正常加载
- 路由是否工作正常
- 样式是否正确应用
- 打字效果是否正常显示

## 故障排除

如果遇到问题：
1. 检查 GitHub Actions 工作流是否成功运行
2. 确认 `vite.config.ts` 中的 `base` 配置正确
3. 检查 GitHub Pages 设置中的源是否为 GitHub Actions
4. 查看浏览器控制台是否有 404 错误