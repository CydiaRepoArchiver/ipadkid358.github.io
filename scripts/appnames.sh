#!/bin/bash

exec > appnames.txt
exec 2> /dev/null

cd /Applications
filecontent=( `ls .`)
for t in "${filecontent[@]}"
do
cd "$t"
test "$(plutil -key CFBundleIcons Info.plist)" != "" && { 
test "$(plutil -key SBAppTags Info.plist)" = "" && { 
test "$(plutil -key CFBundleName Info.plist)" != "" && { echo -n "Name: "; plutil -key CFBundleName Info.plist; }
test "$(plutil -key CFBundleDisplayName Info.plist)" != "" && { echo -n "Display Name: "; plutil -key CFBundleDisplayName Info.plist; }
test "$(plutil -key CFBundleExecutable Info.plist)" != "" && { echo -n "Executable Name: "; plutil -key CFBundleExecutable Info.plist; }
test "$(plutil -key CFBundleIdentifier Info.plist)" != "" && { 
echo -n "Bundle ID: " 
plutil -key CFBundleIdentifier Info.plist
test "$1" = "loc" && { echo; echo -n "Core File Location: "; pwd; }
echo 
echo ———————
echo
      }
   }
}
cd /Applications
done

cd /var/containers/Bundle/Application
filecontent=( `ls .`)
for t in "${filecontent[@]}"
do
cd "$t"
cd *.app
test "$(plutil -key CFBundleName Info.plist)" != "" && { echo -n "Name: "; plutil -key CFBundleName Info.plist; }
test "$(plutil -key CFBundleDisplayName Info.plist)" != "" && { echo -n "Display Name: "; plutil -key CFBundleDisplayName Info.plist; }
test "$(plutil -key CFBundleExecutable Info.plist)" != "" && { echo -n "Executable Name: "; plutil -key CFBundleExecutable Info.plist; }
test "$(plutil -key CFBundleIdentifier Info.plist)" != "" && { 
echo -n "Bundle ID: " 
plutil -key CFBundleIdentifier Info.plist
test "$1" = "loc" && { echo; echo -n "Core File Location: "; pwd; }
echo 
echo ———————
echo
}
cd /var/containers/Bundle/Application
done