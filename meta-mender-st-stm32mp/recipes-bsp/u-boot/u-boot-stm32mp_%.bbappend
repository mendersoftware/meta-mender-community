require recipes-bsp/u-boot/u-boot-mender.inc

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

MENDER_UBOOT_AUTO_CONFIGURE = "0"
PROVIDES += "u-boot"
RPROVIDES:${PN} += "u-boot"
PREFERRED_PROVIDER:u-boot = "u-boot-stm32mp"
PREFERRED_PROVIDER:virtual/bootloader="u-boot-stm32mp"



SRC_URI += " file://0002-Force-mender-boot.patch "


SRC_URI:append:stm32mp2-dk-mender = " file://0001-Mender-env-setup-sdcard.patch "

SRC_URI:append:stm32mp2-dk-mender-emmc = " file://0001-Env-offset-for-emmc.patch file://0001-Mender-Uboot-clean-changes.patch "
