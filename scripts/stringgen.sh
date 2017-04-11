#!/bin/bash

test "$1" = "" && echo "Please specify a length" || { 
head /dev/urandom | tr -dc '[:xdigit:]' | head -c $1 | pbcopy
echo
echo $(pbpaste) has been copied to your clipboard
echo
}