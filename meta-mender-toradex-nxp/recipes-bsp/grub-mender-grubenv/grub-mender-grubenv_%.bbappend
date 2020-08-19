FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI_append_apalis-imx6 = " file://02_apalis_console_grub.cfg;subdir=git"
SRC_URI_append_colibri-imx7-emmc = " file://02_apalis_console_grub.cfg;subdir=git"
