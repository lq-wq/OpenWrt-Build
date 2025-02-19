
# Uncomment a feed source
if sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default; then
    echo "Uncommented helloworld feed source."
else
    echo "Failed to uncomment helloworld feed source." >&2
    exit 1
fi

# Add feed sources
{
    #echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall'
    echo 'src-git openclash https://github.com/vernesong/OpenClash'
    echo 'src-git adguardhome https://github.com/rufengsuixing/luci-app-adguardhome'
    #echo 'src-git kenzo https://github.com/kenzok8/openwrt-packages'
    #echo 'src-git small https://github.com/kenzok8/small'
    echo 'src-git infinityfreedomng https://github.com/xiaoqingfengATGH/luci-theme-infinityfreedom'
    #echo 'src-git mosdns https://github.com/sbwml/luci-app-mosdns'
} >> feeds.conf.default && echo "Added feed sources." || {
    echo "Failed to add feed sources." >&2
    exit 1
}

# 安装依赖库
sudo apt-get update && sudo apt-get install -y build-essential libncurses5-dev libncursesw5-dev

# 清理并更新代码
cd openwrt
git pull
./scripts/feeds update -a
./scripts/feeds install -a

# 修复 shadowsocks 依赖
sed -i 's/shadowsocks-libev-ss/shadowsocks-rust-ss/g' package/feeds/small/luci-app-*/Makefile

# 添加缺失的软件包
[ ! -d "package/wrtbwmon" ] && git clone https://github.com/brvphoenix/wrtbwmon package/wrtbwmon

# 清理循环依赖
sed -i '/CONFIG_PACKAGE_luci-app-fchomo/d' .config
sed -i '/CONFIG_PACKAGE_nikki/d' .config

# 添加 APP 插件
git clone https://github.com/sirpdboy/chatgpt-web.git package/luci-app-chatgpt      # chatgpt-web
git clone https://github.com/sirpdboy/luci-theme-kucat.git package/luci-app-kucat   # kucat主题
git clone https://github.com/lq-wq/luci-app-quickstart.git package/luci-app-quickstart   # iStoreOS-web
git clone https://github.com/sirpdboy/luci-app-lucky.git package/lucky      # luci-app-lucky 端口转发
git clone https://github.com/destan19/OpenAppFilter.git package/OpenAppFilter   # 应用过滤
git clone https://github.com/sirpdboy/luci-app-poweroffdevice package/luci-app-poweroffdevice   # 关机功能
git clone https://github.com/tty228/luci-app-wechatpush.git package/luci-app-serverchan  # 微信/Telegram 推送的插件

# 添加netdata插件
rm -rf ./feeds/luci/applications/luci-app-netdata/  
git clone https://github.com/Jason6111/luci-app-netdata ./feeds/luci/applications/luci-app-netdata/  

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
git clone https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
