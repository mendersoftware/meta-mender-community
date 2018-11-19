require recipes-bsp/u-boot/u-boot-mender.inc
require u-boot-mender-nxp.inc

RDEPENDS_${PN}_append_imx7s-warp = " u-boot-scr"
