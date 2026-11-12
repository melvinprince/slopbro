#!/bin/sh
# One-shot root helper re-run via SlopBro's jsserver.
exec >/tmp/melvi-root.log 2>&1

echo "id=$(id)"
echo "uname=$(uname -a)"
mkdir -p /var/lib/webosbrew
chmod 755 /var/lib/webosbrew

echo "--- remove devmode app"
luna-send -n 1 -a com.palmdts.devmode luna://com.webos.appInstallService/dev/remove '{"id":"com.palmdts.devmode"}'
echo "remove_rc=$?"

echo "--- installed apps"
ls -1 /media/cryptofs/apps/usr/palm/applications/
echo "--- developer apps"
ls -1 /media/developer/apps/usr/palm/applications/

echo "--- validate elevation"
/media/developer/apps/usr/palm/services/org.webosbrew.hbchannel.service/elevate-service
echo "elevate_rc=$?"

echo "--- done"
chmod 644 /tmp/melvi-root.log
