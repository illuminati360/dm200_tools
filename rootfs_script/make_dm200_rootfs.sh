#!/bin/sh

############################
#
# DM200 rootfs make script
# v0.4.1 @ichinomoto
#
############################

###########
# settings
#

#VERSION=bullseye
VERSION=bookworm

#VARIANT=buildd
VARIANT=minbase
#SERVER=http://ftp.debian.org/debian/
#SERVER=https://mirror.lzu.edu.cn/debian/
SERVER=http://ftp.cn.debian.org/debian/

ROOTFS=rootfs
CACHE_DIR=`pwd`/cache/$VERSION
COMPONENTS=main,contrib,non-free

ZATHURA=1

# base
PACKAGE=apt-transport-https,apt-utils,ca-certificates,debian-archive-keyring,systemd,dbus,systemd-sysv,vim-tiny,unzip,bzip2,libcap2-bin
# network
PACKAGE=${PACKAGE},netbase,ifupdown,dnsutils,net-tools,isc-dhcp-client,openssh-server,iputils-ping,wget
# wireless
PACKAGE=${PACKAGE},bluetooth,wireless-tools,wpasupplicant
# console
PACKAGE=${PACKAGE},console-setup,sudo,psmisc,locales,keyboard-configuration,dialog,parted,less,lv,unar
# console tools extra
#PACKAGE=${PACKAGE},mc,gpm
# chinese console
PACKAGE=${PACKAGE},dbus-user-session
PACKAGE=${PACKAGE},fbterm,fbi,screen,tmux
# fcitx
PACKAGE=${PACKAGE},fcitx,fcitx-googlepinyin,fcitx-frontend-fbterm,fcitx-module-dbus
# font
PACKAGE=${PACKAGE},fonts-noto-cjk
# git
PACKAGE=${PACKAGE},git
# etc
PACKAGE=${PACKAGE},alsa-utils,man-db
# develop
PACKAGE=${PACKAGE},python3
# editor
PACKAGE=${PACKAGE},vim
# xorg
PACKAGE=${PACKAGE},xorg

# X version option
if [ ${ZATHURA} -eq 1 ]; then
    # zathura
    PACKAGE=${PACKAGE},build-essential,python3-pip,xz-utils,pipx,libglib2.0-dev,cmake,libgtk-3-dev,ninja-build,libjson-glib-dev,libmagic-dev,libsqlite3-dev,gettext,xorg-dev,libglfw3-dev,libgl1-mesa-dev,libglu1-mesa-dev,libmujs-dev,libopenjp2-7-dev,libjbig2dec0-dev,libgumbo-dev,freeglut3-dev
fi


###########
# main
#

if [ ! "${USER}" = "root" ]; then
    echo "This script need to do with sudo or root account."
    exit 1
fi

if [ -n "$1" ]; then
    ROOTFS=$1
fi

# make rootfs dir
mkdir -p $ROOTFS

# make debootstrap cache dir
mkdir -p $CACHE_DIR

# debootstrap
qemu-debootstrap --arch=armhf --variant=$VARIANT --components=$COMPONENTS --include=$PACKAGE --cache-dir=$CACHE_DIR $VERSION $ROOTFS $SERVER

# copy additional scripts
COPY_FILES=files

if [ -e $COPY_FILES ]; then
    cp -r $COPY_FILES/etc $ROOTFS/
    #cp -r $COPY_FILES/lib $ROOTFS/
    cp -r $COPY_FILES/lib/modules $ROOTFS/lib/
    cp -r $COPY_FILES/opt $ROOTFS/

    ln -s ../init.d/dm200_wireless $ROOTFS/etc/rc3.d/S10dm200_wireless
    ln -s ../init.d/dm200_wireless $ROOTFS/etc/rc4.d/S10dm200_wireless
    ln -s ../init.d/dm200_wireless $ROOTFS/etc/rc5.d/S10dm200_wireless
    ln -s ../init.d/dm200_wireless $ROOTFS/etc/rc6.d/K10dm200_wireless

    ln -s ../init.d/usb_host $ROOTFS/etc/rc3.d/S10usb_host
    ln -s ../init.d/usb_host $ROOTFS/etc/rc4.d/S10usb_host
    ln -s ../init.d/usb_host $ROOTFS/etc/rc5.d/S10usb_host
    ln -s ../init.d/usb_host $ROOTFS/etc/rc6.d/K10usb_host

    ln -s ../init.d/backlight $ROOTFS/etc/rc3.d/S10backlight
    ln -s ../init.d/backlight $ROOTFS/etc/rc4.d/S10backlight
    ln -s ../init.d/backlight $ROOTFS/etc/rc5.d/S10backlight
    ln -s ../init.d/backlight $ROOTFS/etc/rc6.d/K10backlight

    ln -s ../init.d/firstboot $ROOTFS/etc/rc3.d/S10firstboot
fi

#get firmware from armbian github repository
mkdir -p $ROOTFS/opt/etc/firmware

# for DM200
wget -nc https://github.com/armbian/firmware/raw/master/ap6210/bcm20710a1.hcd -O $ROOTFS/opt/etc/firmware/bcm20710a1.hcd
wget -nc https://raw.githubusercontent.com/armbian/firmware/master/ap6210/nvram.txt -O $ROOTFS/opt/etc/firmware/nvram_AP6210.txt
wget -nc https://github.com/armbian/firmware/raw/master/rkwifi/fw_RK901a2.bin -O $ROOTFS/opt/etc/firmware/fw_RK901a2.bin
wget -nc https://github.com/armbian/firmware/raw/master/rkwifi/fw_RK901a2_apsta.bin -O $ROOTFS/opt/etc/firmware/fw_RK901a2_apsta.bin
wget -nc https://github.com/armbian/firmware/raw/master/rkwifi/fw_RK901a2_p2p.bin -O $ROOTFS/opt/etc/firmware/fw_RK901a2_p2p.bin

# for DM250
wget -nc https://github.com/armbian/firmware/raw/master/ap6212/bcm43438a1.hcd -O $ROOTFS/opt/etc/firmware/BCM43438A1.hcd
wget -nc https://github.com/armbian/firmware/raw/master/ap6212/fw_bcm43438a1.bin -O $ROOTFS/opt/etc/firmware/fw_bcm43438a1.bin
wget -nc https://github.com/armbian/firmware/raw/master/ap6212/fw_bcm43438a1_mfg.bin -O $ROOTFS/opt/etc/firmware/fw_bcm43438a1_mfg.bin
wget -nc https://github.com/armbian/firmware/raw/master/ap6212/nvram.txt -O $ROOTFS/opt/etc/firmware/nvram_AP6212.txt

rm $ROOTFS/etc/resolv.conf