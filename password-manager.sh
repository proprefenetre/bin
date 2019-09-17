#! /usr/bin/env bash

cd ~/.password-store/
pass -c $(fd -t f -e ".gpg" -x bash -c 'printf "%s\n" "{.}"' | dmenu) >/dev/null 2>&1
