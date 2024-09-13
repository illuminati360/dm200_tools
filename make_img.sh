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


mkdir -p /mnt/sd
mkdir -p /mnt/fs
mount /dev/loop0p1 /mnt/sd
mount /dev/loop0p2 /mnt/fs

# important to keep the permissions
cp -rp rootfs_script/rootfs/* /mnt/fs/

cp etc/partition_resize.sh /mnt/sd/_init.sh
mkdir /mnt/sd/settings/
cp etc/*.conf /mnt/sd/settings/

umount /mnt/sd
umount /mnt/fs
mount --make-slave $CHROOT_DIR/dev/
umount -R $CHROOT_DIR/dev/
losetup --detach /dev/loop0
mv $CHROOT_DIR/$TARGET_IMG .
