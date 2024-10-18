require recipes-bsp/u-boot/u-boot-mender.inc

FILESEXTRAPATHS:prepend := "${THISDIR}/u-boot-imx:"

DEPENDS:append = " u-boot-scr"

SRC_URI:append:olimex-imx8mp-evb = " \
	file://0001-configs-olimex-imx8mp-evb-mender-integration.patch \
"

SRC_URI:append:imx93-voipac = " \
	file://0001-imx93-voipac-evk-Enable-various-configuration-for-me.patch \
"

BOOTENV_SIZE:olimex-imx8mp-evb = "0x4000"
BOOTENV_SIZE:imx93-voipac = "0x20000"

MENDER_UBOOT_ENV_STORAGE_DEVICE_OFFSET:imx93-voipac = "0x700000"
MENDER_UBOOT_ENV_STORAGE_DEVICE_OFFSET_2:imx93-voipac = "0x740000"

MENDER_UBOOT_AUTO_CONFIGURE = "0"
