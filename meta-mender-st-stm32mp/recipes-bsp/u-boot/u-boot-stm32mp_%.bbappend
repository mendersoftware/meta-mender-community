FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}-${PV}:"

require recipes-bsp/u-boot/u-boot-mender.inc

# u-boot-stm32mp is "newer" and this is not needed.
SRC_URI_remove = "file://0006-env-Kconfig-Add-descriptions-so-environment-options-.patch"

SRC_URI_append = " \
    file://0001-stm32mp1-enable-Mender-requirements.patch \
    file://0002-stm32mp1-remove-env_get_location-override.patch \
"

MENDER_UBOOT_AUTO_CONFIGURE = "0"

# 8K
BOOTENV_SIZE = "0x2000"

DEPENDS_append = " stm32mp-uboot-scr"

# Upstream PR: https://github.com/STMicroelectronics/meta-st-stm32mp/pull/11
PROVIDES += "u-boot"
RPROVIDES_${PN} += "u-boot"
