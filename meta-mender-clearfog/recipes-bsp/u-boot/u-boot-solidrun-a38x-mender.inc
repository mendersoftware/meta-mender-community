BOOTENV_SIZE = "0x2000"

FILESEXTRAPATHS_prepend := "${THISDIR}/patches:"

SRC_URI += "file://0001-configs-clearfog-Mender-integration.patch"

SRC_URI_remove = "file://0003-Integration-of-Mender-boot-code-into-U-Boot.patch"
SRC_URI_append = " file://0001-Integration-of-Mender-boot-code-into-U-Boot.patch"

