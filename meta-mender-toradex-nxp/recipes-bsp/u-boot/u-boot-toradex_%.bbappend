RPROVIDES_${PN} += "u-boot"

MENDER_UBOOT_AUTO_CONFIGURE = "0"

FILESEXTRAPATHS_prepend_mender-uboot := "${THISDIR}/files:"

require recipes-bsp/u-boot/u-boot-mender.inc

