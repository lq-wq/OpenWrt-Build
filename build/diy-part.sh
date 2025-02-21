#!/bin/bash

# 1. 添加自定义软件源
cd package
git clone https://github.com/cdny123/openwrt-package1.git

# 2. 添加自定义软件包
git clone https://github.com/sirpdboy/luci-app-lucky.git
git clone https://github.com/lq-wq/luci-app-autoupdate.git
git clone https://github.com/Jason6111/luci-app-dockerman.git

# 添加自定义主题
git clone https://github.com/sirpdboy/luci-theme-kucat.git
git clone https://github.com/xiaoqingfengATGH/luci-theme-infinityfreedom.git
git clone https://github.com/jerrykuku/luci-theme-argon.git

# 3. 更换固件内核为6.6
cd ../target/linux/x86
sed -i 's/KERNEL_PATCHVER:=5.4/KERNEL_PATCHVER:=6.6/' Makefile

# 返回 openwrt 根目录
cd ../../..

# 4. 添加个性签名, 默认增加年月日
mkdir -p files/etc
echo "04543473@$(date +%Y%m%d)" > files/etc/banner

# 5. 添加内核和系统分区大小
sed -i 's/CONFIG_TARGET_KERNEL_PARTSIZE=.*/CONFIG_TARGET_KERNEL_PARTSIZE=64/' .config
sed -i 's/CONFIG_TARGET_ROOTFS_PARTSIZE=.*/CONFIG_TARGET_ROOTFS_PARTSIZE=2048/' .config

# 6. 添加默认主题为 luci-theme-argon
sed -i 's/luci-theme-bootstrap/luci-theme-argon/' feeds/luci/collections/luci/Makefile

# 7. 下载好 OpenClash 和 adguardhome 的内核文件
mkdir -p files/etc/openclash/core
wget -qO- https://github.com/vernesong/OpenClash/releases/download/Clash/clash-linux-amd64.tar.gz | tar xz -C files/etc/openclash/core
chmod +x files/etc/openclash/core/clash

mkdir -p files/etc/adguardhome
wget -qO- https://github.com/AdguardTeam/AdGuardHome/releases/latest/download/AdGuardHome_linux_amd64.tar.gz | tar xz -C files/etc/adguardhome
chmod +x files/etc/adguardhome/AdGuardHome

# 8. 修改 openwrt 后台地址为 192.168.6.1，默认子网掩码：255.255.255.0，修改主机名称为 op-NIT
sed -i 's/192.168.1.1/192.168.6.1/' package/base-files/files/bin/config_generate
sed -i 's/255.255.255.0/255.255.255.0/' package/base-files/files/bin/config_generate
sed -i 's/OpenWrt/op-NIT/' package/base-files/files/bin/config_generate

# 9. 设置免密码登录
sed -i '/root/c\root::0:0:99999:7:::' package/base-files/files/etc/shadow

# 10. 系统和网络优化
# 调整网络连接数
echo 'net.core.somaxconn = 1024' >> package/base-files/files/etc/sysctl.conf
echo 'net.core.netdev_max_backlog = 2048' >> package/base-files/files/etc/sysctl.conf
echo 'net.ipv4.tcp_max_syn_backlog = 2048' >> package/base-files/files/etc/sysctl.conf
echo 'net.ipv4.tcp_fin_timeout = 30' >> package/base-files/files/etc/sysctl.conf
echo 'net.ipv4.tcp_tw_reuse = 1' >> package/base-files/files/etc/sysctl.conf

# 启用BBR拥塞控制算法
echo 'net.core.default_qdisc = fq' >> package/base-files/files/etc/sysctl.conf
echo 'net.ipv4.tcp_congestion_control = bbr' >> package/base-files/files/etc/sysctl.conf

# 调整文件描述符限制
echo '* soft nofile 51200' >> package/base-files/files/etc/security/limits.conf
echo '* hard nofile 51200' >> package/base-files/files/etc/security/limits.conf

# 启用快速开放文件描述符选项
echo 'fs.file-max = 100000' >> package/base-files/files/etc/sysctl.conf
