require recipes-bsp/u-boot/u-boot-variscite-mender-common.inc
require recipes-bsp/u-boot/u-boot-mender.inc

DEPENDS:append = " bc-native "

MENDER_UBOOT_AUTO_CONFIGURE:imx8mm-var-dart = "0"