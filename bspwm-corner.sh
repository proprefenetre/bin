#! /usr/bin/env bash

wid=$(bspc query -N -n)

winmove () {
    xdotool windowmove --sync $wid $1 $2
}

unset screenx screeny
eval $(xdpyinfo | sed -n -e 's/^ \+dimensions: \+\([0-9]\+\)x\([0-9]\+\).*/screenx=\1; screeny=\2/p')

unset windowx windowy
eval $(xwininfo -id $wid|
sed -n -e "s/^ \+Width: \+\([0-9]\+\).*/windowx=\1/p" \
       -e "s/^ \+Height: \+\([0-9]\+\).*/windowy=\1/p" )

CENTER_X=$(echo "($screenx - $windowx)/2" | bc)
CENTER_Y=$(echo "($screeny - $windowy)/2" | bc)
LEFT=3
RIGHT=$(( screenx - windowx - 3 ))
UPPER=3
LOWER=$(( screeny - windowy - 3 ))

case "$1" in
    -ul)
	    winmove $LEFT $UPPER 
	    ;;
    -ll)
	    winmove $LEFT $LOWER
	    ;;
    -ur)
        winmove $RIGHT $UPPER
	    ;;
    -lr)
        winmove $RIGHT $LOWER
	    ;;
    -c | --center)
	    winmove $CENTER_X $CENTER_Y
	    ;;
    -u | --up)
        winmove $CENTER_X $UPPER
        ;;
    -d | --down)
        winmove $CENTER_X $LOWER
        ;;
    -l | --left)
        winmove $UPPER $CENTER_Y
        ;;
    -r | --right)
        winmove $RIGHT $CENTER_Y
        ;;
    -n | --custom ) 
        winmove $1 $2
        ;;
    -s | --show )
        echo "x: $windowx"
        echo "y: $windowy"
        ;;
esac
