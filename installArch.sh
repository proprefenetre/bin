#!/bin/bash

# strict mode:
set -e -u

loadkeys dvorak && echo 'keymap=dvorak'
ping -c 3 google.com
timedatectl set-ntp true

# https://wiki.archlinux.org/index.php/GNU_Parted

parted -a optimal --script /dev/sda \
    mklabel gpt \
    unit MiB \
    mkpart primary 1 513 \
    set 1 boot on \
    mkpart primary 513 100% \
    print

sleep 5s

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

# Chroot into system
arch-chroot /mnt /bin/bash

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

# Setup locale even more
localectl set-keymap dvorak
localectl set-x11-keymap dvorak
localectl status

# Enable and start dhcp
systemctl enable dhcpcd.service
dhcpcd

# Add normal user
useradd -m -G wheel -s /bin/bash trash
passwd trash

# Install sudo, git & wget
pacman -S sudo git wget

# https://wiki.archlinux.de/title/Sudo
EDITOR=vim visudo
# %wheel   ALL=(ALL) ALL

# Install AUR
# https://wiki.archlinux.org/index.php/AUR_helpers
# https://wiki.archlinux.org/index.php/Arch_User_Repository
# Install cower
pacman -S yajl
wget http://code.falconindy.com/archive/cower/cower-12.tar.gz
tar zxvf cower-12.tar.gz
cd cower-12
wget https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=cower -o PKGBUILD
gpg --recv-key $(cat PKGBUILD | grep validpgpkeys | awk -F "'" '{print $2}')
makepkg -sri
cd ..

# Install pacaur
wget https://github.com/rmarquis/pacaur/archive/4.2.27.tar.gz
tar zxvf 4.2.27.tar.gz
cd pacaur-4.2.27
wget https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=pacaur
mv PKGBUILD?h=pacaur PKGBUILD
makepkg -sri

# Install X
pacman -S xorg-server xorg-xinit xorg-utils xorg-server-utils i3-wm i3status

# Copy x11 initrc
cp /etc/X11/xinit/xinitrc /home/trash/.xinitrc

# Let NTP synchronize the time
timedatectl set-ntp true

# Install virtualbox guest utils
rm /usr/bin/VBox*
rm /usr/lib/VBox*
pacman -S virtualbox-guest-utils
modprobe -a vboxguest vboxsf vboxvideo
echo "vboxguest" >> /etc/modules-load.d/virtualbox.conf
echo "vboxsf" >> /etc/modules-load.d/virtualbox.conf
echo "vboxvideo" >> /etc/modules-load.d/virtualbox.conf
echo "/usr/bin/VBoxClient-all" >> /home/arch/.xinitrc

echo  "exec i3" >> /home/trash/.xinitrc
