SUMMARY = "ESP mount point and UEFI boot entry for U-Boot EFI on x86-64"
DESCRIPTION = "Creates the /uboot mount point and a first-boot service that \
registers U-Boot as a persistent UEFI boot entry via efibootmgr. This ensures \
OVMF can find and boot U-Boot after guest reboots."
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = " \
    file://uboot-efi-bootentry.sh \
    file://uboot-efi-bootentry.service \
"

inherit systemd

SYSTEMD_SERVICE:${PN} = "uboot-efi-bootentry.service"
RDEPENDS:${PN} = "efibootmgr"

do_install() {
    # Create ESP mount point
    install -d ${D}/uboot

    # Install the boot entry creation script
    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/uboot-efi-bootentry.sh ${D}${bindir}/uboot-efi-bootentry.sh

    # Install the systemd service
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/uboot-efi-bootentry.service ${D}${systemd_system_unitdir}/uboot-efi-bootentry.service
}

FILES:${PN} = " \
    /uboot \
    ${bindir}/uboot-efi-bootentry.sh \
    ${systemd_system_unitdir}/uboot-efi-bootentry.service \
"
