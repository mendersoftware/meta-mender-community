FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

require recipes-bsp/u-boot/u-boot-mender.inc

DEPENDS += "u-boot-script-boundary"

MENDER_UBOOT_AUTO_CONFIGURE = "0"
BOOTENV_SIZE = "0x2000"

SRC_URI += "\
    file://0001-ARM-nitrogen8m-Add-support-to-mender.patch \
"
