#!/bin/sh

boot_flag="/var/lib/mender/boot_attempted"
target_flag="/var/lib/mender/tegra-update-target"
current_slot=$(/usr/sbin/nvbootctrl get-current-slot)
upgrade_available=$(/sbin/fw_printenv upgrade_available | cut -d "=" -f2)

# Only verify booted slot if we are not in an upgrade process
# since mender will do that on commit (through fw_setenv)
if [ "$upgrade_available" = "0" ]; then
	/usr/sbin/nvbootctrl verify
	rm -f $boot_flag $target_flag
	exit 0
fi

# An update is pending. If we are not running the slot the update targets,
# the switch never happened (e.g. power loss during the bootloader capsule
# update, leaving the target bootloader chain unbootable) or the firmware fell
# back. The running slot is the known-good one, so:
#  - mark the target rootfs slot unbootable, so L4TLauncher never fails over
#    to a slot whose bootloader chain is not proven,
#  - verify the running slot, which re-arms its rootfs retry counter (with
#    RootfsRetryCountMax=1 it is at 0 now, and any warm reset would make
#    L4TLauncher condemn it and switch to the target chain),
#  - clear upgrade_available, so Mender rolls the update back.
# Never force a reboot from here.
if [ -f $target_flag ]; then
	target_slot="$(cat $target_flag)"
	if [ "$target_slot" != "$current_slot" ]; then
		echo "nv_update_verifier: update targets slot $target_slot but running slot $current_slot, rolling back" > /dev/kmsg
		. /usr/bin/uefi_common.func
		if [ "$target_slot" = "1" ]; then
			set_efi_var "RootfsStatusSlotB" "781e084c-a330-417c-b678-38e696380cb9" "\xff\x00\x00\x00"
		else
			set_efi_var "RootfsStatusSlotA" "781e084c-a330-417c-b678-38e696380cb9" "\xff\x00\x00\x00"
		fi
		/usr/sbin/nvbootctrl verify
		/sbin/fw_setenv upgrade_available 0
		rm -f $boot_flag
		exit 0
	fi
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
