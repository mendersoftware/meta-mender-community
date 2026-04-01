SUMMARY = "Mount unit for Mender data partition"
DESCRIPTION = "Systemd mount unit for the persistent data partition at /data"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRC_URI = "file://data.mount"

S = "${WORKDIR}"

inherit systemd

SYSTEMD_SERVICE:${PN} = "data.mount"

do_install() {
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/data.mount ${D}${systemd_system_unitdir}/data.mount

    install -d ${D}/data
}

FILES:${PN} = " \
    ${systemd_system_unitdir}/data.mount \
    /data \
"
