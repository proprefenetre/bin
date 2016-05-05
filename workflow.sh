#!/bin/bash

WFDIR=~/projects/workflow/files
MKFILE=Makefile
CRSETTINGS=pandoc-crossref-settings.yaml
GIGNORE=.gitignore
TEMPLATE=project.md
REFS=refs.bib

[[ ! -d .git ]] && git init

cp -r $WFDIR/* .

mv project.md ${PWD##*/}.md
