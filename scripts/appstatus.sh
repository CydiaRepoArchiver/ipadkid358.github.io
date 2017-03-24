#!/bin/bash

exec > appstatus.txt
exec 2> /dev/null
cd /Applications
for t in `ls`
do
cd "$t"
test "$(plutil -key CFBundleName Info.plist)" != "" && { echo -n "Name: "; plutil -key CFBundleName Info.plist; }
test "$(plutil -key CFBundleDisplayName Info.plist)" != "" && { echo -n "Display Name: "; plutil -key CFBundleDisplayName Info.plist; }
test "$(plutil -key CFBundleExecutable Info.plist)" != "" && { echo -n "Executable Name: "; plutil -key CFBundleExecutable Info.plist; }
test "$(plutil -key CFBundleIdentifier Info.plist)" != "" && { 
echo -n "Bundle ID: " 
plutil -key CFBundleIdentifier Info.plist
echo -n "Status: "
if dpkg -S $t > /dev/null
then
echo Jailbreak application
else
echo Stock application
fi
echo 
echo ———————
echo
}
cd /Applications
done