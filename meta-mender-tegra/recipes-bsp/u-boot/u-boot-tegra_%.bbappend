require recipes-bsp/u-boot/u-boot-mender.inc
require recipes-bsp/u-boot/u-boot-mender-tegra.inc

do_install_append() {
    install -d ${D}/opt/ota_package/
    install -m 0644 ${WORKDIR}/bup-payload/bl_update_payload ${D}/opt/ota_package/bl_update_payload_current
    ln -s /opt/ota_package/bl_update_payload_current ${D}/opt/ota_package/bl_update_payload
}

FILES_${PN} += "/opt/ota_package/bl_update_payload_current"
FILES_${PN} += "/opt/ota_package/bl_update_payload"
RDEPENDS_${PN} += "tegra186-redundant-boot"
RDEPENDS_${PN} += "tegra-state-scripts"
