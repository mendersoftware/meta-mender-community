RPROVIDES_${PN}_mender-uboot += "u-boot"

MENDER_UBOOT_AUTO_CONFIGURE = "0"

FILESEXTRAPATHS_prepend_mender-uboot := "${THISDIR}/files:"
SRC_URI_append_mender-uboot_colibri-imx7 = " \
	file://0001-Set-default-display-resolution-to-800x480-WVGA.patch \
"
MENDER_UBOOT_PRE_SETUP_COMMANDS_mender-uboot_colibri-imx7 = "setenv fdtfile ${KERNEL_DEVICETREE}"

require recipes-bsp/u-boot/u-boot-mender.inc

SRC_URI_remove_mender-uboot = " \
    file://0003-Integration-of-Mender-boot-code-into-U-Boot.patch \
"
SRC_URI_append_mender-uboot = " \
    file://0001-toradex-Integration-of-Mender-boot-code-into-U-Boot.patch \
"

SRC_URI_append_mender-uboot_colibri-imx7 = " \
    file://0001-colibri-imx7-mender-manual-U-boot-integration.patch \
"
