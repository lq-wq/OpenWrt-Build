#!/bin/bash

# Clone官方仓库
git clone --depth=1 --branch=openwrt-24.10 https://github.com/openwrt/openwrt.git
cd openwrt

# 添加软件源
echo 'src-git custom https://github.com/cdny123/openwrt-package1' >> feeds.conf.default

# 更新feed
./scripts/feeds update -a
./scripts/feeds install -a

# 克隆第三方包
git clone https://github.com/sirpdboy/luci-theme-argon.git package/luci-theme-argon
git clone https://github.com/lq-wq/luci-app-quickstart.git package/luci-app-quickstart
git clone https://github.com/morytyann/OpenWrt-mihomo.git package/luci-app-mihomo
git clone https://github.com/sirpdboy/chatgpt-web.git package/luci-app-chatgpt
git clone https://github.com/sirpdboy/luci-app-lucky.git package/lucky
git clone https://github.com/xiaoqingfengATGH/luci-theme-infinityfreedom.git package/luci-theme-infinityfreedom
git clone https://github.com/sirpdboy/luci-theme-kucat.git package/luci-app-kucat
git clone --depth 1 --branch master https://github.com/vernesong/OpenClash.git package/openclash

# 配置内核
sed -i 's/KERNEL_PATCHVER:=.*/KERNEL_PATCHVER:=6.6/' target/linux/x86/Makefile

# 合并配置文件
cat ../config/common.config > .config
cat ../config/software.config >> .config

# 系统参数
echo "CONFIG_TARGET_ROOTFS_PARTSIZE=4096" >> .config
echo "CONFIG_TARGET_KERNEL_PARTSIZE=128" >> .config

# 生成签名
BUILD_DATE=$(date +%Y%m%d)
sed -i "s/OpenWrt /OpenWrt-04543473-$BUILD_DATE /" package/base-files/files/etc/openwrt_release

make defconfig
