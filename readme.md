## DM200/DM250 tools

### About DM250
- disk layout
```
EMMC=/dev/mmcblk0
SD=/dev/mmcblk1
INITRAMFS=/dev/mmcblk0p4           # initramfs
SYS_INFO=/dev/mmcblk0p11           # sys_info
KERNEL_TARGET=/dev/mmcblk0p14      # recovery_kernel
INITRAMFS_TARGET=/dev/mmcblk0p15   # recovery_initramfs
MMCBLK_SD_VFAT=/dev/mmcblk1p1      # vfat
MMCBLK_SD_ROOTFS=/dev/mmcblk1p2    # rootfs
MMCBLK_SD_SWAP=/dev/mmcblk1p3      # swap
```
- [debian kernel](https://github.com/ichinomoto/dm200_debian_kernel)
- recovery mode:
    - left alt + right shift + power
    - runs recovery_initramfs (which is what the initramfs in this project is for)

- prerequisites (Arch Linux)
```
# install toolchain for initramfs cross compilation
yay -S arm-none-linux-gnueabihf-toolchain-bin
# qemu-debootstrap to make rootfs
yay -S qemu-debootstrap
# chroot black magic (useful for running armh executables!)
# used to run the init_settings.sh to populate the rootfs
# used to run armh native mke2fs,mkfs.vfat
sudo pacman -S qemu-user-static qemu-user-static-binfmt
```

### etc
- etceteras
    - `get_firm.sh`:
        - get firmware from initramfs on emmc
        - not used, instead download from ambian github directly
    - `partition_resize.sh`:
        - resize partition on first boot
        - used when creating the sd partition
    - add `wpa_supplicant.conf` and `backlight.conf` by yourself
        - used by make_img.sh
        - copied into `/dev/mmcblk1p1:/mnt/sd/settings`

## initramfs
Scripts for creating intramfs (intramfs.img)
- used as recovery initramfs to enter linux
- run the build script to get some executables
```
sudo ./make_initramfs.sh
cp busybox-1.35.0/_install/
# cp mkswap to chroot bin
cp initramfs/busybox-1.35.0/_install/sbin/mkswap initramfs/files/bin/
cp initramfs/busybox-1.35.0/_install/sbin/mkfs.vfat initramfs/files/bin/
```

### installer
Script for installing recovery kernel and initramfs

### rootfs_script
Scripts for creating rootfs and some post-boot Linux scripts
- sd img layout
```
# use loopback to mount the disk image provided by the author
sudo losetup /dev/loop0 pomera-debian-xxxx.img
sudo parted -s /dev/loop0 print

#Model: Loopback device (loopback)
#Disk /dev/loop0: 5477MB
#Sector size (logical/physical): 512B/512B
#Partition Table: msdos
#Disk Flags: 
#
#Number  Start   End     Size    Type     File system     Flags
# 1      1049kB  2149MB  2147MB  primary  fat32           lba
# 2      2150MB  5371MB  3221MB  primary  ext4
# 3      5372MB  5475MB  103MB   primary  linux-swap(v1)  swap
```
- Usage:
```
sudo ./make_dm200_rootfs.sh
sudo ./populate_rootfs.sh
# Warning: don't run initial_settings.sh directly!!!!
```

### make_img
- Usage
```
sudo ./make_img.sh
```