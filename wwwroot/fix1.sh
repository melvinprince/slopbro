#!/bin/sh
# Recreate devmode_enabled, test signature, reinstall Homebrew Channel, elevate.
U=http://192.168.1.2:8099/u
S=/media/cryptofs/apps/usr/palm/services/com.palmdts.devmode.service
{
  echo "id=$(id)"
  echo "--- verify"
  openssl dgst -sha512 -verify /usr/palm/services/com.palm.service.devmode/pub.pem -signature $S/start-devmode.sig $S/start-devmode.sh 2>&1
  echo "--- script head"
  head -50 $S/start-devmode.sh 2>&1
  echo "--- grep webosbrew"
  grep -n -i -e webosbrew -e startup $S/start-devmode.sh 2>&1
  echo "--- enable devmode"
  mkdir -p /var/luna/preferences/devmode_enabled
  ls -ld /var/luna/preferences/devmode_enabled
  echo "--- install hb"
  luna-send -n 1 -w 30000 -a com.palmdts.devmode luna://com.webos.appInstallService/dev/install '{"id":"com.ares.defaultName","ipkUrl":"/media/internal/downloads/hbchannel.ipk","subscribe":true}' 2>&1
  sleep 3
  echo "--- installed"
  ls -d /media/developer/apps/usr/palm/applications/org.webosbrew.hbchannel 2>&1
  echo "--- elevate"
  /media/developer/apps/usr/palm/services/org.webosbrew.hbchannel.service/elevate-service 2>&1
  echo "--- elevate strings"
  strings /media/developer/apps/usr/palm/services/org.webosbrew.hbchannel.service/elevate-service 2>/dev/null | grep -i -e start-devmode -e backup -e devmode.sh | head -30
} | /usr/bin/curl -s --max-time 60 -X POST --data-binary @- "$U?name=fix1"
echo POSTED
