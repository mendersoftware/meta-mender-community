FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

require recipes-bsp/u-boot/u-boot-mender.inc

SRC_URI += "file://0001-u-boot-config-for-mender-layer.patch \
            file://0001-mender-config-in-stm32mp15_defconfig.patch \
            "


MENDER_UBOOT_AUTO_CONFIGURE = "0"

# 8K
BOOTENV_SIZE = "0x2000"

DEPENDS:append = " stm32mp-uboot-scr"

# Upstream PR: https://github.com/STMicroelectronics/meta-st-stm32mp/pull/11
PROVIDES += "u-boot"
RPROVIDES:${PN} += "u-boot"


