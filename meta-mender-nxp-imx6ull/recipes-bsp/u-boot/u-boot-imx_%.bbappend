require recipes-bsp/u-boot/u-boot-mender.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

# GCC Patch - see https://groups.google.com/a/lists.mender.io/forum/#!topic/mender/p54Sv7nbfjk
SRC_URI += "file://default-gcc.patch"

