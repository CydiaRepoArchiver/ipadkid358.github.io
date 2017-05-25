#!/bin/bash

p="/var/mobile/Library/Application Support/Flex3/patches.plist"
k=0
while ((k > -1))
do
echo " $k:  $(plutil -key patches -key $k -key name "$p")"
k=$((k+1))
test "$(plutil -key patches -key $k "$p" 2> /dev/null)" || k=-1 
done
echo Please type a number
read n
S=Sandbox
test -d $S && echo $S exists, exiting && exit
mkdir $S
r=$(echo $(plutil -key patches -key $n -key name "$p") | tr -dc qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890)
e=1
while test -d $S/$r
do
e=$((e+1))
r="$r"c
done
mkdir $S/$r
b=$(plutil -key patches -key $n -key appIdentifier "$p")
test "$b" = "com.flex.systemwide" && b="com.apple.UIKit"
echo "{ Filter = { Bundles = ( \"$b\" ); }; }" > $S/"$r"/"$r".plist
f=0
while ((f > -1))
do
echo "%hook $(plutil -key patches -key $n -key units -key $f -key methodObjc -key className "$p")" >>  $S/"$r"/Tweak.xm
test "$(plutil -key patches -key $n -key units -key $f -key methodObjc -key displayName "$p" | tr -cd ')' 2> /dev/null)" = ")" && {
echo "$(plutil -key patches -key $n -key units -key $f -key methodObjc -key displayName "$p") {" >>  $S/"$r"/Tweak.xm
}
test "$(plutil -key patches -key $n -key units -key $f -key methodObjc -key displayName "$p" | tr -cd ')' 2> /dev/null)" != ")" && {
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
test "$(plutil -key patches -key $n -key units -key $f -key overrides -key 0 -key argument "$p" 2> /dev/null)" != "0" && {
test "$(plutil -key patches -key $n -key units -key $f -key overrides -key $a -key value -key value "$p")" = "(FLNULL)" && { 
echo "arg$(plutil -key patches -key $n -key units -key $f -key overrides -key $a -key argument "$p") = nil;" >> $S/"$r"/Tweak.xm 
} || {
test "$(plutil -key patches -key $n -key units -key $f -key overrides -key $a -key value -key value "$p" | cut -c-8)" = "FLcolor:" && {
echo "arg$(plutil -key patches -key $n -key units -key $f -key overrides -key $a -key argument "$p") = [UIColor colorWithRed:$(plutil -key patches -key $n -key units -key $f -key overrides -key $a -key value -key value "$p" | cut -c9- | cut -d "," -f1).0/255.0 green:$(plutil -key patches -key $n -key units -key $f -key overrides -key $a -key value -key value "$p" | cut -c9- | cut -d "," -f2).0/255.0 blue:$(plutil -key patches -key $n -key units -key $f -key overrides -key $a -key value -key value "$p" | cut -c9- | cut -d "," -f3).0/255.0 alpha:$(plutil -key patches -key $n -key units -key $f -key overrides -key $a -key value -key value "$p" | cut -c9- | cut -d "," -f4).0/255.0];" >> $S/"$r"/Tweak.xm
U=1
} || { 
echo "arg$(plutil -key patches -key $n -key units -key $f -key overrides -key $a -key argument "$p") = $(plutil -key patches -key $n -key units -key $f -key overrides -key $a -key value -key value "$p");" >> $S/"$r"/Tweak.xm
			}
		}
	}
}
a=$((a+1))
test "$(plutil -key patches -key $n -key units -key $f -key overrides -key $a -key value -key value "$p" 2> /dev/null)" || a=-1
done

