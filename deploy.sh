#!/bin/bash

# GitHub Pages 部署脚本
echo "🚀 开始部署到 GitHub Pages..."

# 检查是否在 git 仓库中
if ! git rev-parse --git-head > /dev/null 2>&1; then
    echo "❌ 错误：当前目录不是一个 Git 仓库"
    exit 1
fi

# 构建项目
echo "📦 构建项目..."
bun run build

if [ $? -ne 0 ]; then
    echo "❌ 构建失败"
    exit 1
fi

# 检查是否安装了 gh-pages
if ! command -v npx gh-pages &> /dev/null; then
    echo "📥 安装 gh-pages..."
    bun add -D gh-pages
fi

# 部署到 GitHub Pages
echo "🌐 部署到 GitHub Pages..."
npx gh-pages -d dist

if [ $? -eq 0 ]; then
    echo "✅ 部署成功！"
    echo "📱 您的网站将在几分钟后在 GitHub Pages 上生效"
else
    echo "❌ 部署失败"
    exit 1
fi