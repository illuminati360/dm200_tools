#!/bin/sh
USER_NAME=pomera
export PATH=$PATH:/usr/sbin/

# english+chinese settings
chmod u+s /usr/bin/fbterm
sed -i -e "s/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/" /etc/locale.gen
sed -i -e "s/# zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/" /etc/locale.gen
LANG="en_US.UTF-8"
locale-gen
update-locale
rm /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# keyboard layout
echo 'XKBMODEL="pc105"' > /etc/default/keyboard
echo 'XKBLAYOUT="us"' >> /etc/default/keyboard
echo 'XKBOPTIONS="ctrl:nocaps"' >> /etc/default/keyboard

# mali module
echo drm >> /etc/modules
echo mali_drm >> /etc/modules
echo ump >> /etc/modules
echo mali >> /etc/modules

# write source.list
DISTRIBUTION=`cat /etc/issue | awk '{print $1}'`
UBUNTU_VERSINO=`cat /etc/issue | awk '{print $2}'`
VERSION=`cat /etc/issue | awk '{print $3}'`
if [ ${DISTRIBUTION} = "Debian" ]; then
  if [ ${VERSION} = "10" ]; then
    CODE_NAME=buster
  elif [ ${VERSION} = "11" ]; then
    CODE_NAME=bullseye
  elif [ ${VERSION} = "12" ]; then
    CODE_NAME=bookworm
  fi
    echo "deb http://deb.debian.org/debian/ $CODE_NAME main contrib non-free" > /etc/apt/sources.list
    echo "deb http://security.debian.org/debian-security $CODE_NAME-security main contrib non-free" >> /etc/apt/sources.list
    echo "deb http://deb.debian.org/debian/ $CODE_NAME-updates main contrib non-free" >> /etc/apt/sources.list
    #echo "deb http://deb.debian.org/debian $CODE_NAME-backports main contrib non-free" > /etc/apt/sources.list
elif [ ${DISTRIBUTION} = "Ubuntu" ]; then
  if [ ${UBUNTU_VERSINO} = "16.04" ]; then
    echo "deb http://jp.archive.ubuntu.com/ubuntu-ports/ xenial main restricted" > /etc/apt/sources.list
    echo "deb http://jp.archive.ubuntu.com/ubuntu-ports/ xenial-updates main restricted" >> /etc/apt/sources.list
    echo "deb http://jp.archive.ubuntu.com/ubuntu-ports/ xenial universe" >> /etc/apt/sources.list
    echo "deb http://jp.archive.ubuntu.com/ubuntu-ports/ xenial-updates universe" >> /etc/apt/sources.list
    echo "deb http://jp.archive.ubuntu.com/ubuntu-ports/ xenial multivers" >> /etc/apt/sources.list
    echo "deb http://jp.archive.ubuntu.com/ubuntu-ports/ xenial-updates multivers" >> /etc/apt/sources.list
  fi
fi


# make mount point
mkdir -p /mnt/sd

# write fstab
echo "proc            /proc           proc    nodev,nosuid,noexec                         0   0" > /etc/fstab
echo "sysfs           /sys            sysfs   defaults                                    0   0" >> /etc/fstab
echo "devpts          /dev/pts        devpts  defaults                                    0   0" >> /etc/fstab
echo "/dev/mmcblk0p11 /opt/sys_info   ext4    ro                                          0   0" >> /etc/fstab
echo "/dev/mmcblk1p2  /               ext4    errors=remount-ro                           0   1" >> /etc/fstab
echo "/dev/mmcblk1p3  none            swap    sw                                          0   0" >> /etc/fstab
echo "/dev/mmcblk1p1  /mnt/sd         vfat    rw,sync,dirsync,noatime,umask=0000,utf8     0   0" >> /etc/fstab

