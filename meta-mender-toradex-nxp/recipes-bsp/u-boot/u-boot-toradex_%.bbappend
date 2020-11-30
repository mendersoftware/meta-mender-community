FILESEXTRAPATHS_prepend_mender-uboot := "${THISDIR}/files:"

require recipes-bsp/u-boot/u-boot-mender.inc

SRC_URI_append_mender-uboot_verdin-imx8mm = " file://0001-configs-verdin-imx8mm-mender-integration.patch"

MENDER_UBOOT_AUTO_CONFIGURE_mender-uboot = "0"
BOOTENV_SIZE_mender-uboot = "0x2000"

RPROVIDES_${PN} += "u-boot"
