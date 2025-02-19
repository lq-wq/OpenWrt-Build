# 动态添加源配置
if [ ! -d "/etc/opkg" ]; then
  sudo mkdir -p "/etc/opkg"
fi
echo "src-git openwrt-package1 https://github.com/cdny123/openwrt-package1" | sudo tee -a /etc/opkg/customfeeds.conf > /dev/null
echo "src-git helloworld https://github.com/fw876/helloworld" | sudo tee -a /etc/opkg/customfeeds.conf > /dev/null

# 检查目录是否存在，如果不存在则创建
if [ ! -d "openwrt/bin/targets" ]; then
  mkdir -p "openwrt/bin/targets"
fi

# 检查 openwrt/target/linux/x86/ 目录是否存在，如果不存在则创建
if [ ! -d "openwrt/target/linux/x86" ]; then
  mkdir -p "openwrt/target/linux/x86"
fi

# 添加 luci-app-adguardhome 和 luci-app-openclash 及其核心组件
#echo "src-git helloworld https://github.com/fw876/helloworld" >> feeds.conf.default
#echo "src-git openwrt-package1 https://github.com/cdny123/openwrt-package1" >> feeds.conf.default
#./scripts/feeds update -a
#./scripts/feeds install -a

# 添加 APP 插件
#git clone https://github.com/sirpdboy/chatgpt-web.git package/luci-app-chatgpt      # chatgpt-web
#git clone https://github.com/sirpdboy/luci-theme-kucat.git package/luci-app-kucat   # kucat主题
#git clone https://github.com/lq-wq/luci-app-quickstart.git package/luci-app-quickstart   # iStoreOS-web
#git clone https://github.com/sirpdboy/luci-app-lucky.git package/lucky      # luci-app-lucky 端口转发

# 添加额外插件
#git clone --depth=1 https://github.com/kongfl888/luci-app-adguardhome package/luci-app-adguardhome
#git clone --depth=1 -b openwrt-18.06 https://github.com/tty228/luci-app-wechatpush package/luci-app-serverchan
#git clone --depth=1 https://github.com/ilxp/luci-app-ikoolproxy package/luci-app-ikoolproxy
#git clone --depth=1 https://github.com/esirplayground/luci-app-poweroff package/luci-app-poweroff
#git clone --depth=1 https://github.com/destan19/OpenAppFilter package/OpenAppFilter
#git clone --depth=1 https://github.com/Jason6111/luci-app-netdata package/luci-app-netdata
#svn export https://github.com/Lienol/openwrt-package/trunk/luci-app-filebrowser package/luci-app-filebrowser
#svn export https://github.com/Lienol/openwrt-package/trunk/luci-app-ssr-mudb-server package/luci-app-ssr-mudb-server
#svn export https://github.com/immortalwrt/luci/branches/openwrt-18.06/applications/luci-app-eqos package/luci-app-eqos
# svn export https://github.com/syb999/openwrt-19.07.1/trunk/package/network/services/msd_lite package/msd_lite

# 科学上网插件
#git clone --depth=1 -b main https://github.com/fw876/helloworld package/luci-app-ssr-plus
#svn export https://github.com/haiibo/packages/trunk/luci-app-vssr package/luci-app-vssr
#git clone --depth=1 https://github.com/jerrykuku/lua-maxminddb package/lua-maxminddb
#git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages package/openwrt-passwall
#svn export https://github.com/xiaorouji/openwrt-passwall/trunk/luci-app-passwall package/luci-app-passwall
#svn export https://github.com/xiaorouji/openwrt-passwall2/trunk/luci-app-passwall2 package/luci-app-passwall2
#svn export https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/luci-app-openclash

# Themes主题
#src-git infinityfreedomng https://github.com/xiaoqingfengATGH/luci-theme-infinityfreedom.git package/luci-theme-infinityfreedom
#git clone --depth=1 -b 18.06 https://github.com/kiddin9/luci-theme-edge package/luci-theme-edge
#git clone --depth=1 -b 18.06 https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon
#git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config
#git clone --depth=1 https://github.com/xiaoqingfengATGH/luci-theme-infinityfreedom package/luci-theme-infinityfreedom
#svn export https://github.com/haiibo/packages/trunk/luci-theme-atmaterial package/luci-theme-atmaterial
#svn export https://github.com/haiibo/packages/trunk/luci-theme-opentomcat package/luci-theme-opentomcat
#svn export https://github.com/haiibo/packages/trunk/luci-theme-netgear package/luci-theme-netgear

# iStore
#svn export https://github.com/cdny123/openwrt-package1/tree/main/app-store-ui package/app-store-ui
#svn export https://github.com/cdny123/openwrt-package1/tree/main/luci-app-store package/luci-app-store
