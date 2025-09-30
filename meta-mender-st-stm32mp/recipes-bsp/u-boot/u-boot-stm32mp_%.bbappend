require recipes-bsp/u-boot/u-boot-mender.inc
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

MENDER_UBOOT_AUTO_CONFIGURE = "0"
PROVIDES += "u-boot"
RPROVIDES:${PN} += "u-boot"
PREFERRED_PROVIDER:u-boot = "u-boot-stm32mp"
PREFERRED_PROVIDER:virtual/bootloader="u-boot-stm32mp"

SRC_URI += "file://0002-Force-mender-boot.patch file://0001-Mender-env-setup-sdcard.patch"

