require recipes-bsp/u-boot/u-boot-mender.inc
require u-boot-mender-nxp.inc

DEPENDS_append = " u-boot-scr"
