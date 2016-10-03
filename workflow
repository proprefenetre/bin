#!/bin/bash

WFDIR=~/projects/workflow/files
# MKFILE=Makefile
# CRSETTINGS=pandoc-crossref-settings.yaml
# GIGNORE=.gitignore
# TEMPLATE=project.md
# REFS=refs.bib


if [[ $# -eq 0 ]]; then
    echo "No arguments supplied" 
    exit 1
else
    [[ ! -d ./$1 ]] && mkdir -p ./$1
    cd ./$1
    [[ ! -d .git ]] && git init
    cp -r $WFDIR/* .
    mv project.md ${PWD##*/}.md
fi
