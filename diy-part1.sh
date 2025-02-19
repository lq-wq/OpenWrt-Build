#!/bin/bash

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

# 添加 APP 插件
git clone https://github.com/sirpdboy/chatgpt-web.git package/luci-app-chatgpt      # chatgpt-web
git clone https://github.com/sirpdboy/luci-theme-kucat.git package/luci-app-kucat   # kucat主题
#git clone https://github.com/lq-wq/luci-app-quickstart.git package/luci-app-quickstart   # iStoreOS-web
git clone https://github.com/sirpdboy/luci-app-lucky.git package/lucky      # luci-app-lucky 端口转发
git clone https://github.com/destan19/OpenAppFilter.git package/OpenAppFilter   # 应用过滤
git clone https://github.com/sirpdboy/luci-app-poweroffdevice package/luci-app-poweroffdevice   # 关机功能
git clone https://github.com/tty228/luci-app-wechatpush.git package/luci-app-serverchan  # 微信/Telegram 推送的插件

# 添加netdata插件
rm -rf ./feeds/luci/applications/luci-app-netdata/  
git clone https://github.com/Jason6111/luci-app-netdata ./feeds/luci/applications/luci-app-netdata/  

# Themes主题
git clone https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
