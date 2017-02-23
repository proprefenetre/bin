#!/usr/bin/env bash

# need:
# kernel source
# patch
# linux-headers

confirm () {
    # call with a prompt string or use a default
    read -r -p "${1:-Proceed? [y/N]} " response
    case $response in
        [yY][eE][sS]|[yY]) 
            true
            ;;
        *)
            exit 1
            ;;
    esac
}

underline () {
    pad=$(printf '%0.1s' ${2:--}{1..60})
    padlength=0
    printf '\n%s\n' "$1"
    printf '%*.*s\n' 0 $((padlength + ${#1})) "$pad"
}

current_kernel=$(uname -r)
patch="./patches/alx-wake-on-lan-linux-4.9.patch"
target="linux-${current_kernel%%-*}.tar.gz"
src_dir="$(basename $target .tar.gz)"
module="drivers/net/ethernet/atheros/alx/alx.ko"
updates="/usr/lib/modules/$(uname -r)/updates"

[[ ! -f "$patch" ]] && echo "patch not found" && exit 1

# get source
if [[ ! -f "./$target" ]]; then
    echo -n "downloading source: $target "
    confirm && curl -O "https://www.kernel.org/pub/linux/kernel/v4.x/$target"
    # or makepkg -o if using abs ;)
fi

if [[ ! -d "./$src_dir" ]]; then
    echo -n "extracting $target to: $src_dir "
    confirm && tar xvf "$target" "$src_dir"
fi

cd "$src_dir"
# apply patch. NB: make sure the filenames in the patch are correct

underline "patching -- dry run:" "="
patch --dry-run -p1 -i "$patch"
echo -n "for real? "
confirm && patch -p1 -i "$patch"

# make sure the build directory is clean:
underline "cleaning up" "="
make clean && make mrproper

# copy current kernel config etc.:
underline "copy kernel config" "="
cp -v /usr/lib/modules/$(uname -r)/build/{.config,Module.symvers} ./

# prepare source for compilation:
underline "preparing source" "="
make prepare && make scripts
# build the module
underline "building alx.ko" "="
confirm && make M="$(dirname $module)"

underline "gzip module" "="
gzip -v "$module"

underline "install" =
echo -n "cp -v "$module".gz $updates/ "
confirm
[[ ! -d "$updates" ]] && sudo mkdir "$updates"
sudo cp -v "$module".gz "$updates/"

underline "rebuild module dependency tree" "="
sudo depmod -av

underline "regenerate initramfs" "="
sudo mkinitcpio -p linux

underline "clean up source" "="
confirm && rm -vr "./$src_dir"

confirm "reboot now? " && reboot
