DESCRIPTION = "Custom flash layout file to add Mender-specific partitions"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRC_URI = "file://flash_mender.xml"

INHIBIT_DEFAULT_DEPS = "1"
COMPATIBLE_MACHINE = "(tegra)"

S = "${WORKDIR}"

do_compile[noexec] = "1"

do_install() {
    install -d ${D}${datadir}/mender-flash-layout
    install -m 0644 ${S}/flash_mender.xml ${D}${datadir}/mender-flash-layout/
}

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit nopackages
