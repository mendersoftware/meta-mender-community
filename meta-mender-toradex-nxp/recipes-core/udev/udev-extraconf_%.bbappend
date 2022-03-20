do_install:append() {
    echo "${MENDER_BOOT_PART}" >> ${D}${sysconfdir}/udev/mount.blacklist
    echo "${MENDER_ROOTFS_PART_A}" >> ${D}${sysconfdir}/udev/mount.blacklist
    echo "${MENDER_ROOTFS_PART_B}" >> ${D}${sysconfdir}/udev/mount.blacklist
    echo "${MENDER_DATA_PART}" >> ${D}${sysconfdir}/udev/mount.blacklist
}
