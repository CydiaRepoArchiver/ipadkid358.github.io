#!/bin/bash

## --- Documentation and notes ---
## This will take all of your currently installed patches and do its best to turn them into tweaks 
## Intended to be compiled with Theos
## Changes the S value to directory you want (NOT ONE THAT ALREADY EXISTS)
## Don't touch the p value, this is only available for debugging purposes only
## This is still in beta, you'll notice there are a couple TODOs around, please contact me at https://ipadkid358.github.io/contact.html if you have any recommendations 
## Once I feel it's ready enough, I'll add a build feature to mass build all of these tweaks
## Please use with care, thank you
## --- End of documentation and notes ---

S=Sandbox

## Reminder to change above S value

p="/var/mobile/Library/Application Support/Flex3/patches.plist"
n=0
test -d $S && echo $S exists, exiting && exit
mkdir $S
while ((n > -1))
do
r=$(echo $(plutil -key patches -key $n -key name "$p") | tr -dc [:alnum:])
mkdir $S/$r
b=$(plutil -key patches -key $n -key appIdentifier "$p")
test "$b" = "com.flex.systemwide" && b="com.apple.UIKit"
echo "{ Filter = { Bundles = ( \"$b\" ); }; }" > $S/"$r"/"$r".plist
f=0
while ((f > -1))
do
echo "%hook $(plutil -key patches -key $n -key units -key $f -key methodObjc -key className "$p")" >>  $S/"$r"/Tweak.xm
echo "$(plutil -key patches -key $n -key units -key $f -key methodObjc -key displayName "$p")arg {" >>  $S/"$r"/Tweak.xm

test "$(plutil -key patches -key $n -key units -key $f -key methodObjc -key displayName "$p" | cut -c2-7)" = "(bool)" && echo "return $(test "$(plutil -key patches -key $n -key units -key $f -key overrides -key 0 -key value -key value "$p")" = "1" && echo TRUE || echo FALSE);" >>  $S/"$r"/Tweak.xm 

test "$(plutil -key patches -key $n -key units -key $f -key methodObjc -key displayName "$p" | cut -c2-12)" = "(long long)" && echo "return $(plutil -key patches -key $n -key units -key $f -key overrides -key 0 -key value -key value "$p");" >>  $S/"$r"/Tweak.xm

test "$(plutil -key patches -key $n -key units -key $f -key methodObjc -key displayName "$p" | cut -c2-6)" = "(int)" && echo "return $(plutil -key patches -key $n -key units -key $f -key overrides -key 0 -key value -key value "$p");" >>  $S/"$r"/Tweak.xm

test "$(plutil -key patches -key $n -key units -key $f -key methodObjc -key displayName "$p" | cut -c2-21)" = "(unsigned long long)" && echo "return $(plutil -key patches -key $n -key units -key $f -key overrides -key 0 -key value -key value "$p");" >>  $S/"$r"/Tweak.xm

test "$(plutil -key patches -key $n -key units -key $f -key methodObjc -key displayName "$p" | cut -c2-15)" = "(unsigned int)" && echo "return $(plutil -key patches -key $n -key units -key $f -key overrides -key 0 -key value -key value "$p");" >>  $S/"$r"/Tweak.xm 

## TODO - Increase handling for multiple values
test "$(plutil -key patches -key $n -key units -key $f -key methodObjc -key displayName patches.plist | cut -c2-7)" = "(void)" && {

test "$(plutil -key patches -key $n -key units -key $f -key methodObjc -key displayName patches.plist | cut -d ":" -f2 | cut -c1-6)" = "(bool)" && {
$(test "$(plutil -key patches -key $n -key units -key $f -key overrides -key 0 -key value -key value "$p")" = "1" && echo "%orig(TRUE);" >>  $S/"$r"/Tweak.xm || echo "%orig(FALSE);" >>  $S/"$r"/Tweak.xm)
} || {
test $(plutil -key patches -key $n -key units -key $f -key overrides -key 0 -key value -key value patches.plist 2> /dev/null) && echo "%orig($(plutil -key patches -key $n -key units -key $f -key overrides -key 0 -key value -key value patches.plist));" >>  $S/"$r"/Tweak.xm
}
test "$(plutil -key patches -key $n -key units -key $f -key methodObjc -key displayName patches.plist | tr -cd ':' | wc -c)" != "1" && echo Possible error detected at $r for $(plutil -key patches -key $n -key units -key $f -key methodObjc -key displayName patches.plist) && echo && echo "// Possible error detected" >>  $S/"$r"/Tweak.xm
}
test "$(plutil -key patches -key $n -key units -key $f -key methodObjc -key displayName patches.plist | cut -d ":" -f2 | cut -c1-4)" = "(id)" && echo Possible error detected at $r for $(plutil -key patches -key $n -key units -key $f -key methodObjc -key displayName patches.plist) && echo && echo "// Possible error detected" >>  $S/"$r"/Tweak.xm

## TODO - Increase handling for multiple values
## TODO - Fix handling for nil
test "$(plutil -key patches -key $n -key units -key $f -key methodObjc -key displayName patches.plist | cut -c2-5)" = "(id)" && { 
test $(plutil -key patches -key $n -key units -key $f -key overrides -key 0 -key value -key value patches.plist 2> /dev/null) && echo "%orig($(plutil -key patches -key $n -key units -key $f -key overrides -key 0 -key value -key value patches.plist));" >>  $S/"$r"/Tweak.xm
echo Possible error detected at $r for $(plutil -key patches -key $n -key units -key $f -key methodObjc -key displayName patches.plist) && echo && echo "// Possible error detected" >>  $S/"$r"/Tweak.xm
}

test "$(plutil -key patches -key $n -key units -key $f -key methodObjc -key prefix "$p")" = "+" && echo Possible error detected at $r for $(plutil -key patches -key $n -key units -key $f -key methodObjc -key displayName patches.plist) && echo && echo "// Possible error detected" >>  $S/"$r"/Tweak.xm

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
