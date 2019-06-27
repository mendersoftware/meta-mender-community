FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI = "file://redundant-boot-reboot-state-script;subdir=${PN}-${PV} \
          file://mender-install-manual;subdir=${PN}-${PV} \
          "

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

inherit mender-state-scripts

do_compile() {
    cp redundant-boot-reboot-state-script ${MENDER_STATE_SCRIPTS_DIR}/ArtifactReboot_Enter_50
}

base_do_install_append() {
    install -d ${D}${base_sbindir}
    install -m 755 redundant-boot-reboot-state-script ${D}${base_sbindir}/
    install -m 755 mender-install-manual ${D}${base_sbindir}/
}

FILES_${PN} += "${base_sbindir}/redundant-boot-reboot-state-script"
FILES_${PN} += "${base_sbindir}/mender-install-manual"
