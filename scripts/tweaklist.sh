#!/bin/bash

test "$1" = "id" && {
grep "Package: " /var/lib/dpkg/status | cut -c 10- | grep -v "gsc."
} || { 
test "$1" = "name" && {
grep "Name: " /var/lib/dpkg/status | cut -c 7-
} || { 
echo
echo Please specify a name type
echo Either use id or name
tput bold
echo Example: ./tweaklist.sh id 
echo Example: ./tweaklist.sh name
tput sgr0
echo
}
}