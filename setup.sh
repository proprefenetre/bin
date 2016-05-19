#!/bin/bash

# strict mode:
set -e -u

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
