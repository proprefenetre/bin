#!/bin/bash

# strict mode:
set -e -u

BACKUPDIR=$HOME/files/backups

cp $HOME/.mozilla/firefox/03xmgf6t.default/bookmarks.html $BACKUPDIR/bookmarks_$(date +%d-%m-%y).html
