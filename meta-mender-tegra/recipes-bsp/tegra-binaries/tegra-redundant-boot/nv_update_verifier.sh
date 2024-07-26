#!/bin/sh

upgrade_available=$(/sbin/fw_printenv upgrade_available | cut -d "=" -f2)

# Only verify booted slot if we are not in an upgrade process
# since mender will do that on commit (through fw_setenv)
if [ "$upgrade_available" = "0" ]; then
	/usr/sbin/nvbootctrl verify
fi
