#!/bin/bash


# strict mode:
set -e
set -u
set -o pipefail

if [[ $# -eq 0 ]]; then
    echo "No arguments supplied" 
    exit 1
fi

TARGET=/media/sdc1-usb-Seagate_Expansio

# command:
case $1 in
    -d ) sudo rsync --dry-run -aAXuv --info=progress --include-from=rsync-include-list --exclude-from=rsync-exclude-list /* /media/sdb1-usb-Seagate_Expansio/new_backup 2>&1 | tee -a /home/niels/files/rsync-dry-$(date +%d%m%Y%H%M%S) 
    ;;

    -r ) sudo rsync -aAXuvS --info=progress --include-from=rsync-include-list --exclude-from=rsync-exclude-list /* $TARGET/arch1 2>&1 | tee -a /home/niels/files/rsync-all-$(date +%d%m%Y%H%M%S)
    ;;
    -m ) sudo rsync -aAxuv --info=progress /home/niels/media/* $TARGET/media/ 2>&1 | tee -a /home/niels/files/rsync-media-$(date +%d%m%Y%H%M%S)
        ;;
    * ) echo "usage:"
        echo "$0 -d(ry) | -r(eal deal) -m(edia)"
        ;;
esac

