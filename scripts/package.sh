#!/bin/bash

{
ls $1 | while read d
do
p="$1"/"$d"
dpkg-deb -f $p 
echo "Filename: $p" 
echo "MD5sum: $(md5sum $p | cut -d " " -f1)" 
echo "Size: $(stat -c %s $p)"
echo
done
} | bzip2 -zc > Packages.bz2