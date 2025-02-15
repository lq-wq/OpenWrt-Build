#!/usr/bin/env bash  # 使用通用shebang

set -e  # 开启错误检测

echo "=== 当前工作目录 ==="
pwd
ls -al

# 确保在正确目录下执行
if [ ! -f feeds.conf.default ]; then
  echo "错误：必须在OpenWrt根目录执行！"
  exit 1
fi

# 添加权限修复
chmod +x scripts/feeds
chmod +x scripts/config/*

# 配置步骤
echo "CONFIG_TARGET_x86_64=y" > .config
echo "CONFIG_TARGET_ROOTFS_PARTSIZE=2048" >> .config

# 安全克隆（避免目录冲突）
clone_repo() {
  if [ ! -d "package/$2" ]; then
    git clone --depth=1 $1 package/$2
  fi
}

clone_repo https://github.com/sirpdboy/luci-theme-argon.git luci-theme-argon
clone_repo https://github.com/vernesong/OpenClash.git openclash

# 验证配置
make defconfig
