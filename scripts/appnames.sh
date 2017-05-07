#!/bin/bash

exec 2> /dev/null
echo
while getopts "blduh" f
do
case $f in
b) b=1
echo Bundle selected
echo
;;
l) l=1
echo Location selected
echo
;;
d) d=1
echo Documents selected
echo
;;
u) u=1
echo URL Schemes selected
echo
;;
h)
echo "Usage: appnames.sh [OPTIONS]"
echo " OPTIONS:"
echo "   -b       Bundle provides the bundle ID of the app"
echo "   -l       Location provides the file path to the main folder of the app"
echo "   -d       Documents provides the file path for any files the app writes out (this is only guaranteed for sandboxed apps)"
echo "   -u       URL Scheme provides any valid protocols directing to the app"
echo
exit
;;
esac 
done

test "$d" = "1" && {
echo "App document locations are now being dumped"
TMP=$(mktemp)
ls /var/mobile/Containers/Data/Application | while read t
do
plutil -key MCMMetadataIdentifier  /var/mobile/Containers/Data/Application/"$t"/.com.apple.mobile_container_manager.metadata.plist >> $TMP
echo /var/mobile/Containers/Data/Application/"$t" >> $TMP
done
}
echo "All information will now be written to appnames.txt"
echo "Depending on how many apps you have, and what options are selected, this may take a long time, and your console will appear to hang, please do not close the console until you see the prompt that you are able to write again" 

exec > appnames.txt

ls /Applications | while read t
do
F=/Applications/"$t"/Info.plist
test "$(plutil -key CFBundleIcons $F)" && { 
test "$(plutil -key SBAppTags $F)" || { 
test "$(plutil -key CFBundleName $F)" && echo "Name: $(plutil -key CFBundleName $F)"
test "$(plutil -key CFBundleDisplayName $F)" && echo "Display Name: $(plutil -key CFBundleDisplayName $F)"
test "$(plutil -key CFBundleExecutable $F)" && echo "Executable Name: $(plutil -key CFBundleExecutable $F)"
test "$(plutil -key CFBundleIdentifier $F)" && { 
test "$b" = "1" && echo "Bundle ID: $(plutil -key CFBundleIdentifier $F)"
test "$u" = "1" && {
test "$(plutil -key CFBundleURLTypes $F)" && {
echo
n=0
while ((n > -1))
do
k=0
while ((k > -1))
do
echo "URL Scheme: $(plutil -key CFBundleURLTypes -key $n -key CFBundleURLSchemes -key $k $F)"
k=$((k+1))
test "$(plutil -key CFBundleURLTypes -key $n -key CFBundleURLSchemes -key $k $F)" || k=-1
done
n=$((n+1))
test "$(plutil -key CFBundleURLTypes -key $n $F)" || n=-1
done
   }
}
test "$l" = "1" && { 
echo
echo -n "Core File Location: "
echo /Applications/"$t"
}
test "$d" = "1" && {
test "$(grep -A1 $(plutil -key CFBundleIdentifier $F) $TMP)" != "" && {
echo
echo -n "Documents location: "
grep -x -A1 $(plutil -key CFBundleIdentifier $F) $TMP | grep "/var/mobile/Containers/Data/Application"
   }
}
echo
echo ———————
echo
      }
   }
}
done

ls /var/containers/Bundle/Application/ | while read t
do
R=/var/containers/Bundle/Application/"$t"/*.app
F=$R/Info.plist
test "$(plutil -key CFBundleName $F)" && echo "Name: $(plutil -key CFBundleName $F)"
test "$(plutil -key CFBundleDisplayName $F)" && echo "Display Name: $(plutil -key CFBundleDisplayName $F)"
test "$(plutil -key CFBundleExecutable $F)" && echo "Executable Name: $(plutil -key CFBundleExecutable $F)"
test "$(plutil -key CFBundleIdentifier $F)" && { 
test "$b" = "1" && echo "Bundle ID: $(plutil -key CFBundleIdentifier $F)"
test "$u" = "1" && {
test "$(plutil -key CFBundleURLTypes $F)" && {
echo
n=0
while ((n > -1))
do
k=0
while ((k > -1))
do
echo "URL Scheme: $(plutil -key CFBundleURLTypes -key $n -key CFBundleURLSchemes -key $k $F)"
k=$((k+1))
test "$(plutil -key CFBundleURLTypes -key $n -key CFBundleURLSchemes -key $k $F)" || k=-1
done
n=$((n+1))
test "$(plutil -key CFBundleURLTypes -key $n $F)" || n=-1
done
   }
}
test "$l" = "1" && { 
echo
echo -n "Core File Location: "
echo $R
}
test "$d" = "1" && {
test "$(grep -A1 $(plutil -key CFBundleIdentifier $F) $TMP)" != "" && {
echo
echo -n "Documents location: "
grep -x -A1 $(plutil -key CFBundleIdentifier $F) $TMP | grep "/var/mobile/Containers/Data/Application"
   }
}
echo
echo ———————
echo
}
done
test "$l" = "1" && rm $TMP
