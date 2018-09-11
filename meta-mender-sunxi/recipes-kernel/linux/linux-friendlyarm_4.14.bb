inherit kernel
require recipes-kernel/linux/linux-yocto.inc

REVISION = "7e5420c352680fc7af329828f4155481bd5c11ad"
SRC_URI = "\
    https://github.com/friendlyarm/linux/archive/${REVISION}.zip \
    file://defconfig \
    "

# Since we're not using git, this doesn't make a difference, but we need to fill
# in something or kernel-yocto.bbclass will fail.
KBRANCH ?= "sunxi-4.14.y"

SRC_URI[md5sum] = "9171d7c2029f151b622354533fec6ed5"
SRC_URI[sha256sum] = "fcb7ef9069d22a9ca0f76a94747d1ac4ac0f4c8e7a5e7323dc7c19be0f73db62"

S = "${WORKDIR}/linux-${REVISION}"

LINUX_VERSION ?= "4.14.52"
LINUX_VERSION_EXTENSION_append = "-friendlyarm"

PV = "${LINUX_VERSION}+git${REVISION}"

#KBUILD_DEFCONFIG_nanopi-m1-plus ?= "sunxi_defconfig"
KCONFIG_MODE = "--alldefconfig"

COMPATIBLE_MACHINE = "nanopi-m1-plus"
