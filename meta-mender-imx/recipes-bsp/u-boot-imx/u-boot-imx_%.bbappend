FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

include ${@mender_feature_is_enabled("mender-uboot","recipes-bsp/u-boot/u-boot-mender.inc","",d)}

RPROVIDES_${PN}_mender-grub += "u-boot"
RPROVIDES_${PN}_mender-uboot += "u-boot"

SRC_URI_append_imx8mnevk = " file://0001-Switch-to-CONFIG_DISTRO_DEFAULTS-for-bootcmd.patch "

MENDER_UBOOT_AUTO_CONFIGURE = "0"
