#!/bin/bash

test $UID -ne 0 && {
echo Please run as root to avoid errors
} || {
test "$1" = "" && {
echo Please rerun this script with a package id
} || {
test "$1" != "$(dpkg --get-selections | grep -v "deinstall" | grep -v "gsc." | cut -f1 | grep $1)" && { 
echo
tput bold
echo Please rerun this script with a valid package id
echo ————————————————————————
echo You may have meant: 
tput sgr0 
dpkg --get-selections | grep -v "deinstall" | grep -v "gsc." | cut -f1 | grep $1
echo
} || {
test -d redebs || mkdir redebs
cd redebs
mkdir sandbox
mkdir sandbox/DEBIAN
dpkg-query --control-list $1 | grep -v "md5sums" | while read t
do
cp /var/lib/dpkg/info/$1.$t sandbox/DEBIAN/$t
done
dpkg-query -s $1 | grep -v "Status: " > sandbox/DEBIAN/control
dpkg-query -L $1 | tail -n+2 | while read t
do
test -d $t && mkdir sandbox$t
test -f $t && cp $t sandbox$t
done
dpkg-deb -b sandbox "$1".deb > /dev/null
tput bold
echo Success!! The deb should be located at $(pwd)/$1.deb
tput sgr0
rm -rf sandbox
      }
   }
}