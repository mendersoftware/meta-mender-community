ROOTFS_POSTPROCESS_COMMAND_append = " toradex_mender_update_fstab_file;"
toradex_mender_update_fstab_file() {
    # the Toradex BSP sets up a symlink called /dev/boot-part which is added to FSTAB.
    # The logic to determine which device node is the boot partition fails with the Mender
    # partitioning and when using Grub, systemd will fail to boot and drop to maintenance
    # mode.  Since Mender already has logic to mount this partition at /uboot we just want
    # to remove the line from fstab that mounts /dev/boot-part
    grep -v /dev/boot-part ${IMAGE_ROOTFS}${sysconfdir}/fstab > ${IMAGE_ROOTFS}${sysconfdir}/fstab.toradex
    mv ${IMAGE_ROOTFS}${sysconfdir}/fstab.toradex ${IMAGE_ROOTFS}${sysconfdir}/fstab
}
