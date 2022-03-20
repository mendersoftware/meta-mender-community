BOOTENV_SIZE = "0x2000"

FILESEXTRAPATHS:prepend := "${THISDIR}/patches:"

SRC_URI += "file://0001-configs-clearfog-Mender-integration.patch"

SRC_URI:remove = "file://0003-Integration-of-Mender-boot-code-into-U-Boot.patch"
SRC_URI:append = " file://0001-Integration-of-Mender-boot-code-into-U-Boot.patch"

