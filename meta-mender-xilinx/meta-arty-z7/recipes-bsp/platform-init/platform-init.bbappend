FILESEXTRAPATHS:prepend := "${THISDIR}/platform-init:"

# ps7_init_gpl.c/.h are taken verbatim from Digilent's own BSP:
# github.com/Digilent/Petalinux-Arty-Z7-20 @ 43dca7d (HSI 2017.4), file
# Arty-Z7-20/project-spec/hw-description/ps7_init_gpl.{c,h}. Cross-checked
# functionally identical (PLL/DDR/MIO) to board/xilinx/zynq/zynq-artyz7/ of
# u-boot-digilent @ 3b9fb209.
COMPATIBLE_MACHINE:arty-z7-20 = "arty-z7-20"

# The base recipe points LIC_FILES_CHKSUM at common-licenses/GPL-2.0, which
# modern poky no longer ships (renamed to GPL-2.0-only/-or-later in honister).
# The shipped ps7_init_gpl.c/.h carry the Xilinx GPL-2.0-or-later header.
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-or-later;md5=fed54355545ffd980b814dab4a3b312c"
