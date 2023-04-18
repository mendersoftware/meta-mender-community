require recipes-bsp/u-boot/u-boot-mender.inc
require u-boot-mender-atmel.inc

DEPENDS:append:sama5d27-som1-ek-sd = " openssl-native"