FILESEXTRAPATHS_prepend := "${THISDIR}/u-boot-edm:"

require recipes-bsp/u-boot/u-boot-mender.inc
BOOTENV_SIZE_pico-imx7 = "0x20000"
BOOTENV_SIZE_pico-imx6ul = "0x20000"

SRC_URI_remove_pico-imx7 = " \
    file://0006-env-Kconfig-Add-descriptions-so-environment-options-.patch \
"
SRC_URI_remove_pico-imx6ul = " \
    file://0006-env-Kconfig-Add-descriptions-so-environment-options-.patch \
    file://0003-Integration-of-Mender-boot-code-into-U-Boot.patch \
    file://0004-Disable-CONFIG_BOOTCOMMAND-and-enable-CONFIG_MENDER_.patch \
"
        
SRC_URI_append_pico-imx6ul = " \
    file://0001-edm-Integration-of-Mender-boot-code-into-U-Boot.patch \
    file://0004-U-Boot-pre-2018-Disable-CONFIG_BOOTCOMMAND-and-enable-CONFIG_MENDER_.patch \
"

