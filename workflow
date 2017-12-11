#!/bin/bash

WFDIR=~/Projects/workflow/files
WFREPO=https://github.com/proprefenetre/workflow

# MKFILE=Makefile
# CRSETTINGS=pandoc-crossref-settings.yaml
# GIGNORE=.gitignore
# TEMPLATE=project.md
# REFS=refs.bib


if [[ $# -eq 0 ]]; then
    echo "No arguments supplied" 
    exit 1
else
    if [[ ! -d "$WFDIR" ]]; then
        cd ~/Projects
        git clone "$WFREPO"
        cd -
    fi
    [[ ! -d ./$1 ]] && mkdir -p ./$1
    cd ./$1
    [[ ! -d .git ]] && git init
    cp -r $WFDIR/* .
    mv project.md ${PWD##*/}.md
fi
