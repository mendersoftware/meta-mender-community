#!/bin/sh


function read_efivar() {
	local AB="AB"
	local slot="Slot${AB:$1:1}"
	local varname="/sys/firmware/efi/efivars/RootfsStatus${slot}-781e084c-a330-417c-b678-38e696380cb9"
	local var=$(cat $varname | tail -c +5 | tr -d '[\000]')

	echo -n "$var"
}



function get_bootable_status() {
	local status="$(read_efivar "${1}")"
	local size="${#status}"
	return $size
}


function set_update_status() {
	get_bootable_status 0
	local slot0=$?
	get_bootable_status 1
	local slot1=$?
	if [[ "$slot0" -ne 0 || "$slot1" -ne 0 ]]; then
		fw_setenv -s <<< upgrade_available=0
	fi	
}

set_update_status

