#! /usr/bin/env bash

# https://wiki.archlinux.org/index.php/Convert_FLAC_to_MP3

parallel ffmpeg -i {} -qscale:a 0 {.}.mp3 ::: ./*.flac
