DESCRIPTION = "Configuration override to disable nv_update_verifier when using Mender"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

COMPATIBLE_MACHINE = "(tegra)"

S = "${WORKDIR}"

do_compile[noexec] = "1"

do_install() {
    install -d ${D}${sysconfdir}/systemd/system/
    ln -sf /dev/null ${D}${sysconfdir}/systemd/system/nv_update_verifier.service
}
