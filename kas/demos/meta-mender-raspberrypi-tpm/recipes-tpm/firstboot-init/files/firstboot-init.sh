#!/bin/sh

set -e

STATIC_DEVICE="/dev/mmcblk0p6"

/usr/bin/echo "[firstboot-init] Starting TPM-based encryption setup"

# Check if already encrypted
if /usr/sbin/cryptsetup isLuks "${STATIC_DEVICE}"; then
	/usr/bin/echo "[firstboot-init] Static partition is already encrypted"
	exit 0
fi

# Ensure root filesystem is writable
if ! touch /root/.test_write 2>/dev/null; then
	/usr/bin/echo "[firstboot-init] ERROR: Root filesystem is read-only, cannot proceed"
	exit 1
fi
rm -f /root/.test_write

PASSWORD_FILE="/root/static-key"

# Generate random password
/usr/bin/openssl rand -base64 44 > ${PASSWORD_FILE} || {
	/usr/bin/echo "[firstboot-init] ERROR: Failed to generate password"
	exit 1
}
/bin/sync

/usr/bin/echo "[firstboot-init] Formatting partition with LUKS2..."
/usr/bin/cat "${PASSWORD_FILE}" | /usr/sbin/cryptsetup luksFormat --batch-mode --type luks2 "${STATIC_DEVICE}"

/usr/bin/cat "${PASSWORD_FILE}" | /usr/sbin/cryptsetup open --batch-mode "${STATIC_DEVICE}" static
/usr/bin/echo "[firstboot-init] Creating ext4 filesystem..."
/usr/sbin/mkfs.ext4 -q /dev/mapper/static
/bin/sync

uuid=$(/usr/bin/lsblk -o UUID /dev/mapper/static -n)
/usr/sbin/cryptsetup close static
/bin/sync

/usr/bin/echo "[firstboot-init] Enrolling TPM2 for automatic unlock..."
export PASSWORD="$(cat ${PASSWORD_FILE})"
/usr/bin/systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=7 "${STATIC_DEVICE}" || {
	/usr/bin/echo "[firstboot-init] ERROR: Failed to enroll TPM2"
	unset PASSWORD
	rm -f ${PASSWORD_FILE}
	exit 1
}
unset PASSWORD

# Securely remove password file
shred -vfz ${PASSWORD_FILE} 2>/dev/null || rm -f ${PASSWORD_FILE}

/usr/bin/mkdir -p /mnt/static
/usr/bin/echo "UUID=$uuid /mnt/static ext4 defaults,x-systemd.device-timeout=30 0 0" >> /etc/fstab

/usr/bin/echo "[firstboot-init] TPM-based encryption setup completed successfully!"

/usr/sbin/reboot

exit 0
