FILESEXTRAPATHS:prepend := "${THISDIR}/u-boot-xlnx:"

SRC_URI:append:arty-z7-20 = " \
    file://0001-arm-dts-add-zynq-arty-z7-20.patch \
    file://arty-z7-20.cfg \
    "

# With UBOOT_SUFFIX = "img" (SPL payload) no /boot/u-boot*.bin exists, which
# leaves ${PN}-bin empty while ${PN} RDEPENDS on it; let it take the .img.
FILES:${PN}-bin:append:arty-z7-20 = " /boot/u-boot*.img"

# Digilent's generated ps7_init_gpl.c (shipped verbatim from the BSP) uses K&R
# empty parameter lists, e.g. "void ps7_init()". U-Boot hardcodes
# -Werror=strict-prototypes in KBUILD_CFLAGS, which the wrynose toolchain
# (gcc 15) turns into a fatal error. Append -Wno-error=strict-prototypes via
# KCFLAGS (U-Boot folds it in after its own flags, so it wins) to keep the
# vendor file unmodified. U-Boot proper still builds clean under the check.
EXTRA_OEMAKE:append:arty-z7-20 = " KCFLAGS=-Wno-error=strict-prototypes"
