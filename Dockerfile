FROM openwrt/imagebuilder:x86-64-openwrt-24.10

# 设置环境变量
ENV OPENWRT_VERSION=24.10
ENV KERNEL_VERSION=6.6
ENV HOSTNAME=openwrt-NIT
ENV LAN_IP=192.168.6.1
ENV ROOT_PASSWORD=""

FROM openwrt:latest  # 确保使用包含 opkg 的基础镜像

# 安装 opkg（如果基础镜像中没有）
RUN opkg update && opkg install opkg  # 如果基础镜像中没有 opkg，取消注释此行

RUN opkg update

# 安装Argon主题
RUN opkg install luci-theme-argon

# 设置主机名和密码
RUN echo "config system" > /etc/config/system
RUN echo "    option hostname '$HOSTNAME'" >> /etc/config/system
RUN echo "    option timezone 'UTC'" >> /etc/config/system
RUN echo "    option ttylogin '0'" >> /etc/config/system
RUN echo "    option log_size '64'" >> /etc/config/system
RUN echo "    option urandom_seed '0'" >> /etc/config/system
RUN echo "    option cronloglevel '5'" >> /etc/config/system
RUN echo "    option zonename 'UTC'" >> /etc/config/system
RUN echo "    option log_proto 'udp'" >> /etc/config/system
RUN echo "    option log_ip '127.0.0.1'" >> /etc/config/system
RUN echo "    option log_port '514'" >> /etc/config/system
RUN echo "    option conloglevel '7'" >> /etc/config/system
RUN echo "    option log_remote '0'" >> /etc/config/system

# 修改后台地址
RUN sed -i "s/192.168.1.1/$LAN_IP/g" /etc/config/network

# 添加在线更新功能
RUN opkg install luci-app-update

# 支持系统重启
RUN opkg install luci-app-reboot

# 设置内核和系统分区大小
RUN echo "CONFIG_TARGET_KERNEL_PARTSIZE=64" >> .config
RUN echo "CONFIG_TARGET_ROOTFS_PARTSIZE=2048" >> .config

# 更换固件内核
RUN echo "CONFIG_TARGET_KERNEL_VERSION=$KERNEL_VERSION" >> .config

# 添加个性签名
RUN echo "CONFIG_VERSION_DIST=\"OpenWrt\"" >> .config
RUN echo "CONFIG_VERSION_NICK=\"04543473+$(date +%Y%m%d)\"" >> .config

# 添加IStore
RUN git clone https://github.com/linkease/istore.git package/istore

# 添加Docker支持
RUN opkg install luci-app-docker

# 添加AdGuardHome插件和核心
RUN git clone https://github.com/rufengsuixing/luci-app-adguardhome.git package/luci-app-adguardhome
RUN git clone https://github.com/AdguardTeam/AdGuardHome.git package/AdGuardHome

# 添加OpenClash
RUN git clone -b master https://github.com/vernesong/OpenClash.git package/luci-app-openclash
RUN cd package/luci-app-openclash && ./scripts/download_clash.sh

# 开启NTFS格式盘挂载所需依赖
RUN opkg install kmod-fs-ntfs ntfs-3g

# 添加APP插件
RUN git clone https://github.com/sirpdboy/chatgpt-web.git package/luci-app-chatgpt
RUN git clone https://github.com/lq-wq/luci-app-quickstart.git package/luci-app-quickstart
RUN git clone https://github.com/sirpdboy/luci-app-lucky.git package/lucky
RUN git clone https://github.com/morytyann/OpenWrt-mihomo.git package/luci-app-mihomo

# 添加Themes主题
RUN git clone https://github.com/xiaoqingfengATGH/luci-theme-infinityfreedom.git package/luci-theme-infinityfreedom
RUN git clone https://github.com/sirpdboy/luci-theme-kucat.git package/luci-app-kucat

# 添加软件源
RUN echo "src/gz custom https://github.com/cdny123/openwrt-package1" >> /etc/opkg/customfeeds.conf

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
