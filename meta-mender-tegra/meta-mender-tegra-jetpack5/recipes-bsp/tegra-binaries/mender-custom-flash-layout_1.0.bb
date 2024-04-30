DESCRIPTION = "Custom flash layout file to add Mender-specific partitions"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRC_URI:tegra194 = "file://flash_mender.xml"

INHIBIT_DEFAULT_DEPS = "1"
COMPATIBLE_MACHINE = "(tegra)"

FILESEXTRAPATHS:prepend:tegra194 := "${THISDIR}/${BPN}-${@d.getVar('L4T_VERSION').replace('.', '-')}:"

S = "${WORKDIR}"

do_compile[noexec] = "1"

do_install:tegra194() {
    install -d ${D}${datadir}/mender-flash-layout
    install -m 0644 ${S}/flash_mender.xml ${D}${datadir}/mender-flash-layout/
}

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit nopackages