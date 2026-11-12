#!/bin/sh
exec >/tmp/d2.log 2>&1
B=/media/developer/apps/usr/palm/services/org.webosbrew.hbchannel.service/bin
echo "id=$(id)"
echo "--- flags"
ls -l /var/luna/preferences/ | grep -i webosbrew
echo "--- libwebosbrew"
ls -la /var/lib/webosbrew 2>&1
echo "--- devmode_enabled"
ls -ld /var/luna/preferences/devmode_enabled 2>&1
echo "--- devmode.sh"
head -60 /lib/systemd/system/scripts/devmode.sh 2>&1
echo "--- starting"
mkdir -p /var/lib/webosbrew/sshd
$B/dropbear -R -E -F >/tmp/db.log 2>&1 &
$B/telnetd -l /bin/sh -F >/tmp/tn.log 2>&1 &
sleep 2
netstat -ltn | grep -E ':(22|23) '
L=$(tr '\n' ' ' < /tmp/db.log | cut -c1-160)
S=$(tr '\n' ' ' < /tmp/tn.log | cut -c1-80)
luna-send -w 1000 -n 1 -a com.webos.service.secondscreen.gateway luna://com.webos.notification/createToast "{\"sourceId\":\"x\",\"message\":\"db:$L | tn:$S\"}"
chmod 644 /tmp/d2.log /tmp/db.log /tmp/tn.log
echo DONE
