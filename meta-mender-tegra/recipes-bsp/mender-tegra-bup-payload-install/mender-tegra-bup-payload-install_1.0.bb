LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

UBOOT_SUFFIX ??= "bin"
UBOOT_IMAGE ?= "u-boot-${MACHINE}.${UBOOT_SUFFIX}"

COMPATIBLE_MACHINE = "(tegra186|tegra194)"

BUPFILE = "${@'${INITRD_IMAGE}-${MACHINE}.bup-payload' if d.getVar('PREFERRED_PROVIDER_virtual/bootloader').startswith('cboot') else '${UBOOT_IMAGE}.bup-payload'}"

do_install() {
    install -d ${D}/opt/ota_package/
    install -m 0644 ${DEPLOY_DIR_IMAGE}/${BUPFILE} ${D}/opt/ota_package/bl_update_payload
}

do_install[depends] += "${@'${INITRD_IMAGE}:do_image_complete' if d.getVar('PREFERRED_PROVIDER_virtual/bootloader').startswith('cboot') else 'u-boot-bup-payload:do_deploy'}"
FILES_${PN} = "/opt/ota_package"
RDEPENDS_${PN} += "tegra-redundant-boot"
PACKAGE_ARCH = "${MACHINE_ARCH}"
