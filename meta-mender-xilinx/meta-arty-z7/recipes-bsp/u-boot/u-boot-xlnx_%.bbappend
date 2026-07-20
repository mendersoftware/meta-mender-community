FILESEXTRAPATHS:prepend := "${THISDIR}/u-boot-xlnx:"

SRC_URI:append:arty-z7-20 = " \
    file://0001-arm-dts-add-zynq-arty-z7-20.patch \
    file://arty-z7-20.cfg \
    "

# With UBOOT_SUFFIX = "img" (SPL payload) no /boot/u-boot*.bin exists, which
# leaves ${PN}-bin empty while ${PN} RDEPENDS on it; let it take the .img.
FILES:${PN}-bin:append:arty-z7-20 = " /boot/u-boot*.img"