echo "\n# for not show in desktop" >> /etc/fstab
echo "/dev/mmcblk0p1  none            none    none                                        0   0" >> /etc/fstab
echo "/dev/mmcblk0p2  none            none    none                                        0   0" >> /etc/fstab
echo "/dev/mmcblk0p3  none            none    none                                        0   0" >> /etc/fstab
echo "/dev/mmcblk0p4  none            none    none                                        0   0" >> /etc/fstab
echo "/dev/mmcblk0p5  none            none    none                                        0   0" >> /etc/fstab
echo "/dev/mmcblk0p6  none            none    none                                        0   0" >> /etc/fstab
echo "/dev/mmcblk0p7  none            none    none                                        0   0" >> /etc/fstab
echo "/dev/mmcblk0p8  none            none    none                                        0   0" >> /etc/fstab
echo "/dev/mmcblk0p9  none            none    none                                        0   0" >> /etc/fstab
echo "/dev/mmcblk0p10 none            none    none                                        0   0" >> /etc/fstab
echo "/dev/mmcblk0p12 none            none    none                                        0   0" >> /etc/fstab
echo "/dev/mmcblk0p13 none            none    none                                        0   0" >> /etc/fstab
echo "/dev/mmcblk0p14 none            none    none                                        0   0" >> /etc/fstab
echo "/dev/mmcblk0p15 none            none    none                                        0   0" >> /etc/fstab
echo "/dev/mmcblk0p16 none            none    none                                        0   0" >> /etc/fstab
echo "/dev/mmcblk0p17 none            none    none                                        0   0" >> /etc/fstab
echo "/dev/mmcblk0p18 none            none    none                                        0   0" >> /etc/fstab
echo "/dev/mmcblk0p19 none            none    none                                        0   0" >> /etc/fstab
echo "/dev/mmcblk0p20 none            none    none                                        0   0" >> /etc/fstab
echo "/dev/mmcblk0p21 none            none    none                                        0   0" >> /etc/fstab
echo "/dev/mmcblk0p22 none            none    none                                        0   0" >> /etc/fstab
echo "/dev/mmcblk0p23 none            none    none                                        0   0" >> /etc/fstab
echo "/dev/mmcblk0p24 none            none    none                                        0   0" >> /etc/fstab
echo "/dev/mmcblk0p25 none            none    none                                        0   0" >> /etc/fstab
echo "/dev/mmcblk0p26 none            none    none                                        0   0" >> /etc/fstab
echo "/dev/mmcblk0p27 none            none    none                                        0   0" >> /etc/fstab


# hostname
echo "$USER_NAME" > /etc/hostname
echo "127.0.0.1 localhost" > /etc/hosts
echo "127.0.1.1 $USER_NAME" >> /etc/hosts


# stop bluetoothd auto start
#chmod -x /etc/init.d/bluetooth


# add /opt/bin to PATH to skel
echo "PATH=/opt/bin:\$PATH" >> /root/.bashrc
echo "PATH=/opt/bin:\$PATH" >> /etc/skel/.bashrc

#echo "set root password"
passwd

# lock root account
#passwd -l root

# add user
useradd $USER_NAME -d /home/$USER_NAME -m -k /etc/skel -s /bin/bash -G video,sudo,lp
echo "set $USER_NAME passwd"
passwd $USER_NAME


## .xinitrc
#cat << \EOT >> /home/$USER_NAME/.xinitrc
#export LANG=en_US.UTF-8
#export GTK_IM_MODULE=ibus
#export XMODIFIERS=@im=ibus
#export QT_IM_MODULE=ibus
#
#EOT
##cat << \EOT >> /home/$USER_NAME/.xinitrc
##export LANG=en_US.UTF-8
##export GTK_IM_MODULE=fcitx
##export XMODIFIERS=@im=fcitx
##export QT_IM_MODULE=fcitx
##
##EOT
#
##echo "ibus-daemon -drx&" >> /home/$USER_NAME/.xinitrc
#echo "exec startxfce4" >> /home/$USER_NAME/.xinitrc
#chown $USER_NAME:$USER_NAME /home/$USER_NAME/.xinitrc

# add auto fbterm setting
cat << EOT >> /home/$USER_NAME/.bashrc

alias note="LANG=zh_CN.UTF-8 fcitx-fbterm-helper"
EOT

# network config
#systemctl disable NetworkManager
systemctl enable systemd-networkd
systemctl enable systemd-resolved
systemctl start systemd-resolved
#resolv.conf
rm /etc/resolv.conf
ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf
#interface
#mkdir /etc/systemd/network
cat << EOT > /etc/systemd/network/20-dhcp.network
[Match]
Name=wlan0

[Network]
DHCP=yes
EOT

# bluetooth config
#systemctl start bluetooth.service
#systemctl enable bluetooth.service

# stop auto X startup
#systemctl disable lightdm

# stop e2scrub_reap
systemctl stop e2scrub_reap.service
systemctl disable e2scrub_reap.service

# remove myself
rm /tmp/initial_settings.sh

