#! /usr/bin/env bash

xdotool type $(gpg -d .macros.gpg | dmenu "$@") 
