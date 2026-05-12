require recipes-bsp/u-boot/u-boot-mender.inc

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

MENDER_UBOOT_AUTO_CONFIGURE = "0"
PROVIDES += "u-boot"
RPROVIDES:${PN} += "u-boot"
PREFERRED_PROVIDER:u-boot = "u-boot-stm32mp"
PREFERRED_PROVIDER:virtual/bootloader="u-boot-stm32mp"

SRC_URI:append:stm32mp2-dk-mender-emmc = " file://0002-Env-offset-for-emmc.patch \
            file://0003-Mender-Uboot-clean-changes.patch \
            "

SRC_URI:append = " file://0004-Force-mender-boot.patch \
            file://0005-Relax-config-mender-checks.patch \
            file://0006-Add-uboot-env-to-control-rollback.patch \
            "
