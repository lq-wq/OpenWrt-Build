# 使用 OpenWrt ImageBuilder 作为基础镜像
FROM openwrt/imagebuilder:x86-64-openwrt-24.10
    
# 设置环境变量
ENV PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
ENV OPENWRT_VERSION=24.10
ENV KERNEL_VERSION=6.6
ENV HOSTNAME=openwrt-NIT
ENV LAN_IP=192.168.6.1
ENV ROOT_PASSWORD=""

# 确保使用 root 用户
USER root

# 创建 /etc/config 目录
RUN mkdir -p /etc/config

# 手动创建 network 文件
RUN echo "config interface 'loopback'" > /etc/config/network && \
    echo "    option ifname 'lo'" >> /etc/config/network && \
    echo "    option proto 'static'" >> /etc/config/network && \
    echo "    option ipaddr '127.0.0.1'" >> /etc/config/network && \
    echo "    option netmask '255.0.0.0'" >> /etc/config/network && \
    echo "" >> /etc/config/network && \
    echo "config globals 'globals'" >> /etc/config/network && \
    echo "    option ula_prefix 'auto'" >> /etc/config/network && \
    echo "" >> /etc/config/network && \
    echo "config interface 'lan'" >> /etc/config/network && \
    echo "    option type 'bridge'" >> /etc/config/network && \
    echo "    option ifname 'eth0'" >> /etc/config/network && \
    echo "    option proto 'static'" >> /etc/config/network && \
    echo "    option ipaddr '192.168.1.1'" >> /etc/config/network && \
    echo "    option netmask '255.255.255.0'" >> /etc/config/network && \
    echo "    option ip6assign '60'" >> /etc/config/network

# 修改后台地址
RUN sed -i "s/192.168.1.1/$LAN_IP/g" /etc/config/network

# 设置主机名和密码
RUN echo "config system" > /etc/config/system
RUN echo "    option hostname '$HOSTNAME'" >> /etc/config/system
RUN echo "    option timezone 'UTC'" >> /etc/config/system

# 设置内核和系统分区大小
RUN echo "CONFIG_TARGET_KERNEL_PARTSIZE=64" >> .config
RUN echo "CONFIG_TARGET_ROOTFS_PARTSIZE=2048" >> .config

# 更换固件内核
RUN echo "CONFIG_TARGET_KERNEL_VERSION=$KERNEL_VERSION" >> .config

# 添加个性签名
RUN echo "CONFIG_VERSION_DIST=\"OpenWrt\"" >> .config
RUN echo "CONFIG_VERSION_NICK=\"04543473+$(date +%Y%m%d)\"" >> .config

# 添加软件源
RUN echo "src/gz custom https://github.com/cdny123/openwrt-package1" >> /etc/opkg/customfeeds.conf

# 添加 APP 插件
RUN git clone https://github.com/sirpdboy/chatgpt-web.git package/luci-app-chatgpt
RUN git clone https://github.com/lq-wq/luci-app-quickstart.git package/luci-app-quickstart
RUN git clone https://github.com/sirpdboy/luci-app-lucky.git package/lucky
RUN git clone https://github.com/morytyann/OpenWrt-mihomo.git package/luci-app-mihomo

# 添加 Themes 主题
RUN git clone https://github.com/xiaoqingfengATGH/luci-theme-infinityfreedom.git package/luci-theme-infinityfreedom
RUN git clone https://github.com/jerrykuku/luci-theme-argon.git  package/luci-theme-argon
RUN git clone https://github.com/sirpdboy/luci-theme-kucat.git package/luci-theme-kucat

# 添加 IStore
RUN git clone https://github.com/linkease/istore.git package/istore

# 安装 opkg
RUN opkg update && opkg install opkg

# 支持系统重启
RUN opkg install luci-app-reboot

# 添加 Docker 支持
RUN opkg install luci-app-docker

# 添加 AdGuardHome 插件和核心
RUN git clone https://github.com/rufengsuixing/luci-app-adguardhome.git package/luci-app-adguardhome
RUN git clone https://github.com/AdguardTeam/AdGuardHome.git package/AdGuardHome

# 添加 OpenClash
RUN git clone -b master https://github.com/vernesong/OpenClash.git package/luci-app-openclash
RUN cd package/luci-app-openclash && ./scripts/download_clash.sh

# 开启 NTFS 格式盘挂载所需依赖
RUN opkg install kmod-fs-ntfs ntfs-3g

# 添加其他插件
RUN opkg install luci-app-ttyd luci-app-alist luci-app-upnp luci-app-poweroff luci-app-diskman luci-app-quickstart

# 优化系统和网络设置
RUN echo "net.core.rmem_max=12582912" >> /etc/sysctl.conf
RUN echo "net.core.wmem_max=12582912" >> /etc/sysctl.conf
RUN echo "net.ipv4.tcp_rmem=10240 87380 12582912" >> /etc/sysctl.conf
RUN echo "net.ipv4.tcp_wmem=10240 87380 12582912" >> /etc/sysctl.conf
RUN echo "net.ipv4.tcp_window_scaling=1" >> /etc/sysctl.conf
RUN echo "net.ipv4.tcp_timestamps=1" >> /etc/sysctl.conf
RUN echo "net.ipv4.tcp_sack=1" >> /etc/sysctl.conf
RUN echo "net.ipv4.tcp_fin_timeout=15" >> /etc/sysctl.conf
RUN echo "net.ipv4.tcp_keepalive_time=1800" >> /etc/sysctl.conf
RUN echo "net.ipv4.tcp_keepalive_probes=5" >> /etc/sysctl.conf
RUN echo "net.ipv4.tcp_keepalive_intvl=75" >> /etc/sysctl.conf
RUN echo "net.ipv4.tcp_max_syn_backlog=8192" >> /etc/sysctl.conf
RUN echo "net.ipv4.tcp_max_tw_buckets=1440000" >> /etc/sysctl.conf
RUN echo "net.ipv4.tcp_tw_reuse=1" >> /etc/sysctl.conf
RUN echo "net.ipv4.tcp_fastopen=3" >> /etc/sysctl.conf
RUN echo "net.ipv4.tcp_mtu_probing=1" >> /etc/sysctl.conf
RUN echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf

# 构建固件
RUN make -j$(nproc)
