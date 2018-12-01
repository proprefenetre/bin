#! /usr/bin/env bash

Clock () {
    DATETIME="$(date "+%a %d %b %H:%M")"
    echo "$DATETIME"
}

Battery () {
    if [[ -z "$(acpi --battery)" ]]; then
        CHARGE="NA"
    else
        CHARGE="$(acpi --battery | cut -d, -f2)%"
    fi

    echo "$CHARGE"
}

Ssid () {
    ~/bin/ssid
}

while true; do
    echo "S |$(Ssid)|$(Battery) | $(Clock) "
    sleep 3
done
