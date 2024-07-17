require recipes-bsp/u-boot/u-boot-mender.inc

FILESEXTRAPATHS:prepend := "${THISDIR}/u-boot-imx:"

DEPENDS:append = " u-boot-scr"

SRC_URI:append:olimex-imx8mp-evb = " \
	file://0001-configs-olimex-imx8mp-evb-mender-integration.patch \
"

BOOTENV_SIZE:olimex-imx8mp-evb = "0x4000"

MENDER_UBOOT_AUTO_CONFIGURE = "0"
