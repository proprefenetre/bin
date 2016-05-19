#!/bin/bash

# strict mode:
set -e -u

# generate locale
sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

# set time zone
ln -sf /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime

# keymap
echo 'KEYMAP=dvorak' > /etc/vconsole.conf

# Setup hardwareclock
hwclock --systohc --utc

# Setup hostname
echo 'arch-test' > /etc/hostname

# Change root password
passwd

# Install bootloader (grub)
pacman -S grub

# Add LVM to kernel params
vim /etc/mkinitcpio.conf
# HOOKS += encrypt lvm2

mkinitcpio -p linux

# http://unix.stackexchange.com/questions/199164/error-run-lvm-lvmetad-socket-connect-failed-no-such-file-or-directory-but
vim /etc/lvm/lvm.conf
# use_lvmetad = 0

# https://wiki.archlinux.org/index.php/GRUB#LVM
# https://wiki.archlinux.org/index.php/Dm-crypt/System_configuration#Mounting_at_boot_time
vim /etc/default/grub
# GRUB_CMDLINE_LINUX_DEFAULT="cryptdevice=/dev/sda2:lvm"
# GRUB_ENABLE_CRYPTODISK=y
# GRUB_DISABLE_LINUX_UUID=true

# Install grub to boot
grub-install --target=i386-pc /dev/sda

# Generate grub config
grub-mkconfig -o /boot/grub/grub.cfg

# Read https://wiki.archlinux.org/index.php/Systemd systemd-analyze(1)

# REBOOT!
shutdown
