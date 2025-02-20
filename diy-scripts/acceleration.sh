#!/bin/bash

# 通用优化
echo "CONFIG_TARGET_OPTIMIZATION='-march=native -O3 -pipe'" >> .config
echo "CONFIG_KERNEL_CFQ_GROUP_IOSCHED=y" >> .config

# 网络加速
echo "CONFIG_NETFILTER_NETLINK_GLUE_CT=y" >> .config
echo "CONFIG_NF_FLOW_TABLE_FAST=y" >> .config
echo "CONFIG_NET_SCH_CAKE=y" >> .config
echo "CONFIG_NET_SCH_FQ_CODEL=y" >> .config

# 硬件加速（根据平台选择）
# Intel网卡
echo "CONFIG_PACKAGE_kmod-ixgbe=y" >> .config
echo "CONFIG_PACKAGE_kmod-i40e=y" >> .config

# MTK平台
echo "CONFIG_PACKAGE_kmod-mtkhnat=y" >> .config
echo "CONFIG_PACKAGE_kmod-mt7915e=y" >> .config

# Qualcomm
echo "CONFIG_PACKAGE_kmod-qca-nss-drv=y" >> .config
