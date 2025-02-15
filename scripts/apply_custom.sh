#!/bin/bash

cd openwrt

# 设置主题和基础配置
sed -i 's/CONFIG_DEFAULT_THEME=.*/CONFIG_DEFAULT_THEME=\"argon\"/' .config
echo "CONFIG_TARGET_ROOTFS_PARTSIZE=4096" >> .config
echo "CONFIG_TARGET_KERNEL_PARTSIZE=128" >> .config

# 设置主机名和IP
sed -i 's/CONFIG_TARGET_HOSTNAME=.*/CONFIG_TARGET_HOSTNAME=\"openwrt-NIT\"/' .config
echo "CONFIG_IPADDR=\"192.168.6.1\"" >> .config

# 添加第三方源
echo 'src-git custom https://github.com/cdny123/openwrt-package1' >> feeds.conf.default
./scripts/feeds update -a
./scripts/feeds install -a

# 克隆第三方软件包
git clone https://github.com/sirpdboy/luci-theme-argon.git package/luci-theme-argon
git clone https://github.com/lq-wq/luci-app-quickstart.git package/luci-app-quickstart
git clone --branch master https://github.com/vernesong/OpenClash.git package/openclash

# 签名设置
BUILD_DATE=$(date +%Y%m%d)
echo "CONFIG_VERSION_DIST=\"OpenWrt-04543473\"" >> .config
echo "CONFIG_VERSION_NUMBER=\"$BUILD_DATE\"" >> .config

# 生成最终配置
make defconfig
