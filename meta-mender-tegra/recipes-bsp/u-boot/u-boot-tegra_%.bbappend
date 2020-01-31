require recipes-bsp/u-boot/u-boot-mender.inc
require recipes-bsp/u-boot/u-boot-mender-tegra.inc

RDEPENDS_${PN} += "mender-tegra-bup-payload-install"
