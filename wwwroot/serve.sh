#!/bin/sh
# Serve diagnostics over HTTP so we can read them without a shell.
exec 2>&1
{
  echo "id=$(id)"
  echo "--- devmode_enabled"; ls -ld /var/luna/preferences/devmode_enabled
  echo "--- flags"; ls -l /var/luna/preferences/ | grep -i webosbrew
  echo "--- libwebosbrew"; ls -la /var/lib/webosbrew 2>&1
  echo "--- devmode.sh"; cat /lib/systemd/system/scripts/devmode.sh 2>&1
  echo "--- logs"; cat /tmp/d2.log /tmp/db.log /tmp/tn.log 2>&1
  echo "--- ps"; ps w 2>&1 | head -40
} > /tmp/web.txt
chmod 644 /tmp/web.txt /tmp/*.log 2>/dev/null
pkill -f 'busybox httpd' 2>/dev/null
/bin/busybox httpd -p 8899 -h /tmp
echo STARTED > /tmp/httpsrv.ok
