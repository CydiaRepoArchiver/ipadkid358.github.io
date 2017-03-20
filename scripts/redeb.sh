#!/bin/bash

mkdir sandbox
mkdir sandbox/DEBIAN
ls /var/lib/dpkg/info | grep $1 | grep -v "$1".list | grep -v "$1".md5sums > script.txt
STR="$(echo -n $1 | wc -c)"
STRN="$(expr $STR + 2)"
cut -c $STRN- script.txt > scripts.txt
rm script.txt
filecontent=(`cat scripts.txt`)
for t in "${filecontent[@]}"
do
cp /var/lib/dpkg/info/$1.$t sandbox/DEBIAN/$t
done
rm scripts.txt
cat /var/lib/dpkg/status > allpacks.txt
grep -A 20 "Package: $1" allpacks.txt | grep -v Status: > mypack.txt
rm allpacks.txt
awk -v RS= '{print > ("control" NR)}' mypack.txt
mv control1 sandbox/DEBIAN/control
rm mypack.txt
rm control*
cat /var/lib/dpkg/info/"$1".list | tail -n+2 | sed  's .  ' > tmp.txt
filecontent=(`cat tmp.txt`)
for t in "${filecontent[@]}"
do
test -d /$t && mkdir sandbox/$t
test -f /$t && cp /$t sandbox/$t
done
rm tmp.txt
dpkg-deb -b sandbox "$1".deb > /dev/null
tput bold
echo Success!!
tput sgr0
rm -rf sandbox