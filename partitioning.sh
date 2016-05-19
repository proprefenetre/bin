#!/bin/bash

# strict mode:
set -e -u -o pipefail

if [[ $# -eq 0 ]]; then
    echo "No device specified"
    exit 1
fi

DEV=/dev/sda

parted -a optimal --script $DEV -- \
    mklabel gpt \
    unit MiB \
    mkpart primary 1 3 \
    mkpart primary 3 131 \
    mkpart primary 131 643 \
    mkpart primary 643 -1 \
    name 1 grub \
    name 2 boot \
    name 3 swap \
    name 4 rootfs \
    set 1 bios_grub on \
    set 2 boot on \
    print

mkfs.vfat ${DEV}2
mkfs.ext4 -T small ${DEV}4
mkswap ${DEV}3
swapon ${DEV}3

mount ${DEV}4 /mnt
mkdir /mnt/boot
mount ${DEV}2 /mnt/boot

