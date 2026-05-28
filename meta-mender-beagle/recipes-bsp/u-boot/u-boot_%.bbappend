FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append:mender-uboot:beaglebone-yocto = " file://reduce-spl-size.cfg "

MENDER_UBOOT_PRE_SETUP_COMMANDS:beaglebone-yocto = "run findfdt; setenv mender_dtb_name \${fdtfile}"
MENDER_UBOOT_PRE_SETUP_COMMANDS:append:beaglebone-yocto:mender-uboot = "; setenv bootargs \${bootargs} rootwait"
