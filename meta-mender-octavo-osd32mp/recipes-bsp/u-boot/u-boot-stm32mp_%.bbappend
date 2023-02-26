FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

require recipes-bsp/u-boot/u-boot-mender.inc

#
# These patches must be used for the osd32mp1 with emmc
SRC_URI:append:osd32mp1-emmc-mender = " \
    file://1001-add-osd32mp1-red.patch \
    file://1002-u-boot-config-for-mender.patch \
    file://1003-enable-mender-bootcmd.patch \
    file://1004-disable-config-is-nowhere-sanity-check.patch \
"

MENDER_UBOOT_AUTO_CONFIGURE = "0"
