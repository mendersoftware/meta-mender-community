DESCRIPTION = "The rootfs-version-check Update Module implements a full image update with additional checks to protect against replay attacks."

require mender-update-modules.inc

inherit allarch

do_install_class-target() {
    install -d ${D}/${datadir}/mender/modules/v3
    install -m 755 ${S}/rootfs-version-check/module/rootfs-version-check ${D}/${datadir}/mender/modules/v3/rootfs-version-check

    install -d ${D}/${sysconfdir}/mender/
    cat >${D}${sysconfdir}/mender/rootfs-version-check.conf <<EOF
MENDER_ROOTFS_PART_A=${MENDER_ROOTFS_PART_A}
MENDER_ROOTFS_PART_B=${MENDER_ROOTFS_PART_B}
EOF

    install -d ${D}${datadir}/mender/utils
    install -m 0755 ${S}/rootfs-version-check/mender-compare-versions ${D}${datadir}/mender/utils
}

FILES_${PN} += " \
    ${datadir}/mender/modules/v3/rootfs-version-check \
    ${sysconfdir}/mender/rootfs-version-check.conf \
    ${datadir}/mender/utils/mender-compare-versions \
"

RDEPENDS_${PN} += "python3"
