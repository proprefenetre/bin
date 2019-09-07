#!/usr/local/bin/fish

# First clone the latest dev version ("--depth 1" = exclude history)
rm -rf latest
git clone --depth 1 https://github.com/emacs-mirror/emacs.git latest

# install dependencies if necessary
brew install autoconf automake gnutls pkg-config texinfo

# fix texinfo path
set -x fish_user_paths /usr/local/opt/texinfo/bin $fish_user_paths

cd latest
./autogen.sh

./configure  --with-imagemagick --with-ns --with-modules
# ./configure --with-ns --with-modules --with-imagemagick --with-xpm --with-jpeg --with-tiff --with-gif --with-png --with-rsvg --with-json --with-xft --with-harfbuzz --with-libotf

make
make install

cd ./doc/emacs
make emacs.html

cd ../lispref
make elisp.html
