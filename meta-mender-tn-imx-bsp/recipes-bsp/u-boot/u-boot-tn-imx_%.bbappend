FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

require recipes-bsp/u-boot/u-boot-mender.inc

SRC_URI_append_pico-imx8mm = " \
    file://0001-configs-pico-imx8mm-add-Mender-support.patch \
"
SRC_URI_append_edm-g-imx8mp = " \
    file://0001-configs-edm-g-imx8mp-add-Mender-support.patch \
"

BOOTENV_SIZE_pico-imx8mm = "0x2000"
BOOTENV_SIZE_edm-g-imx8mp = "0x2000"

MENDER_UBOOT_AUTO_CONFIGURE = "0"
