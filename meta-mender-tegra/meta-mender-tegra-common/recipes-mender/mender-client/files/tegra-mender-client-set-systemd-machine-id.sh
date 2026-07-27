#!/bin/sh

set -eu

BOOTENV_PRINT="efi_systemd_machine_id.sh -r"
BOOTENV_SET="efi_systemd_machine_id.sh -w"

CURRENT_BOOTLOADER_ID=$($BOOTENV_PRINT 2>/dev/null | cut -d= -f2)
CURRENT_SYSTEMD_ID=$(cat /etc/machine-id)

rc=0
if [ -z "${CURRENT_BOOTLOADER_ID}" ] && [ ! -z "${CURRENT_SYSTEMD_ID}" ]; then
    $BOOTENV_SET "${CURRENT_SYSTEMD_ID}"
    rc=$?
elif [ "${CURRENT_BOOTLOADER_ID}" != "${CURRENT_SYSTEMD_ID}" ]; then
    echo "Error; bootloader and systemd disagree on machine-id." >&2
    rc=1
fi

exit $rc
