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

ROOTFS_POSTPROCESS_COMMAND:append = " toradex_mender_update_devicetree_overlays;"
toradex_mender_update_devicetree_overlays() {
    # the Toradex BSP uses Device Tree overlays which are normally populated to the boot
    # partition using WIC and bootimg-partition types. Since Mender does not use that partition
    # type we have to account for that here. We want it in a POSTPROCESS_COMMAND so that it
    # applies to all images
    cp ${DEPLOY_DIR_IMAGE}/overlays.txt ${IMAGE_ROOTFS}/boot/overlays.txt
    cp -R ${DEPLOY_DIR_IMAGE}/overlays/ ${IMAGE_ROOTFS}/boot/overlays
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

TORADEX_BSP_VERSION ??= "toradex-bsp-6.0.0"
MACHINEOVERRIDES =. "${TORADEX_BSP_VERSION}:"
