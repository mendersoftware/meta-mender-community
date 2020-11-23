FILESEXTRAPATHS_prepend_mender-grub := "${THISDIR}/files:"
SRC_URI_append_mender-grub = " file://01_console_bootargs_grub.cfg;subdir=git"
