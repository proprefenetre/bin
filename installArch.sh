#!/bin/bash

# strict mode:
set -e -u

# https://wiki.archlinux.org/index.php/GNU_Parted
parted -a optimal --script /dev/sda \
    mklabel gpt \
    unit MiB \
    mkpart primary 1 2 \
    set 1 bios_grub on \
    mkpart primary 2 514 \
    set 2 boot on \
    mkpart primary 513 100% \
    print


# mkdir -p /mnt/boot
# mount /dev/sda1 /mnt/boot && echo 'mounted boot'

# LVM partition
pvcreate /dev/sda2

# encryption
modprobe dm-crypt
cryptsetup -c aes-xts-plain -y -s 512 luksFormat /dev/sda2
cryptsetup luksOpen /dev/sda2 lvm
pvcreate /dev/mapper/lvm
vgcreate main /dev/mapper/lvm # Create main volume group
vgchange -a y main # Activate volume group

if [[ -f /etc/crypttab ]]; then
  cp /etc/crypttab /etc/crypttab_$(date +%s).bak
fi

# / [ext4] 25gb luks (arch-core)
lvcreate -L 5GB -n root main
mkfs.ext4 -L root /dev/mapper/main-root
mount /dev/mapper/main-root /mnt

# /var [ext4] 10gb luks (arch-var)
lvcreate -L 5GB -n var main
mkfs.ext4 -L root /dev/mapper/main-var
mkdir -p /mnt/var
mount /dev/mapper/main-var /mnt/var

# /tmp [tmpfs] 500mb luks (arch-tmp)
lvcreate -L 500MB -n tmp main
mkfs.ext4 -L root /dev/mapper/main-tmp
mkdir -p /mnt/tmp
mount /dev/mapper/main-tmp /mnt/tmp

# swap [swap] 4gb luks (arch-swap)
lvcreate -L 4GB -n swap main
mkswap -L swap /dev/mapper/main-swap
swapon /dev/mapper/main-swap

# /home [ext4] 10gb per user luks (arch-home)
lvcreate -l 100%FREE -n home main
mkfs.ext4 -L root /dev/mapper/main-home
mkdir -p /mnt/home
mount /dev/mapper/main-home /mnt/home

# Display status
pvdisplay
sleep 5s
lvdisplay
sleep 5s
cat /etc/fstab
sleep 5s
cat /etc/crypttab
sleep 5s

# Mount boot
mkfs.ext4 -L boot /dev/sda1
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot

# Overwrite pacman mirror
echo 'Server = http://mirror.one.com/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist

# Install basic system
pacstrap -i /mnt base base-devel

# Generate fstab
genfstab -L /mnt > /mnt/etc/fstab
cat /mnt/etc/fstab

cp pstchroot.sh /mnt/etc
cp setup.sh /mnt/etc

# Chroot into system
arch-chroot /mnt /bin/bash

