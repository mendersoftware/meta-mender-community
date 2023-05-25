FILESEXTRAPATHS_prepend := "${THISDIR}/u-boot-imx:"

require recipes-bsp/u-boot/u-boot-mender.inc

SRC_URI_append_imx8mq-voipac = " \
        file://0001-Added-mender-support.patch \
"

MENDER_UBOOT_AUTO_CONFIGURE = "0"


DEPENDS_append = " u-boot-scr"
