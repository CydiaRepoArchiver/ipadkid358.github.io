#!/bin/bash

cp "/var/mobile/Library/Application Support/Flex3/patches.plist" "/var/mobile/Documents/Flex/patches.plist"
test -d Patches && rm -rf Patches
mkdir Patches
grep "downloadDate" "/var/mobile/Documents/Flex/patches.plist" -A3 | grep "<string>" | cut -c12- | cut -d "<" -f1 | while read m
do
r=$(echo $m | tr -dc [:alnum:])
mkdir Patches/"$r"
t=$(FlexConverter "$m" | grep "bundle ID" | cut -d ":" -f 2 | tr -d [:space:])
test "$t" = "com.flex.systemwide" && t="com.apple.UIKit"
FlexConverter "$m" | tail -n+11 | grep -v "Copied to clipboard." | grep -v "Paste this in your tweak file(usually Tweak.xm)." > Patches/"$r"/Tweak.xm
echo "include \$(THEOS)/makefiles/common.mk" > Patches/"$r"/Makefile
echo "TWEAK_NAME = $r" >> Patches/"$r"/Makefile
echo "$r"_FILES = Tweak.xm >> Patches/"$r"/Makefile
echo "include \$(THEOS_MAKE_PATH)/tweak.mk" >> Patches/"$r"/Makefile
echo "{ Filter = { Bundles = ( \"$t\" ); }; }" > Patches/"$r"/"$r".plist
echo "Package: com.sinfool.$r" > Patches/"$r"/control
echo "Name: $m" >> Patches/"$r"/control
echo "Depends: mobilesubstrate" >> Patches/"$r"/control
echo "Version: 0.0.1" >> Patches/"$r"/control
echo "Architecture: iphoneos-arm" >> Patches/"$r"/control
echo "Description: This is a work in progress" >> Patches/"$r"/control
echo "Maintainer: ipad_kid <ipadkid358@gmail.com>" >> Patches/"$r"/control
echo "Author: Sinfool" >> Patches/"$r"/control
echo "Section: Tweaks" >> Patches/"$r"/control
test "$1" = "make" && {
make -C Patches/"$r" package
rm -r Patches/"$r"/.theos
rm -r Patches/"$r"/obj
}
done
