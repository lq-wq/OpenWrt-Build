#!/bin/bash

cd openwrt

# 内核优化
cat >> package/kernel/linux/files/sysctl.conf <<EOF
net.core.rmem_max=16777216
net.core.wmem_max=16777216
net.ipv4.tcp_window_scaling=1
net.ipv4.tcp_congestion_control=bbr
EOF

# 硬件加速
echo "CONFIG_PACKAGE_kmod-tcp-bbr=y" >> .config
echo "CONFIG_PACKAGE_kmod-fs-ntfs=y" >> .config
echo "CONFIG_PACKAGE_ntfs-3g=y" >> .config
