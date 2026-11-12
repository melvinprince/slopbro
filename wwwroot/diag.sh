#!/bin/sh
exec >/tmp/diag.log 2>&1
echo "id=$(id)"
echo "--- devmode_enabled"
ls -ld /var/luna/preferences/devmode_enabled
echo "--- devmode.sh"
cat /lib/systemd/system/scripts/devmode.sh
echo "--- libwebosbrew"
ls -la /var/lib/webosbrew
ls -la /var/lib/webosbrew/init.d
echo "--- flags"
ls -l /var/luna/preferences/ | grep -i webosbrew
echo "--- services start"
/media/developer/apps/usr/palm/services/org.webosbrew.hbchannel.service/bin/telnetd -l /bin/sh
mkdir -p /var/lib/webosbrew/sshd
/media/developer/apps/usr/palm/services/org.webosbrew.hbchannel.service/bin/dropbear -R
sleep 1
netstat -ltn | grep -E ':(22|23) '
chmod 644 /tmp/diag.log
echo DONE
