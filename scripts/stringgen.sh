#!/bin/bash

m=$(echo "$1" | tr -dc '[:digit:]')
test "$m" = "" && {
echo "Length specified is not a number, please specify a length"
read d
l=$(echo "$d" | tr -dc '[:digit:]')
test "$l" = "" && echo Length specified is not a number, exiting || {
head /dev/urandom | tr -dc '[:xdigit:]' | head -c $l | pbcopy
echo
echo $(pbpaste) has been copied to your clipboard
echo
   }
} || {
head /dev/urandom | tr -dc '[:xdigit:]' | head -c $m | pbcopy
echo
echo $(pbpaste) has been copied to your clipboard
echo
}