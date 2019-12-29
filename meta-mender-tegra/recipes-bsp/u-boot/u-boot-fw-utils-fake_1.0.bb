DESCRIPTION = "Fake implementation of fw_printenv and fw_setenv for Mender"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRC_URI = " \
    file://fw_printenv \
    file://fw_setenv \
"

S = "${WORKDIR}"

do_configure[noexec] = "1"
do_compile[noexec] = "1"

do_install() {
    install -d ${D}${base_sbindir}
    install -m 0755 ${S}/fw_printenv ${S}/fw_setenv ${D}${base_sbindir}/
}

PACKAGE_ARCH = "${MACHINE_ARCH}"
RCONFLICTS_${PN} = "u-boot-fw-utils"
