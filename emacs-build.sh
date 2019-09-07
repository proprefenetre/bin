#!/bin/bash

# Required dependencies after a clean install of macOS:
# brew install autoconf automake gnutls pkg-config texinfo

set -e #Exit when any command fails.

mkdir -pv ~/projects
rm -frv emacs-latest
git clone --depth 1 https://github.com/emacs-mirror/emacs.git emacs-latest # Latest dev version ("--depth 1" = exclude history)

echo "BUILD/AUTOGEN"
cd ~/projects/emacs-latest
./autogen.sh

echo "BUILD/CONFIGURE"
./configure #"--with-ns" is default on macOS

echo "BUILD/MAKE"
make

echo "Copy nextstep/Emacs.app to /Applications/"
make install

# rm -rfv /Applications/Emacs.app
# cp -Rv ./nextstep/Emacs.app /Applications/

echo "CREATE_DOC/MANUAL (at ~/projects/emacs-latest/doc/emacs/emacs.html)"
cd ./doc/emacs
make emacs.html

echo "CREATE_DOC/ELISP_REF (at ~/projects/emacs-latest/doc/lispref/elisp.html)"
cd ../lispref
make elisp.html
