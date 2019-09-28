#! /usr/bin/env bash

xdotool type $(cat .macros | dmenu "$@") 
