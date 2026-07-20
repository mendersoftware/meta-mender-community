# Mender U-Boot integration for u-boot-xlnx (meta-mender only appends to the
# plain "u-boot" recipe). Pattern per meta-mender-community fork integrations.
require recipes-bsp/u-boot/u-boot-mender.inc

# meta-mender depends on "u-boot" in several places (EXTRA_IMAGEDEPENDS,
# part-image deps, libubootenv do_compile); make the fork satisfy them.
PROVIDES += "u-boot"
RPROVIDES:${PN} += "u-boot"

FILESEXTRAPATHS:prepend := "${THISDIR}/u-boot-xlnx:"

# The Zynq board code only returns FAT/EXT4 env locations for SD boot and
# silently ignores CONFIG_ENV_IS_IN_MMC (Mender's redundant raw-MMC env),
# which would break A/B state and rollback. meta-mender's own boot-code
# patches apply cleanly to u-boot-xlnx 2026.01, so no rebased copy is needed.
SRC_URI:append:arty-z7-20 = " \
    file://0004-zynq-env-get-location-mmc.patch \
    file://mender-bootargs.cfg \
    "
