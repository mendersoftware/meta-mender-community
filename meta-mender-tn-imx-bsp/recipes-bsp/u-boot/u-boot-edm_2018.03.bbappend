FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

require recipes-bsp/u-boot/u-boot-mender.inc

SRC_URI_append_pico-imx8mq = " \
    file://0001-configs-pico-imx8mq-add-Mender-support.patch \
"

BOOTENV_SIZE_pico-imx8mq = "0x8000"

MENDER_UBOOT_AUTO_CONFIGURE = "0"
