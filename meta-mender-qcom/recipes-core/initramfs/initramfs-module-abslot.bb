SUMMARY = "initramfs-framework module: Uno Q A/B slot-aware root selection"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://86-abslot"

RDEPENDS:${PN} = "initramfs-framework-base qbootctl"

do_install() {
    install -d ${D}/init.d
    install -m 0755 ${UNPACKDIR}/86-abslot ${D}/init.d/86-abslot
}

FILES:${PN} = "/init.d/86-abslot"
