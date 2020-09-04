FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

require recipes-bsp/u-boot/u-boot-mender.inc

DEPENDS += "u-boot-script-boundary"

MENDER_UBOOT_AUTO_CONFIGURE = "0"
BOOTENV_SIZE = "0x2000"

SRC_URI_remove = "\
    ${@bb.utils.contains('DISTRO', 'b2qt', 'file://0001-Add-support-for-KOE-tx31d200vm0baa-display.patch', '', d)} \
"

SRC_URI += "\
    ${@bb.utils.contains('DISTRO', 'b2qt', 'file://0001-Mender-Add-support-for-KOE-tx31d200vm0baa-display.patch', '', d)} \
    file://0001-ARM-nitrogen8m-Add-support-to-mender.patch \
"
