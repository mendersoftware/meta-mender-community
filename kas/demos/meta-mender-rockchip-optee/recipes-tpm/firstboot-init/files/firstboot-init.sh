#!/bin/sh

set -e

log() { /usr/bin/echo "[firstboot-init] $*"; }

log "Starting TPM-based encryption setup"

# Find the partition: by label (pre-LUKS) or by type (post-LUKS after first-run)
RETRY=0
STATIC_DEVICE=""
while [ $RETRY -lt 10 ]; do
    STATIC_DEVICE=$(blkid | grep 'LABEL="encrypted"' | cut -d: -f1)
    [ -z "${STATIC_DEVICE}" ] && \
        STATIC_DEVICE=$(blkid | grep 'TYPE="crypto_LUKS"' | cut -d: -f1)
    [ -n "${STATIC_DEVICE}" ] && break
    log "Waiting for partition... ($RETRY/10)"
    sleep 1
    RETRY=$((RETRY + 1))
done

if [ -z "${STATIC_DEVICE}" ]; then
    log "ERROR: Partition not found"
    exit 1
fi
log "Found partition at ${STATIC_DEVICE}"


NEEDS_ENROLL=true

if /usr/sbin/cryptsetup isLuks "${STATIC_DEVICE}"; then
    # Partition already LUKS-formatted (A/B flip or re-flash).
    # With /data/tee persistence the SRK should replay within a few seconds.
    # Allow up to 60s then fall back to re-format+re-enroll (handles the first
    # transition from an old image or any future NV corruption).
    log "Partition is LUKS-formatted - waiting for SRK (0x81000001)..."
    RETRY=0
    while [ $RETRY -lt 60 ]; do
        tpm2_readpublic -c 0x81000001 > /dev/null 2>&1 && { NEEDS_ENROLL=false; break; }
        log "SRK not ready ($RETRY/60), waiting..."
        sleep 1
        RETRY=$((RETRY + 1))
    done
    if [ "$NEEDS_ENROLL" = "true" ]; then
        log "WARNING: SRK inaccessible after 60s (fTPM NV lost) - erasing LUKS for re-enrollment"
        /usr/sbin/cryptsetup erase --batch-mode "${STATIC_DEVICE}" 2>/dev/null || true
    else
        log "SRK accessible - re-configuring rootfs for existing LUKS"
    fi
fi

if [ "$NEEDS_ENROLL" = "true" ]; then
    # First boot or re-enrollment after NV loss: format, create filesystem, enroll TPM
    log "Enrolling TPM - formatting partition..."

    PASSWORD_FILE="/root/static-key"
    /usr/bin/openssl rand -base64 44 > "${PASSWORD_FILE}" || {
        log "ERROR: Key generation failed"; exit 1
    }
    chmod 0600 "${PASSWORD_FILE}"
    /bin/sync

    /usr/bin/cat "${PASSWORD_FILE}" | \
        /usr/sbin/cryptsetup luksFormat --batch-mode --type luks2 "${STATIC_DEVICE}" || {
        log "ERROR: luksFormat failed"; rm -f "${PASSWORD_FILE}"; exit 1
    }
    /usr/bin/cat "${PASSWORD_FILE}" | \
        /usr/sbin/cryptsetup open --batch-mode "${STATIC_DEVICE}" static || {
        log "ERROR: LUKS open failed"; rm -f "${PASSWORD_FILE}"; exit 1
    }
    /usr/sbin/mkfs.ext4 -q /dev/mapper/static || {
        log "ERROR: mkfs failed"; exit 1
    }
    /bin/sync
    /usr/sbin/cryptsetup close static
    /bin/sync

    # Wait for TPM before enrolling
    RETRY=0
    while [ ! -c /dev/tpmrm0 ] && [ $RETRY -lt 30 ]; do
        log "Waiting for TPM device... ($RETRY/30)"
        sleep 1
        RETRY=$((RETRY + 1))
    done
    if [ ! -c /dev/tpmrm0 ]; then
        log "ERROR: TPM device not available"
        rm -f "${PASSWORD_FILE}"; exit 1
    fi

    PASSWORD=$(cat "${PASSWORD_FILE}")
    export PASSWORD
    /usr/bin/systemd-cryptenroll --tpm2-device=auto "${STATIC_DEVICE}" || {
        log "ERROR: TPM enroll failed"
        unset PASSWORD; rm -f "${PASSWORD_FILE}"; exit 1
    }
    unset PASSWORD
    shred -uvfz "${PASSWORD_FILE}" 2>/dev/null || rm -f "${PASSWORD_FILE}"
    log "Format and enroll complete"
fi

# Write crypttab if missing (PARTUUID is stable hardware - readable without opening LUKS)
if ! /bin/grep -qE '^static[[:space:]]' /etc/crypttab 2>/dev/null; then
    PARTUUID=$(/usr/bin/lsblk -ndo PARTUUID "${STATIC_DEVICE}" 2>/dev/null)
    SOURCE="${STATIC_DEVICE}"
    [ -n "${PARTUUID}" ] && SOURCE="/dev/disk/by-partuuid/${PARTUUID}"
    /usr/bin/echo "static ${SOURCE} none luks,tpm2-device=auto" >> /etc/crypttab
    log "Wrote crypttab: ${SOURCE}"
fi

# Unlock with TPM. systemd-cryptsetup attach uses the ask-password socket (not
# stdin), so it will block indefinitely if the TPM token fails and no one answers
# the socket. Wrap with timeout so it fails fast and the retry loop can kick in.
log "Unlocking with TPM..."
RETRY=0
while true; do
    timeout 20 /usr/lib/systemd/systemd-cryptsetup attach static \
        "${STATIC_DEVICE}" - tpm2-device=auto && break
    RETRY=$((RETRY + 1))
    if [ $RETRY -ge 10 ]; then
        log "ERROR: Failed to unlock after ${RETRY} retries"
        exit 1
    fi
    log "Unlock retry ${RETRY}/10..."
    sleep 3
done

# Write fstab if missing (UUID only readable after device is open)
/usr/bin/mkdir -p /mnt/static
if ! /bin/grep -qE '^[^#].*[[:space:]]/mnt/static[[:space:]]' /etc/fstab 2>/dev/null; then
    UUID=$(/usr/bin/lsblk -o UUID /dev/mapper/static -n)
    /usr/bin/echo "UUID=${UUID} /mnt/static ext4 defaults,nofail,x-systemd.device-timeout=30 0 0" \
        >> /etc/fstab
    log "Wrote fstab: UUID=${UUID}"
fi

# Mount
/usr/bin/mount /mnt/static || {
    log "ERROR: Mount failed"
    /usr/sbin/cryptsetup close static
    exit 1
}

if mountpoint -q /mnt/static; then
    log "SUCCESS: /mnt/static mounted"
    /usr/bin/df -h /mnt/static
else
    log "ERROR: Mount verification failed"
    exit 1
fi

log "Complete"
/usr/sbin/reboot
