#!/bin/bash

test "$1" = "" && { echo Please rerun this script with a package id; }
test "$1" != "" && {
mkdir redebs
cd redebs
mkdir sandbox
mkdir sandbox/DEBIAN
for t in `ls /var/lib/dpkg/info | grep $1 | grep -v "$1".list | grep -v "$1".md5sums | cut -c "$(expr "$(echo -n $1 | wc -c)" + 2)"-`
do
cp /var/lib/dpkg/info/$1.$t sandbox/DEBIAN/$t
done
cat /var/lib/dpkg/status | grep -A 20 "Package: $1" | grep -v "Status: " | awk '/^$/{exit} {print $0}' > sandbox/DEBIAN/control
for t in `cat /var/lib/dpkg/info/"$1".list | tail -n+2 | sed  's .  '`
do
test -d /$t && mkdir sandbox/$t
test -f /$t && cp /$t sandbox/$t
done
dpkg-deb -b sandbox "$1".deb > /dev/null
tput bold
echo Success!!
echo The deb should be found in a folder called redebs
tput sgr0
rm -rf sandbox 
}