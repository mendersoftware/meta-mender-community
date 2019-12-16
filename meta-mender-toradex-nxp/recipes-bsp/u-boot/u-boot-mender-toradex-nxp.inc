FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

MENDER_UBOOT_AUTO_CONFIGURE = "0"

# # Toradex BSP is using 2016.11 U-Boot, no need for this (origin in meta-mender)
SRC_URI_remove = "file://0006-env-Kconfig-Add-descriptions-so-environment-options-.patch"

# Toradex BSP is using 2016.11 U-Boot, need to apply a patch that matches our version
SRC_URI_remove = "file://0003-Integration-of-Mender-boot-code-into-U-Boot.patch"
SRC_URI_append = " file://0003-U-Boot-pre-2017.03-integration-of-Mender-boot-code-i.patch"

# 128kB
BOOTENV_SIZE_vf ?= "0x20000"

SRC_URI_append_vf = " \
    file://0001-configs-colibri_vf-adjust-for-Mender-requirements.patch \
    file://0002-configs-colibri_vf-increase-SYS_MALLOC_LEN-to-8-MB.patch \
    file://0003-colibri_vf-disable-FIT-image-enable-UBIFS.patch \
"

SRC_URI_append_mx7 = " file://0001-Set-default-display-resolution-to-800x480-WVGA.patch"

# 128kB
BOOTENV_SIZE_colibri-imx7 ?= "0x20000"

SRC_URI_append_colibri-imx7 = " \
    file://0001-colibri-imx7-mender-integration-primer-enable-BOOTCO.patch \
    file://0002-colibri-imx7-set-CONFIG_ENV_RANGE-to-cover-2-environ.patch \
    file://0003-colibri-imx7-mender-integration-override-ubiboot-and.patch \
    file://0001-Reduce-ENV_SIZE-to-fit-2-copies.patch \
    file://0001-Reenable-CONFIG_ENV_OFFSET-for-colibri-imx7.patch \
"

# 8kB
BOOTENV_SIZE_colibri-imx7-emmc ?= "0x2000"

SRC_URI_append_colibri-imx7-emmc = " file://0001-colibri-imx7-emmc-mender-integration-patch.patch"

MENDER_UBOOT_PRE_SETUP_COMMANDS_apalis-imx6 = "setenv loadaddr \${kernel_addr_r}; run setup; setenv bootargs \${defargs} \${emmcargs} \${setupargs} \${vidargs}; "
