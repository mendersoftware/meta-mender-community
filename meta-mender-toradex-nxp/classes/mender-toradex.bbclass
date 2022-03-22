ROOTFS_POSTPROCESS_COMMAND:append = " toradex_mender_update_fstab_file;"
toradex_mender_update_fstab_file() {
    # the Toradex BSP sets up a symlink called /dev/boot-part which is added to FSTAB.
    # The logic to determine which device node is the boot partition fails with the Mender
    # partitioning and when using Grub, systemd will fail to boot and drop to maintenance
    # mode.  Since Mender already has logic to mount this partition at /uboot we just want
    # to remove the line from fstab that mounts /dev/boot-part
    grep -v /dev/boot-part ${IMAGE_ROOTFS}${sysconfdir}/fstab > ${IMAGE_ROOTFS}${sysconfdir}/fstab.toradex
    mv ${IMAGE_ROOTFS}${sysconfdir}/fstab.toradex ${IMAGE_ROOTFS}${sysconfdir}/fstab
}

addhandler mender_tezi_sanity_handler
mender_tezi_sanity_handler[eventmask] = "bb.event.ParseCompleted"
python mender_tezi_sanity_handler() {
  if d.getVar('FULL_IMAGE_SUFFIX') == "":
    bb.fatal("Unable to determine FULL_IMAGE_SUFFIX for use with mender_tezi images.")

  menderOffset = d.getVar("MENDER_IMAGE_BOOTLOADER_BOOTSECTOR_OFFSET")
  bootromPayload = d.getVar("OFFSET_BOOTROM_PAYLOAD")
  if (menderOffset != None) and (bootromPayload != None) and (menderOffset != bootromPayload):
    bb.fatal("Error.  MENDER_IMAGE_BOOTLOADER_BOOTSECTOR_OFFSET (%s) != OFFSET_BOOTROM_PAYLOAD (%s)" % \
             (d.getVar("MENDER_IMAGE_BOOTLOADER_BOOTSECTOR_OFFSET"), d.getVar("OFFSET_BOOTROM_PAYLOAD")))
}

PREFERRED_RPROVIDER_u-boot-default-env = "u-boot-toradex"

TORADEX_BSP_VERSION ??= "toradex-bsp-5.3.0"
MACHINEOVERRIDES =. "${TORADEX_BSP_VERSION}:"
