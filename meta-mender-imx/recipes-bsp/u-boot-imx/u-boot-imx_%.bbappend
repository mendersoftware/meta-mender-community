FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

RPROVIDES_${PN}_mender-grub += "u-boot"
RPROVIDES_${PN}_mender-uboot += "u-boot"

SRC_URI_append_imx8mnevk = " file://0001-Switch-to-CONFIG_DISTRO_DEFAULTS-for-bootcmd.patch "
