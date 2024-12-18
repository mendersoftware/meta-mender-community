FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append:p3768-0000-p3767-0000 = " \
    file://flash_l4t_t234_nvme_rootfs_ab.xml \
"

PARTITION_FILE_EXTERNAL:p3768-0000-p3767-0000 = "${WORKDIR}/flash_l4t_t234_nvme_rootfs_ab.xml"