test "$(plutil -key patches -key $n -key units -key $f -key overrides -key 0 -key argument "$p" 2> /dev/null)" = "0" && {
test "$(plutil -key patches -key $n -key units -key $f -key overrides -key 0 -key value -key value "$p")" = "(FLNULL)" && { 
echo "return nil;" >> $S/"$r"/Tweak.xm 
}
test "$(plutil -key patches -key $n -key units -key $f -key overrides -key 0 -key value -key value "$p")" = "(FLNULL)" || {
test "$(plutil -key patches -key $n -key units -key $f -key overrides -key $a -key value -key value "$p" | cut -c-8)" = "FLcolor:" && {
echo "return [UIColor colorWithRed:$(plutil -key patches -key $n -key units -key $f -key overrides -key $a -key value -key value "$p" | cut -c9- | cut -d "," -f1).0/255.0 green:$(plutil -key patches -key $n -key units -key $f -key overrides -key $a -key value -key value "$p" | cut -c9- | cut -d "," -f2).0/255.0 blue:$(plutil -key patches -key $n -key units -key $f -key overrides -key $a -key value -key value "$p" | cut -c9- | cut -d "," -f3).0/255.0 alpha:$(plutil -key patches -key $n -key units -key $f -key overrides -key $a -key value -key value "$p" | cut -c9- | cut -d "," -f4).0/255.0];" >> $S/"$r"/Tweak.xm
U=1
     }
}
test "$(plutil -key patches -key $n -key units -key $f -key overrides -key 0 -key value -key value "$p")" = "(FLNULL)" || {
test "$(plutil -key patches -key $n -key units -key $f -key overrides -key $a -key value -key value "$p" | cut -c-8)" = "FLcolor:" || { 
echo "return $(plutil -key patches -key $n -key units -key $f -key overrides -key 0 -key value -key value "$p");" >> $S/"$r"/Tweak.xm
		}
	}
}
test "$(plutil -key patches -key $n -key units -key $f -key overrides -key 0 -key argument "$p" 2> /dev/null)" = "0" || { 
test "$(plutil -key patches -key $n -key units -key $f -key methodObjc -key displayName "$p" | cut -c2-7)" = "(void)" && echo "%orig;" >> $S/"$r"/Tweak.xm || echo "return %orig;" >> $S/"$r"/Tweak.xm 
}
echo "}" >>  $S/"$r"/Tweak.xm
echo "%end" >>  $S/"$r"/Tweak.xm
f=$((f+1))
test "$(plutil -key patches -key $n -key units -key $f "$p" 2> /dev/null)" || f=-1
done
echo "include \$(THEOS)/makefiles/common.mk" > $S/"$r"/Makefile
echo "TWEAK_NAME = $r" >> $S/"$r"/Makefile
echo "$r"_FILES = Tweak.xm >> $S/"$r"/Makefile
test "$U" = "1" && echo "$r"_FRAMEWORKS = UIKit >> $S/"$r"/Makefile
echo "include \$(THEOS_MAKE_PATH)/tweak.mk" >> $S/"$r"/Makefile
echo "Package: com.$(plutil -key patches -key $n -key author "$p").$(echo $(plutil -key patches -key $n -key name "$p") | tr -dc qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890)" > $S/"$r"/control
echo "Name: $(plutil -key patches -key $n -key name "$p" | tr -dc "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890 -")" >> $S/"$r"/control
echo "Depends: mobilesubstrate" >> $S/"$r"/control
echo "Version: 0.0.$e" >> $S/"$r"/control
echo "Architecture: iphoneos-arm" >> $S/"$r"/control
echo -n "Description:" >> $S/"$r"/control
plutil -key patches -key $n -key cloudDescription "$p" | while read v
do
echo " $v" >> $S/"$r"/control
done
echo "Maintainer: ipad_kid <ipadkid358@gmail.com>" >> $S/"$r"/control
echo "Author: $(plutil -key patches -key $n -key author "$p" | tr -dc [:alnum:])" >> $S/"$r"/control
echo "Homepage: ./index.html" >> $S/"$r"/control
echo "Section: Tweaks" >> $S/"$r"/control
