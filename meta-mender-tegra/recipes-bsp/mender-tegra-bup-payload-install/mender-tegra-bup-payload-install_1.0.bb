LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

UBOOT_IMAGE ?= "u-boot-${MACHINE}.${UBOOT_SUFFIX}"

do_install() {
    install -d ${D}/opt/ota_package/
    install -m 0644 ${DEPLOY_DIR_IMAGE}/${UBOOT_IMAGE}.bup-payload ${D}/opt/ota_package/bl_update_payload_current
    ln -s /opt/ota_package/bl_update_payload_current ${D}/opt/ota_package/bl_update_payload
}

do_install[depends] += "u-boot-bup-payload:do_deploy"
FILES_${PN} += "/opt/ota_package/bl_update_payload_current"
FILES_${PN} += "/opt/ota_package/bl_update_payload"
RDEPENDS_${PN} += "tegra186-redundant-boot"
RDEPENDS_${PN} += "tegra-state-scripts"
