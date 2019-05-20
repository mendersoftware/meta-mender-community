FILESEXTRAPATHS_prepend := "${THISDIR}/patches:"

PROVIDES += "u-boot"
RPROVIDES_${PN} += "u-boot"

require recipes-bsp/u-boot/u-boot-mender.inc

SRC_URI_append_poplar = " file://0001-configs-poplar-integrate-Mender.patch"

# u-boot-poplar is based on 2017.09 and this patch does not apply
SRC_URI_remove_poplar = "file://0006-env-Kconfig-Add-descriptions-so-environment-options-.patch"

MENDER_UBOOT_AUTO_CONFIGURE_poplar = "0"
BOOTENV_SIZE_poplar ?= "0x10000"
