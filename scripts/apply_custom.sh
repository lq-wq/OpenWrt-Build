#!/usr/bin/env bash

# 严格模式设置
set -eo pipefail
shopt -s inherit_errexit

# 环境验证
if [[ ! -f feeds.conf.default ]]; then
  echo "❌ 错误：必须在OpenWrt根目录执行本脚本！"
  exit 1
fi

# 强制修复权限
find ./scripts -type f \( -name '*.sh' -o -name '*.pl' \) -exec chmod +x {} \;

# 核心配置
cat << EOF > .config
CONFIG_TARGET_x86=y
CONFIG_TARGET_x86_64=y
CONFIG_TARGET_ROOTFS_EXT4FS=y
CONFIG_TARGET_ROOTFS_PARTSIZE=2048
CONFIG_PACKAGE_luci=y
CONFIG_PACKAGE_luci-compat=y
EOF

# 安全克隆函数
safe_clone() {
  repo_url=$1
  target_dir=$2
  if [[ ! -d "package/${target_dir}" ]]; then
    git clone --depth=1 --single-branch "${repo_url}" "package/${target_dir}"
  fi
}

# 克隆必要仓库
safe_clone https://github.com/sirpdboy/luci-theme-argon.git luci-theme-argon
safe_clone https://github.com/vernesong/OpenClash.git openclash

# 更新软件源
echo "src-git custom https://github.com/cdny123/openwrt-package1" >> feeds.conf.default
./scripts/feeds update -a
./scripts/feeds install -a

# 最终验证
if ! make defconfig; then
  echo "❌ 配置验证失败，请检查错误日志！"
  exit 1
fi
