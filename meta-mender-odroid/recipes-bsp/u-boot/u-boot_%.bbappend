FILESEXTRAPATHS:prepend := "${THISDIR}/patches:"

SRC_URI:append_odroid-c2 = " file://0001-configs-meson64-add-Mender-requirements.patch"

MENDER_UBOOT_AUTO_CONFIGURE_odroid-c2 = "0"
BOOTENV_SIZE_odroid-c2 = "0x2000"

DEPENDS:append_odroid-c2 = " odroid-u-boot-scr"
