#!/bin/sh
# Create a persistent UEFI boot entry for U-Boot EFI application.
# This ensures OVMF/UEFI firmware can find and boot U-Boot after reboots,
# even if the auto-discovered boot entry is lost.

MARKER="/data/uboot-efi-bootentry-done"

if [ -f "$MARKER" ]; then
    exit 0
fi

# Check if efibootmgr is available
if ! command -v efibootmgr >/dev/null 2>&1; then
    echo "efibootmgr not found, skipping UEFI boot entry creation"
    exit 0
fi

# Check if efivars are accessible
if [ ! -d /sys/firmware/efi/efivars ]; then
    echo "EFI variables not accessible, skipping"
    exit 0
fi

# Find the ESP disk and partition (ESP is at /boot/efi, NOT /uboot)
ESP_DEV=$(findmnt -n -o SOURCE /boot/efi 2>/dev/null)
if [ -z "$ESP_DEV" ]; then
    echo "ESP not mounted at /boot/efi, skipping"
    exit 0
fi

# Extract disk and partition number (e.g., /dev/vda1 -> /dev/vda + 1)
DISK=$(echo "$ESP_DEV" | sed 's/[0-9]*$//')
PARTNUM=$(echo "$ESP_DEV" | grep -o '[0-9]*$')

echo "Creating UEFI boot entry: disk=$DISK part=$PARTNUM loader=EFI/BOOT/bootx64.efi"
efibootmgr -c -d "$DISK" -p "$PARTNUM" -l '\EFI\BOOT\bootx64.efi' -L 'U-Boot EFI' 2>&1

if [ $? -eq 0 ]; then
    touch "$MARKER"
    echo "UEFI boot entry created successfully"
else
    echo "WARNING: Failed to create UEFI boot entry"
fi
