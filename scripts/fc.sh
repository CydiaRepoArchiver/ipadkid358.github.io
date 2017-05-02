#!/bin/bash

S=Sandbox
p="/var/mobile/Library/Application Support/Flex3/patches.plist"
n=0
rm -r $S
mkdir $S
while ((n > -1))
do
r=$(echo $(plutil -key patches -key $n -key name "$p") | tr -dc [:alnum:])
mkdir $S/$r
b=$(plutil -key patches -key $n -key appIdentifier "$p")
test "$b" = "com.flex.systemwide" && b="com.apple.UIKit"
echo "{ Filter = { Bundles = ( \"$b\" ); }; }" > $S/"$r"/"$r".plist
while ((f > -1))
do
echo "%hook $(plutil -key patches -key $n -key units -key $f -key methodObjc -key className "$p")" >>  $S/"$r"/Tweak.xm
echo "$(plutil -key patches -key $n -key units -key $f -key methodObjc -key displayName "$p") {" >>  $S/"$r"/Tweak.xm

## DO NOT TOUCH - EVALUATING 

test "$(plutil -key patches -key $n -key units -key $f -key methodObjc -key displayName "$p" | cut -c2-7)" = "(bool)" && echo "return $(test $(plutil -key patches -key $n -key units -key $f -key overrides -key 0 -key value -key value "$p") && echo TRUE || echo FALSE);" >>  $S/"$r"/Tweak.xm

test "$(plutil -key patches -key $n -key units -key $f -key methodObjc -key displayName "$p" | cut -c2-12)" = "(long long)" && echo "return $(plutil -key patches -key $n -key units -key $f -key overrides -key 0 -key value -key value "$p");" >>  $S/"$r"/Tweak.xm

test "$(plutil -key patches -key $n -key units -key $f -key methodObjc -key displayName "$p" | cut -c2-6)" = "(int)" && echo "return $(plutil -key patches -key $n -key units -key $f -key overrides -key 0 -key value -key value "$p");" >>  $S/"$r"/Tweak.xm

test "$(plutil -key patches -key $n -key units -key $f -key methodObjc -key displayName "$p" | cut -c2-21)" = "(unsigned long long)" && echo "return $(plutil -key patches -key $n -key units -key $f -key overrides -key 0 -key value -key value "$p");" >>  $S/"$r"/Tweak.xm

test "$(plutil -key patches -key $n -key units -key $f -key methodObjc -key displayName "$p" | cut -c2-15)" = "(unsigned int)" && echo "return $(plutil -key patches -key $n -key units -key $f -key overrides -key 0 -key value -key value "$p");" >>  $S/"$r"/Tweak.xm

test "$(plutil -key patches -key $n -key units -key $f -key methodObjc -key displayName patches.plist | cut -c2-7)" = "(void)" && { 
test $(plutil -key patches -key $n -key units -key $f -key overrides -key 0 -key value -key value patches.plist 2> /dev/null) && echo "%orig($(plutil -key patches -key $n -key units -key $f -key overrides -key 0 -key value -key value patches.plist));" >>  $S/"$r"/Tweak.xm
}

## END OF EVALUATION

echo "}" >>  $S/"$r"/Tweak.xm
echo "%end" >>  $S/"$r"/Tweak.xm
f=$((f+1))
test "$(plutil -key patches -key $n -key units -key $f "$p" 2> /dev/null)" || f=-1
done
f=0
echo "include \$(THEOS)/makefiles/common.mk" > $S/"$r"/Makefile
echo "TWEAK_NAME = $r" >> $S/"$r"/Makefile
echo "$r"_FILES = Tweak.xm >> $S/"$r"/Makefile
echo "include \$(THEOS_MAKE_PATH)/tweak.mk" >> $S/"$r"/Makefile
echo "Package: com.$(plutil -key patches -key $n -key author "$p").$r" > $S/"$r"/control
echo "Name: $(plutil -key patches -key $n -key name "$p")" >> $S/"$r"/control
echo "Depends: mobilesubstrate" >> $S/"$r"/control
echo "Version: 0.0.1" >> $S/"$r"/control
echo "Architecture: iphoneos-arm" >> $S/"$r"/control

## TODO - Fix description 
echo "Description: $(plutil -key patches -key $n -key cloudDescription "$p" | tr -dc [:print:])" >> $S/"$r"/control
echo "Maintainer: ipad_kid <ipadkid358@gmail.com>" >> $S/"$r"/control
echo "Author: $(plutil -key patches -key $n -key author "$p")" >> $S/"$r"/control
echo "Section: Tweaks" >> $S/"$r"/control
n=$((n+1))
test "$(plutil -key patches -key $n -key name "$p" 2> /dev/null)" || n=-1
done
