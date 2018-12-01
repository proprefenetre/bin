#!/usr/bin/env bash

num_updates=$(checkupdates | wc -l)

if [ $num_updates -gt 0 ]; then
    read -t 10 -n 1 -p "Er zijn $num_updates updates. Installeren? Y/n " answer
    [ -z "$answer" ] && answer="Y"  # if 'yes' have to be default choice
    case ${answer:0:1} in
        y|Y )
            echo
            sudo pacman -Syu --noconfirm
            ;;
        * )
            :
            ;;
    esac
fi

/usr/bin/shutdown "$@"
