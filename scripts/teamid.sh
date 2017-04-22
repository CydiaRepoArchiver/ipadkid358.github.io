#!/bin/bash

exec 2> /dev/null
T=$(mktemp)
ls /var/containers/Bundle/Application | while read t
do
cd /var/containers/Bundle/Application/"$t"/*.app
test "$(plutil -key CFBundleName Info.plist)" = "yalu102" && {
tail -n+4 embedded.mobileprovision > $T
test "$(plutil -key ProvisionsAllDevices $T)" = "" && plutil -key TeamIdentifier $T | tail -n+2 | head -n-1 | sed -e 's/[\t ]//g'
rm $T
}
done