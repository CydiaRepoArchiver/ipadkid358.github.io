#!/bin/bash
echo Welcome to Cydia Extender installer made by DillanCodez on an iPhone \(literally I made this on an iPhone\). Enjoy!
echo
echo This is a modified version of DillanCodez's script that pulls your team id for you
TMP=$(mktemp -d)
if [[ "$(ls /private/var/containers/Bundle/Application/* | grep Extender.app)" != "" ]]; then
 echo "delete the app first then reinstall"
 exit 6
fi
echo WARNING: THIS INSTALLS APPSYNC, LDID, WGET, CA Certs, App Installer, ZIP, UNZIP IF YOU DO NOT WANT TO INSTALL THESE PLEASE EXIT THIS USING CTRL+C or QUIT THE TERMINAL APP YOU ARE USING!
sleep 10
echo
echo Ok, here we go
if [[ "$(dpkg -l | grep "ca.kirara.gplv3")" == "" ]]; then
echo You will need to reboot after this finishes. Starting in 5 seconds.
sleep 5
function checkFail(){
if [[ "$?" != 0 ]]; then
	echo "error, quitting"
	echo Cleaning up
	rm -r $TMP
	rm -f /etc/apt/sources.list.d/cyex.list
	exit 5
fi
}
if [[ $UID -ne 0 ]]; then
 echo You must be root!
 exit 3
fi
echo Starting!
echo Installing dependencies
RP1=0
RP2=0
RP3=0
for APT in $(find /etc/apt/sources.list.d -name \*.list); do
if [[ "$(cat $APT | grep "bigboss")" != "" ]]; then
RP1=1
fi
if [[ "$(cat $APT | grep "cydia.angelxwind.net")" != "" ]]; then
RP2=1
fi
if [[ "$(cat $APT | grep "bluesymphony.kirara.ca")" != "" ]]; then
RP3=1
fi
done
if [[ $RP1 -eq 0 ]]; then
echo "deb http://apt.thebigboss.org/repofiles/cydia/ stable main" >> "/etc/apt/sources.list.d/cyex.list"
fi
if [[ $RP2 -eq 0 ]]; then
echo "deb https://cydia.angelxwind.net/ ./" >> "/etc/apt/sources.list.d/cyex.list"
fi
if [[ $RP3 -eq 0 ]]; then
echo "deb https://bluesymphony.kirara.ca/ ./" >> "/etc/apt/sources.list.d/cyex.list"
fi
apt-get update
echo Assuming the update worked, if it didn\'t this next command will exit the script.
echo Reinstalling all dependencies now.
sleep 2
apt-get install --reinstall wget ldid org.thebigboss.cacerts com.linusyang.appinst zip unzip net.angelxwind.appsyncunified ca.kirara.gplv3 --force-yes -y
checkFail
echo dependencies are installed
echo Switching to $TMP directory
cd $TMP
if [[ $(pwd) != $TMP ]]; then
 echo Error going to temp directory
 exit 2
fi
echo downloading windows Cydia impactor \(we need the dat\)
wget --no-check-certificate https://cydia.saurik.com/api/latest/2 -O Impactor_0.9.39.zip
checkFail
echo Assuming it downloaded, unzipping
unzip Impactor_0.9.39.zip
checkFail
echo Let\'s extract the dat
unzip Impactor.dat
checkFail
echo Let\'s extract the ipa
unzip extender.ipa
checkFail
echo Dipping in to the folder
cd Payload
checkFail
ENTITLEMENTS='<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.developer.team-identifier</key>
    <string>AAAAAAAAAA</string>

    <key>application-identifier</key>
    <string>AAAAAAAAAA.com.cydia.Extender</string>

    <key>com.apple.security.application-groups</key>
    <array>
    <string>group.com.cydia.Extender</string>
    </array>

    <key>com.apple.developer.networking.networkextension</key>
    <array>
    <string>packet-tunnel-provider</string>
    </array>

    <key>keychain-access-groups</key>
    <array>
    <string>AAAAAAAAAA.com.cydia.Extender</string>
    </array>
</dict>
</plist>'
TEAMID="$(exec 2> /dev/null
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
done)"
echo Got team id
echo Injecting team id
ENTITLEMENTS=${ENTITLEMENTS//AAAAAAAAAA/$TEAMID}
echo Assuming it completed properly we continue on.
echo $ENTITLEMENTS > ents.plist
ldid -Sents.plist Extender.app/Extender
checkFail
echo Okay now we gotta install the IPA
cd ../
checkFail
zip -r toinst.ipa Payload
checkFail
appinst toinst.ipa
checkFail
echo Cleaning up
rm -r $TMP
rm -f /etc/apt/sources.list.d/cyex.list
echo Done!
exit 0
