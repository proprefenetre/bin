#!/bin/bash


# strict mode:
set -e
set -u
set -o pipefail

if [[ $# -eq 0 ]]; then
    echo "No arguments supplied" 
    exit 1
fi

# command:
case $1 in
    -d ) sudo rsync --dry-run -aAXuv --info=progress --include-from=rsync-include-list --exclude-from=rsync-exclude-list /* /run/media/niels/e192c491-20bb-4bc4-b321-9b55eda5f9a0/new_backup 2>&1 | tee -a rsync-dry-$(date +%d%m%Y%H%M%S)
        ;;
    -r ) sudo rsync -aAXuv --info=progress --include-from=rsync-include-list --exclude-from=rsync-exclude-list /* /run/media/niels/e192c491-20bb-4bc4-b321-9b55eda5f9a0/arch1 2>&1 | tee -a rsync-$(date +%d%m%Y%H%M%S)
        ;;
    -m ) sudo rsync -aAxuv --info=progress /home/niels/media/* /run/media/niels/e192c491-20bb-4bc4-b321-9b55eda5f9a0/media/ 2>&1 | tee -a rsync-$(date +%d%m%Y%H%M%S)
        ;;
    * ) echo "usage:"
        echo "$0 -d(ry) | -r(eal deal) -m(edia)"
        ;;
esac

