#! /usr/bin/env bash

# make a copy of the remind script, because the webdav mount depends too much
# on an internet connection to be reliable for symlinking

while true; do
    unison reminders -batch 1&>2
    sleep 10s
done
