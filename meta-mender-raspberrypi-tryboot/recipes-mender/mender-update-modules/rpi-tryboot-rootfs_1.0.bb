SUMMARY = "Mender update module for Raspberry Pi tryboot A/B rootfs updates"
DESCRIPTION = "Custom Mender update module that handles full system updates \
using the Raspberry Pi native tryboot A/B boot switching mechanism."
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRC_URI = "file://rpi-tryboot-rootfs"

S = "${WORKDIR}"

inherit allarch

RDEPENDS:${PN} = "util-linux coreutils sed"

do_install() {
    install -d ${D}${datadir}/mender/modules/v3
    install -m 0755 ${WORKDIR}/rpi-tryboot-rootfs ${D}${datadir}/mender/modules/v3/rpi-tryboot-rootfs
}

FILES:${PN} = "${datadir}/mender/modules/v3/rpi-tryboot-rootfs"
