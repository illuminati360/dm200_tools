#!/bin/bash

TARGET_IMG=mytest.img
dd if=/dev/zero of=$TARGET_IMG seek=10692607 count=0

CHROOT_DIR=initramfs/files
IMG_PATH=$CHROOT_DIR/$TARGET_IMG
mv mytest.img $IMG_PATH

mount --rbind /dev $CHROOT_DIR/dev/

# mount --rbind /dev $CHROOT_DIR/dev/
chroot $CHROOT_DIR bin/qemu-arm-static /bin/parted -s -a optimal $TARGET_IMG -- mklabel msdos
chroot $CHROOT_DIR bin/qemu-arm-static /bin/parted -s -a optimal $TARGET_IMG -- mkpart primary fat32 1 2149
chroot $CHROOT_DIR bin/qemu-arm-static /bin/parted -s -a optimal $TARGET_IMG -- mkpart primary ext4 2150 5371
chroot $CHROOT_DIR bin/qemu-arm-static /bin/parted -s -a optimal $TARGET_IMG -- mkpart primary linux-swap 5372 -1

losetup -P /dev/loop0 $IMG_PATH

chroot $CHROOT_DIR bin/qemu-arm-static /bin/mke2fs /dev/loop0p2
chroot $CHROOT_DIR bin/qemu-arm-static /bin/e2fsck -f /dev/loop0p2
chroot $CHROOT_DIR bin/qemu-arm-static /bin/mkfs.vfat /dev/loop0p1
chroot $CHROOT_DIR bin/qemu-arm-static /bin/mkswap /dev/loop0p3


sudo mkdir -p /mnt/sd
sudo mkdir -p /mnt/fs
sudo mount /dev/loop0p1 /mnt/sd
sudo mount /dev/loop0p2 /mnt/fs

sudo cp -r rootfs_script/rootfs/* /mnt/fs/

sudo cp etc/partition_resize.sh /mnt/sd/_init.sh
sudo mkdir /mnt/sd/settings/
sudo cp etc/*.conf /mnt/sd/settings/