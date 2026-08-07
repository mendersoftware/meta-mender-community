FILESEXTRAPATHS:prepend_mender-grub := "${THISDIR}/files:"
SRC_URI:append_mender-grub = " file://01_console_bootargs_grub.cfg;subdir=git"
