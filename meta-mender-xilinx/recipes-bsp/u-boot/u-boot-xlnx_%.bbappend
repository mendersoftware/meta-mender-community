# Mender U-Boot integration for u-boot-xlnx (meta-mender only appends to the
# plain "u-boot" recipe). Pattern per meta-mender-community fork integrations.
require recipes-bsp/u-boot/u-boot-mender.inc

# meta-mender depends on "u-boot" in several places (EXTRA_IMAGEDEPENDS,
# part-image deps, libubootenv do_compile); make the fork satisfy them.
PROVIDES += "u-boot"
RPROVIDES:${PN} += "u-boot"

FILESEXTRAPATHS:prepend := "${THISDIR}/u-boot-xlnx:"

# meta-mender's 0002 patch only applies with fuzz against u-boot-xlnx
# 2025.01 (patch-fuzz QA is fatal); carry a rebased copy instead. The env
# patch is numbered 0004: meta-mender's 0001 and 0003 apply before it.
SRC_URI:remove:arty-z7-20 = "file://0002-Integration-of-Mender-boot-code-into-U-Boot.patch"

# The Zynq board code only returns FAT/EXT4 env locations for SD boot and
# silently ignores CONFIG_ENV_IS_IN_MMC (Mender's redundant raw-MMC env),
# which would break A/B state and rollback.
SRC_URI:append:arty-z7-20 = " \
    file://0002-Integration-of-Mender-boot-code-into-U-Boot-xlnx-2025.01.patch \
    file://0004-zynq-env-get-location-mmc.patch \
    file://mender-bootargs.cfg \
    "
