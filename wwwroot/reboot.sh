#!/bin/sh
exec >/tmp/melvi-reboot.log 2>&1
echo "id=$(id)"
luna-send -n 1 -a com.webos.service.secondscreen.gateway luna://com.webos.service.sleep/shutdown/machineReboot '{"reason":"remoteKey"}'
echo "rc=$?"
