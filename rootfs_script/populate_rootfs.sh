ROOTFS=rootfs

ZATHURA=1

if [ ! "${USER}" = "root" ]; then
    echo "This script need to do with sudo or root account."
    exit 1
fi

#cp initial_settings.sh $ROOTFS/tmp/
#export HOME=/root
#cp $(which qemu-arm-static) $ROOTFS/bin/
#chroot $ROOTFS qemu-arm-static /bin/bash /tmp/initial_settings.sh

if [ ${ZATHURA} -eq 1 ]; then
    cp install_zathura.sh $ROOTFS/tmp/
    export HOME=/home/$USER_NAME
    chroot --userspec=$USER_NAME:$USER_NAME $ROOTFS qemu-arm-static /bin/bash /tmp/install_zathura.sh
fi