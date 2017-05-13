#!/bin/bash

ls $1 | while read d
do
p="$1"/"$d"
dpkg-deb -f $p >> Packages
echo "Filename: $p" >> Packages
echo "MD5sum: $(md5sum $p | cut -d " " -f1)" >> Packages
echo "Size: $(stat -c %s $p)" >> Packages
echo >> Packages
done