#!/bin/bash

exec > appnames.txt 2> /dev/null

test "$1" = "loc" && {
TMP=$(mktemp)
for t in `ls /var/mobile/Containers/Data/Application`
do
cd /var/mobile/Containers/Data/Application/"$t"
plutil -key MCMMetadataIdentifier .com.apple.mobile_container_manager.metadata.plist >> $TMP
pwd >> $TMP
done
}

for t in `ls /Applications`
do
cd /Applications/"$t"
test "$(plutil -key CFBundleIcons Info.plist)" != "" && { 
test "$(plutil -key SBAppTags Info.plist)" = "" && { 
test "$(plutil -key CFBundleName Info.plist)" != "" && { echo -n "Name: "; plutil -key CFBundleName Info.plist; }
test "$(plutil -key CFBundleDisplayName Info.plist)" != "" && { echo -n "Display Name: "; plutil -key CFBundleDisplayName Info.plist; }
test "$(plutil -key CFBundleExecutable Info.plist)" != "" && { echo -n "Executable Name: "; plutil -key CFBundleExecutable Info.plist; }
test "$(plutil -key CFBundleIdentifier Info.plist)" != "" && { 
echo -n "Bundle ID: " 
plutil -key CFBundleIdentifier Info.plist
test "$1" = "loc" && { 
echo
echo -n "Core File Location: "
pwd
test "$(grep -A1 $(plutil -key CFBundleIdentifier Info.plist) $TMP)" != "" && {
echo
echo -n "Documents location: "
grep -A1 $(plutil -key CFBundleIdentifier Info.plist) $TMP| grep "/var/mobile/Containers/Data/Application"
}
echo
echo ———————
echo
         }
      }
   }
}
done

for t in `ls /var/containers/Bundle/Application/`
do
cd /var/containers/Bundle/Application/"$t"
cd *.app
test "$(plutil -key CFBundleName Info.plist)" != "" && { echo -n "Name: "; plutil -key CFBundleName Info.plist; }
test "$(plutil -key CFBundleDisplayName Info.plist)" != "" && { echo -n "Display Name: "; plutil -key CFBundleDisplayName Info.plist; }
test "$(plutil -key CFBundleExecutable Info.plist)" != "" && { echo -n "Executable Name: "; plutil -key CFBundleExecutable Info.plist; }
test "$(plutil -key CFBundleIdentifier Info.plist)" != "" && { 
echo -n "Bundle ID: " 
plutil -key CFBundleIdentifier Info.plist
test "$1" = "loc" && { 
echo
echo -n "Core File Location: "
pwd
test "$(grep -A1 $(plutil -key CFBundleIdentifier Info.plist) $TMP)" != "" && {
echo
echo -n "Documents location: "
grep -A1 $(plutil -key CFBundleIdentifier Info.plist) $TMP| grep "/var/mobile/Containers/Data/Application"
}
echo
echo ———————
echo
   }
}
done
test "$1" = "loc" && rm $TMP