#!/bin/bash

S=Sandbox

p="/var/mobile/Library/Application Support/Flex3/patches.plist"
n=0
test -d $S && echo $S exists, exiting && exit
mkdir $S
while ((n > -1))
do
r=$(echo $(plutil -key patches -key $n -key name "$p") | tr -dc [:alnum:])
mkdir $S/$r
b=$(plutil -key patches -key $n -key appIdentifier "$p")

# Check Flex handling for this
test "$b" = "com.flex.systemwide" && b="com.apple.UIKit" && echo Package labeled for \"system wide\", this has be evaluated, but please be cautious \("$r"\)
echo "{ Filter = { Bundles = ( \"$b\" ); }; }" > $S/"$r"/"$r".plist
f=0
while ((f > -1))
do
echo "%hook $(plutil -key patches -key $n -key units -key $f -key methodObjc -key className "$p")" >>  $S/"$r"/Tweak.xm
test "$(plutil -key patches -key $n -key units -key $f -key methodObjc -key displayName "$p" | cut -c2-7)" = "(void)" && {
test "$(plutil -key patches -key $n -key units -key $f -key methodObjc -key displayName "$p" | tr -cd ')')" = ")" && {
echo "$(plutil -key patches -key $n -key units -key $f -key methodObjc -key displayName "$p") {" >>  $S/"$r"/Tweak.xm
}
test "$(plutil -key patches -key $n -key units -key $f -key methodObjc -key displayName "$p" | tr -cd ')')" != ")" && {
echo -n "$(plutil -key patches -key $n -key units -key $f -key methodObjc -key displayName "$p" | cut -d ")" -f1-2)" >> $S/"$r"/Tweak.xm
echo -n ")arg1" >> $S/"$r"/Tweak.xm
z=2
test "$(plutil -key patches -key $n -key units -key $f -key methodObjc -key displayName "$p" | cut -d ")" -f$((z+1)) 2> /dev/null)" = "" && z=0
while ((z > 0))
do
echo -n "$(plutil -key patches -key $n -key units -key $f -key methodObjc -key displayName "$p" | cut -d ")" -f$((z+1)))" >> $S/"$r"/Tweak.xm
echo -n ")arg$z" >> $S/"$r"/Tweak.xm
z=$((z+1))
test "$(plutil -key patches -key $n -key units -key $f -key methodObjc -key displayName "$p" | cut -d ")" -f$((z+1)) 2> /dev/null)" = "" && z=0
done
echo " {" >>  $S/"$r"/Tweak.xm
}
a=0
while ((a > -1))
do
test "$(plutil -key patches -key $n -key units -key $f -key overrides -key $a -key value -key value "$p" 2> /dev/null)" && {
test "$(plutil -key patches -key $n -key units -key $f -key overrides -key $a -key value -key value "$p")" = "(FLNULL)" && echo "arg$(plutil -key patches -key $n -key units -key $f -key overrides -key $a -key argument "$p") = nil;" >> $S/"$r"/Tweak.xm || echo "arg$(plutil -key patches -key $n -key units -key $f -key overrides -key $a -key argument "$p") = $(plutil -key patches -key $n -key units -key $f -key overrides -key $a -key value -key value "$p");" >> $S/"$r"/Tweak.xm
}
a=$((a+1))
test "$(plutil -key patches -key $n -key units -key $f -key overrides -key $a -key value -key value "$p" 2> /dev/null)" || a=-1
done
echo "%orig;" >> $S/"$r"/Tweak.xm 
} 
test "$(plutil -key patches -key $n -key units -key $f -key methodObjc -key displayName "$p" | cut -c2-7)" = "(void)" || {
test "$(plutil -key patches -key $n -key units -key $f -key methodObjc -key displayName "$p" | cut -c2-5)" != "(id)" && { 
echo "$(plutil -key patches -key $n -key units -key $f -key methodObjc -key displayName "$p") {" >>  $S/"$r"/Tweak.xm
echo "return $(plutil -key patches -key $n -key units -key $f -key overrides -key 0 -key value -key value "$p");" >> $S/"$r"/Tweak.xm
   }
} 
test "$(plutil -key patches -key $n -key units -key $f -key methodObjc -key displayName "$p" | cut -c2-5)" = "(id)" && { 
test "$(plutil -key patches -key $n -key units -key $f -key methodObjc -key displayName "$p" | tr -cd ')')" = ")" && {
echo "$(plutil -key patches -key $n -key units -key $f -key methodObjc -key displayName "$p") {" >>  $S/"$r"/Tweak.xm
}
test "$(plutil -key patches -key $n -key units -key $f -key methodObjc -key displayName "$p" | tr -cd ')')" != ")" && {
echo -n "$(plutil -key patches -key $n -key units -key $f -key methodObjc -key displayName "$p" | cut -d ")" -f1-2)" >> $S/"$r"/Tweak.xm
echo -n ")arg1" >> $S/"$r"/Tweak.xm
z=2
test "$(plutil -key patches -key $n -key units -key $f -key methodObjc -key displayName "$p" | cut -d ")" -f$((z+1)) 2> /dev/null)" = "" && z=0
while ((z > 0))
do
echo -n "$(plutil -key patches -key $n -key units -key $f -key methodObjc -key displayName "$p" | cut -d ")" -f$((z+1)))" >> $S/"$r"/Tweak.xm
echo -n ")arg$z" >> $S/"$r"/Tweak.xm
z=$((z+1))
test "$(plutil -key patches -key $n -key units -key $f -key methodObjc -key displayName "$p" | cut -d ")" -f$((z+1)) 2> /dev/null)" = "" && z=0
done
echo " {" >>  $S/"$r"/Tweak.xm
}
test "$(plutil -key patches -key $n -key units -key $f -key overrides -key 0 -key value -key value "$p")" = "(FLNULL)" && echo "return nil;" >> $S/"$r"/Tweak.xm || {
a=0
while ((a > -1))
do
test "$(plutil -key patches -key $n -key units -key $f -key overrides -key $a -key value -key value "$p")" && {
test "$(plutil -key patches -key $n -key units -key $f -key overrides -key $a -key value -key value "$p")" = "(FLNULL)" && echo "arg$(plutil -key patches -key $n -key units -key $f -key overrides -key $a -key argument "$p") = nil;" >> $S/"$r"/Tweak.xm || echo "arg$(plutil -key patches -key $n -key units -key $f -key overrides -key $a -key argument "$p") = $(plutil -key patches -key $n -key units -key $f -key overrides -key $a -key value -key value "$p");" >> $S/"$r"/Tweak.xm
}
a=$((a+1))
test "$(plutil -key patches -key $n -key units -key $f -key overrides -key $a -key value -key value "$p" 2> /dev/null)" || a=-1
done
echo "%orig;" >> $S/"$r"/Tweak.xm 
   }
} 
echo "}" >>  $S/"$r"/Tweak.xm
echo "%end" >>  $S/"$r"/Tweak.xm
f=$((f+1))
test "$(plutil -key patches -key $n -key units -key $f "$p" 2> /dev/null)" || f=-1
done
echo "include \$(THEOS)/makefiles/common.mk" > $S/"$r"/Makefile
echo "TWEAK_NAME = $r" >> $S/"$r"/Makefile
echo "$r"_FILES = Tweak.xm >> $S/"$r"/Makefile
echo "include \$(THEOS_MAKE_PATH)/tweak.mk" >> $S/"$r"/Makefile
echo "Package: com.$(plutil -key patches -key $n -key author "$p").$r" > $S/"$r"/control
echo "Name: $(plutil -key patches -key $n -key name "$p")" >> $S/"$r"/control
echo "Depends: mobilesubstrate" >> $S/"$r"/control
echo "Version: 0.0.1" >> $S/"$r"/control
echo "Architecture: iphoneos-arm" >> $S/"$r"/control
echo -n "Description:" >> $S/"$r"/control
plutil -key patches -key $n -key cloudDescription "$p" | while read v
do
echo " $v" >> $S/"$r"/control
done
echo "Maintainer: ipad_kid <ipadkid358@gmail.com>" >> $S/"$r"/control
echo "Author: $(plutil -key patches -key $n -key author "$p" | tr -dc [:alnum:])" >> $S/"$r"/control
echo "Section: Tweaks" >> $S/"$r"/control
n=$((n+1))
test "$(plutil -key patches -key $n -key name "$p" 2> /dev/null)" || n=-1
done
