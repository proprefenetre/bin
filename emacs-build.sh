#!/bin/bash

set -e

mkdir -pv 
rm -frv emacs-latest
git clone --depth 1 https://github.com/emacs-mirror/emacs.git emacs-latest

cd emacs-latest
./autogen.sh
./configure
make
make install
cd ./doc/emacs
make emacs.html
cd ../lispref
make elisp.html
