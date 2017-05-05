#!/bin/bash

exec > appnames2.txt 2> /dev/null

test "$1" = "loc" && {
TMP=$(mktemp)
ls /var/mobile/Containers/Data/Application | while read t
do
plutil -key MCMMetadataIdentifier  /var/mobile/Containers/Data/Application/"$t"/.com.apple.mobile_container_manager.metadata.plist >> $TMP
echo /var/mobile/Containers/Data/Application/"$t" >> $TMP
done
}

ls /Applications | while read t
do
F=/Applications/"$t"/Info.plist
test "$(plutil -key CFBundleIcons $F)" && { 
test "$(plutil -key SBAppTags $F)" || { 
test "$(plutil -key CFBundleName $F)" && echo "Name: $(plutil -key CFBundleName $F)"
test "$(plutil -key CFBundleDisplayName $F)" && echo "Display Name: $(plutil -key CFBundleDisplayName $F)"
test "$(plutil -key CFBundleExecutable $F)" && echo "Executable Name: $(plutil -key CFBundleExecutable $F)"
test "$(plutil -key CFBundleIdentifier $F)" && { 
echo "Bundle ID: $(plutil -key CFBundleIdentifier $F)"
test "$1" = "loc" && { 
echo
echo -n "Core File Location: "
echo /Applications/"$t"
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
echo "Bundle ID: $(plutil -key CFBundleIdentifier $F)"
test "$1" = "loc" && { 
echo
echo -n "Core File Location: "
echo $R
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
test "$1" = "loc" && rm $TMP