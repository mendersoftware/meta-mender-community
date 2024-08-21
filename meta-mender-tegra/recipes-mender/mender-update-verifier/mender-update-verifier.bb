DESCRIPTION = "Mender update verifier"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRC_URI = "\
    file://mender-update-verifier.service \
    file://mender-update-verifier.sh \
"

S = "${WORKDIR}"

do_install() {
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${S}/mender-update-verifier.service ${D}${systemd_system_unitdir}
    install -d -m 755 ${D}${bindir}
    install -m 755 ${WORKDIR}/mender-update-verifier.sh ${D}${bindir}/
}

inherit systemd

SYSTEMD_SERVICE:${PN} = "mender-update-verifier.service"
