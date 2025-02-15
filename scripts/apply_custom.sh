#!/bin/bash

cd openwrt

# 精简主题配置（保留必要文件）
sed -i 's/CONFIG_PACKAGE_luci-theme-.*/CONFIG_PACKAGE_luci-theme-argon=y/' .config

# 删除冗余内核模块
sed -i '/CONFIG_PACKAGE_kmod-/d' .config
echo "CONFIG_PACKAGE_kmod-fs-ntfs=y" >> .config
echo "CONFIG_PACKAGE_kmod-tcp-bbr=y" >> .config

# 限制编译尺寸
echo "CONFIG_TARGET_IMAGES_GZIP_COMPRESS=y" >> .config
echo "CONFIG_TARGET_ROOTFS_PARTSIZE=2048" >> .config  # 分区缩小到2GB

# 禁用调试符号
echo "CONFIG_DEBUG=n" >> .config
echo "CONFIG_DEBUG_INFO=n" >> .config

# 清理历史构建
rm -rf tmp/ build_dir/ staging_dir/ logs/
