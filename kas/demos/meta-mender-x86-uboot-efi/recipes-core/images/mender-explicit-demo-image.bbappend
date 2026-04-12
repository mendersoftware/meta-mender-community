# Override fw_env.config for x86-64 U-Boot EFI mode at rootfs assembly time.
# The Mender class creates a symlink /etc/fw_env.config -> /data/u-boot/fw_env.config
# and populates /data/u-boot/ with device-offset config. We override BOTH locations
# with file-based ESP config (environment stored on mounted FAT ESP at /uboot/).
# This MUST use :append:mender-uboot to run AFTER the Mender class setup.
ROOTFS_POSTPROCESS_COMMAND:append:mender-uboot = " fixup_fw_env_for_efi;"

fixup_fw_env_for_efi() {
    # Override the data partition copy (symlink target)
    install -d ${IMAGE_ROOTFS}/data/u-boot
    printf '/uboot/uboot.env\t0x0\t0x20000\n/uboot/uboot-redund.env\t0x0\t0x20000\n' > ${IMAGE_ROOTFS}/data/u-boot/fw_env.config

    # Also replace /etc/fw_env.config if it's a symlink or file
    rm -f ${IMAGE_ROOTFS}${sysconfdir}/fw_env.config
    printf '/uboot/uboot.env\t0x0\t0x20000\n/uboot/uboot-redund.env\t0x0\t0x20000\n' > ${IMAGE_ROOTFS}${sysconfdir}/fw_env.config

    # Rewrite fstab: keep stock entries, then add our mount points once.
    # This avoids duplicates from Mender class + WIC both adding entries.
    local fstab="${IMAGE_ROOTFS}${sysconfdir}/fstab"
    sed -i '/\/uboot\|\/data\|\/boot\/efi/d' "$fstab"
    printf '/dev/sda1\t/boot/efi\tvfat\tdefaults\t0\t0\n' >> "$fstab"
    printf '/dev/sda2\t/uboot\tvfat\tdefaults,sync\t0\t0\n' >> "$fstab"
    printf '/dev/sda5\t/data\text4\tdefaults\t0\t0\n' >> "$fstab"
}
