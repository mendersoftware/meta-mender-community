require recipes-bsp/u-boot/u-boot-mender.inc
require recipes-bsp/u-boot/u-boot-mender-tegra.inc

BUPDEP = ""
BUPDEP_tegra186 = "mender-tegra-bup-payload-install"
BUPDEP_tegra194 = "mender-tegra-bup-payload-install"
RDEPENDS_${PN} += "${BUPDEP}"

