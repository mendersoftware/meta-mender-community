DESCRIPTION = "Custom flash layout file to add Mender-specific partitions"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRC_URI = "file://flash_mender.xml"

INHIBIT_DEFAULT_DEPS = "1"
COMPATIBLE_MACHINE = "(tegra)"

def l4t_ver_extrapath(d):
    l4t_ver = d.getVar('L4T_VERSION')
    if not l4t_ver:
        return ''
    try:
        l4t_vernum = [int(n) for n in l4t_ver.split('.')]
        if l4t_vernum[0] != 32:
            return ''
        if l4t_vernum[1] == 5 and l4t_vernum[2] == 2:
           return d.expand('${THISDIR}/${BPN}-32-5-2:')
        elif l4t_vernum[1] >= 6:
           return d.expand('${THISDIR}/${BPN}-32-6-1-and-later:')
    except (IndexError, ValueError):
        return ''

FILESEXTRAPATHS_prepend := "${@l4t_ver_extrapath(d)}"

S = "${WORKDIR}"

do_compile[noexec] = "1"

do_install() {
    install -d ${D}${datadir}/mender-flash-layout
    install -m 0644 ${S}/flash_mender.xml ${D}${datadir}/mender-flash-layout/
}

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit nopackages
