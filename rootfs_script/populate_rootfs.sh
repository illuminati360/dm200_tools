ROOTFS=rootfs

if [ ! "${USER}" = "root" ]; then
    echo "This script need to do with sudo or root account."
    exit 1
fi

cp initial_settings.sh $ROOTFS/tmp/
export HOME=/root
cp $(which qemu-arm-static) $ROOTFS/bin/
chroot $ROOTFS qemu-arm-static /bin/bash /tmp/initial_settings.sh