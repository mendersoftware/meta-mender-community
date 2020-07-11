require recipes-bsp/u-boot/u-boot-mender.inc
require recipes-bsp/u-boot/u-boot-mender-tegra.inc
require recipes-bsp/u-boot/u-boot-mender-tegra-vars.inc

BUPDEP = ""
BUPDEP_tegra186 = "tegra-bup-payload"
BUPDEP_tegra194 = "tegra-bup-payload"
RDEPENDS_${PN} += "${BUPDEP}"

