DESCRIPTION = "Configuration override to disable nv_update_verifier when using Mender"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

COMPATIBLE_MACHINE = "(tegra)"
COMPATIBLE_MACHINE_tegra210 = "(-)"

SRC_URI = "\
    file://update-nvbootctrl.service.in \
    file://update-nvbootctrl.sh.in \
"

inherit systemd

S = "${WORKDIR}"
B = "${WORKDIR}/build"

run_sed() {
    outfile=$(basename "$1" .in)
    sed -e's,@SBINDIR@,${sbindir},g' \
        -e's,@LOCALSTATEDIR@,${localstatedir},g' "$1" > ${B}/$outfile
}

do_configure() {
    run_sed ${S}/update-nvbootctrl.service.in
    run_sed ${S}/update-nvbootctrl.sh.in
}

do_compile[noexec] = "1"

do_install() {
    install -d ${D}${sysconfdir}/systemd/system/
    ln -sf /dev/null ${D}${sysconfdir}/systemd/system/nv_update_verifier.service
    install -d ${D}${systemd_system_unitdir} ${D}${sbindir}
    install -m 0755 ${B}/update-nvbootctrl.sh ${D}${sbindir}/update-nvbootctrl
    install -m 0644 ${B}/update-nvbootctrl.service ${D}${systemd_system_unitdir}/
}

SYSTEMD_SERVICE:${PN} = "update-nvbootctrl.service"
