#!/bin/bash

# 设置后台管理IP
sed -i 's/192.168.1.1/192.168.6.1/g' package/base-files/files/bin/config_generate

# 设置分区大小
sed -i 's/option target rootfs/option target rootfs\n\toption size 64/g' target/linux/x86/image/Makefile
sed -i 's/option target rootfs/option target rootfs\n\toption size 2048/g' target/linux/x86/image/gpt-16k.mk

# 设置内核版本
sed -i 's/KERNEL_PATCHVER:=6.1/KERNEL_PATCHVER:=6.6/g' target/linux/x86/Makefile

# 修改默认主题
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# 修改主机名
sed -i 's/OpenWrt/04345473/g' package/base-files/files/bin/config_generate

# 设置编译作者信息
sed -i 's/OpenWrt/04543473 by NIT/g' package/base-files/files/etc/banner

# 添加自定义软件源
echo "src-git custom_packages https://github.com/cdny123/openwrt-package1.git" >> feeds.conf.default
echo "src-git luci-theme-kucat https://github.com/sirpdboy/luci-theme-kucat.git" >> feeds.conf.default

# 更新和安装feeds
./scripts/feeds update -a
./scripts/feeds install -a

# 下载luci-app-openclash和luci-app-adguardhome
git clone https://github.com/vernesong/OpenClash.git package/luci-app-openclash
git clone https://github.com/kongfl888/luci-app-adguardhome.git package/luci-app-adguardhome

# 添加常用软件包
cat <<EOF >> .config
CONFIG_PACKAGE_luci-app-alist=y
CONFIG_PACKAGE_luci-app-diskman=y
CONFIG_PACKAGE_luci-app-adguardhome=y
CONFIG_PACKAGE_luci-app-dockerman=y
CONFIG_PACKAGE_luci-app-mosdns=y
CONFIG_PACKAGE_luci-app-openclash=y
CONFIG_PACKAGE_luci-app-oaf=y
CONFIG_PACKAGE_luci-app-poweroff=y
CONFIG_PACKAGE_luci-app-quickstart=y
CONFIG_PACKAGE_luci-app-store=y
CONFIG_PACKAGE_luci-app-upnp=y
EOF

# 优化千兆网络和防火墙
echo "net.core.netdev_max_backlog=5000" >> files/etc/sysctl.d/99-custom.conf
echo "net.core.somaxconn=4096" >> files/etc/sysctl.d/99-custom.conf
echo "net.ipv4.tcp_fin_timeout=30" >> files/etc/sysctl.d/99-custom.conf
echo "net.ipv4.tcp_keepalive_time=1200" >> files/etc/sysctl.d/99-custom.conf
echo "net.ipv4.tcp_syncookies=1" >> files/etc/sysctl.d/99-custom.conf
echo "net.ipv4.tcp_tw_reuse=1" >> files/etc/sysctl.d/99-custom.conf
echo "net.ipv4.tcp_tw_recycle=1" >> files/etc/sysctl.d/99-custom.conf
echo "net.ipv4.tcp_max_tw_buckets=2000000" >> files/etc/sysctl.d/99-custom.conf
echo "net.ipv4.tcp_max_syn_backlog=4096" >> files/etc/sysctl.d/99-custom.conf
echo "net.ipv4.tcp_timestamps=0" >> files/etc/sysctl.d/99-custom.conf
echo "net.ipv4.tcp_synack_retries=2" >> files/etc/sysctl.d/99-custom.conf
echo "net.ipv4.tcp_syn_retries=2" >> files/etc/sysctl.d/99-custom.conf
echo "net.ipv4.tcp_no_metrics_save=1" >> files/etc/sysctl.d/99-custom.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> files/etc/sysctl.d/99-custom.conf
echo "net.ipv4.tcp_ecn=0" >> files/etc/sysctl.d/99-custom.conf
echo "net.ipv4.ip_forward=1" >> files/etc/sysctl.d/99-custom.conf
echo "net.ipv4.conf.all.forwarding=1" >> files/etc/sysctl.d/99-custom.conf
echo "net.ipv4.conf.default.forwarding=1" >> files/etc/sysctl.d/99-custom.conf

# 防火墙优化
cat <<EOF >> files/etc/firewall.user
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -A FORWARD -i eth0 -o br-lan -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i br-lan -o eth0 -j ACCEPT
EOF
