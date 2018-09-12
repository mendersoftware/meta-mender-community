FILESEXTRAPATHS_prepend_r8a7796 := "${THISDIR}/patches:"

BOOTENV_SIZE_r8a7796 ?= "0x20000"

MENDER_UBOOT_AUTO_CONFIGURE = "0"

SRC_URI_remove = "file://0003-Integration-of-Mender-boot-code-into-U-Boot.patch"
SRC_URI_append = " file://0003-U-Boot-pre-2017.03-integration-of-Mender-boot-code-i.patch"

SRC_URI_append_r8a7796 = " file://0001-CONFIGS-r8a7796-enable-mender-requirements.patch"

SRC_URI += "\
    file://default-gcc.patch \
    file://fix-build-under-gcc6.patch \
    file://0001-ARM-rcar_gen3-do-not-error-out-if-ARCH-is-not-define.patch \
"
