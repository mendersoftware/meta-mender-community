#!/bin/sh

boot_flag="/var/lib/mender/boot_attempted"
current_slot=$(/usr/sbin/nvbootctrl get-current-slot)
upgrade_available=$(/sbin/fw_printenv upgrade_available | cut -d "=" -f2)

# Only verify booted slot if we are not in an upgrade process
# since mender will do that on commit (through fw_setenv)
if [ "$upgrade_available" = "0" ]; then
	/usr/sbin/nvbootctrl verify
	if [ -f $boot_flag ]; then
		rm $boot_flag
	fi
	exit 0
fi

if [ -f $boot_flag ]; then
	prev_boot_attempt="$(cat $boot_flag)"
	rm $boot_flag
	if [ "$prev_boot_attempt" = "$current_slot" ]; then
		systemctl reboot -f
		exit 1
	fi 
fi
echo $current_slot > $boot_flag
