#!/usr/bin/env bash

# call with a prompt string or use a default
read -r -p "${1:-Proceed?} [y/n] " response
case $response in
    [yY][eE][sS]|[yY]) 
        true
        ;;
    *)
        exit 1
        ;;
esac

