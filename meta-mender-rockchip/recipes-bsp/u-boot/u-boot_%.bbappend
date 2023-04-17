FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

MENDER_UBOOT_AUTO_CONFIGURE = "0"

SRC_URI += "\
	file://0001-Mender-updates.patch \
	file://0002-firefly-rk3288-Drop-ENV_OFFSET.patch \
	file://0003-rock-pi-e-Drop-ENV_OFFSET.patch \
	file://boot.cmd \
"

# setup name for u-boot script
UBOOT_ENV_SUFFIX = "scr"
UBOOT_ENV = "boot"
