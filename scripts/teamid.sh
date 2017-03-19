#!/bin/bash

exec 2> /dev/null
cd /var/containers/Bundle/Application
filecontent=( `ls .`)
for t in "${filecontent[@]}"
do
cd "$t"/*.app
test "$(plutil -key CFBundleName Info.plist)" = "yalu102" && {
tail -n+4 embedded.mobileprovision > tmp.plist
test "$(plutil -key ProvisionsAllDevices tmp.plist)" = "" && {
plutil -key TeamIdentifier tmp.plist | tail -n+2 | head -n-1 | sed -e 's/[\t ]//g'
}
rm tmp.plist
}
cd /var/containers/Bundle/Application
done