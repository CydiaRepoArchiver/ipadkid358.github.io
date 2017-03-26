#!/bin/bash

test "$1" = "" && {
echo Please rerun this script with a package id
exit
} || {
test "$1" != "$(grep "Package: " /var/lib/dpkg/status | cut -c 10- | grep -v "gsc." | grep $1)" && { 
echo Please rerun this script with a valid package id
echo You may have meant: 
grep "Package: " /var/lib/dpkg/status | cut -c 10- | grep -v "gsc." | grep $1
exit
} || {
test -d redebs || mkdir redebs
cd redebs
mkdir sandbox
mkdir sandbox/DEBIAN
for t in `ls /var/lib/dpkg/info | grep $1 | grep -v "$1".list | grep -v "$1".md5sums | cut -c "$(expr "$(echo -n $1 | wc -c)" + 2)"-`
do
cp /var/lib/dpkg/info/$1.$t sandbox/DEBIAN/$t
done
grep -A 20 "Package: $1" /var/lib/dpkg/status | grep -v "Status: " | awk '/^$/{exit} {print $0}' > sandbox/DEBIAN/control
for t in `cat /var/lib/dpkg/info/"$1".list | tail -n+2 | sed  's .  '`
do
test -d /$t && mkdir sandbox/$t
test -f /$t && cp /$t sandbox/$t
done
dpkg-deb -b sandbox "$1".deb > /dev/null
tput bold
echo Success!! The deb should be located at $(pwd)/$1.deb
tput sgr0
rm -rf sandbox
exit
}
}