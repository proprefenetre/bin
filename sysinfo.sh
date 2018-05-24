#! /usr/bin/env bash

Clock () {
    DATETIME="$(date "+%a %H:%M")"
    echo "$DATETIME"
}

Battery () {
    if [[ -z "$(acpi --battery)" ]]; then
        CHARGE="NA"
    else
        CHARGE="$(acpi --battery | cut -d, -f2)"
    fi

    echo "$CHARGE"
}


while true; do
    echo "S$(Battery)% | $(Clock) "
    sleep 1
done
