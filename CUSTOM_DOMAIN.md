# 自定义域名配置指南

## 📋 已完成的配置：

1. ✅ Vite配置更新为根路径 (`base: '/'`)
2. ✅ 路由配置简化（移除BASE_URL）
3. ✅ 创建CNAME文件模板

## 🔧 需要您完成的步骤：

### 1. 设置CNAME文件
编辑 `public/CNAME` 文件，将内容替换为您的域名：

```bash
# 如果是根域名
yourdomain.com

# 如果是www子域名
www.yourdomain.com

# 如果是其他子域名
tools.yourdomain.com
```

### 2. DNS配置
根据您的域名类型进行DNS配置：

#### A记录（推荐）
```
类型: A
名称: @ (或您的域名，如 tools)
值: 185.199.108.153
值: 185.199.109.153
值: 185.199.110.153
值: 185.199.111.153
```

#### CNAME记录
```
类型: CNAME
名称: www (或您的子域名)
值: [您的用户名].github.io
```

### 3. GitHub仓库设置
1. 进入仓库的 Settings → Pages
2. 在 "Custom domain" 中输入您的域名
3. ✅ 勾选 "Enforce HTTPS"
4. 等待DNS验证（通常需要几分钟到几小时）

## 🚀 部署步骤：

1. **设置CNAME文件**
```bash
# 编辑 public/CNAME 文件
echo "yourdomain.com" > public/CNAME
```

2. **构建和部署**
```bash
bun run build
git add .
git commit -m "feat: 配置自定义域名支持"
git push origin main
```

3. **验证配置**
- 访问您的自定义域名
- 检查是否有SSL证书
- 测试所有页面和功能

## 📱 URL格式：

配置完成后，URL将是：
- 首页：`https://yourdomain.com/`
- 关于：`https://yourdomain.com/#/about`

## 🆘 故障排除：

### 域名无法访问
1. 检查DNS配置是否正确
2. 等待DNS传播完成（最多24小时）
3. 使用 `nslookup` 命令验证DNS

### HTTPS证书问题
1. 在GitHub Pages设置中确保勾选了 "Enforce HTTPS"
2. 等待证书自动生成（通常30分钟内）

### 页面404错误
1. 确保CNAME文件内容正确
2. 检查GitHub Pages是否正确部署
3. 清除浏览器缓存

### GitHub Pages设置
```
Settings → Pages → Custom domain: yourdomain.com
✅ Enforce HTTPS
Source: GitHub Actions (推荐) 或 Deploy from branch
```

## 🔄 自动部署：

使用GitHub Actions时，每次推送都会：
1. 自动构建项目
2. 包含CNAME文件
3. 部署到GitHub Pages
4. 更新您的自定义域名站点