#!/bin/bash


DEV=$(kdeconnect-cli -l | grep -i wileyfox | awk '{print $3}')
FILE=$2

case $1 in
    
    -p )    echo "pairing..."
            echo
            kdeconnect-cli --pair -d $DEV
            ;;
    
    -a )    echo "available devices:"
            echo
            kdeconnect-cli -a
            ;;

    -n )    echo "notifications:"
            echo
            kdeconnect-cli --list-notifications -d $DEV       
            ;;

    -s )    echo "sharing $FILE"
            echo
            kdeconnect-cli --share $FILE -d $DEV       
            ;;

    -r )    echo "refreshing connection"
            echo
            kdeconnect-cli --refresh
            ;;

    * )     echo "no action specified"
            ;;
esac
