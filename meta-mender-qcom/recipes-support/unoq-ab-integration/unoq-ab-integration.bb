SUMMARY = "Uno Q A/B integration: persistent /data for Mender, bless-boot gating, qbootctl update module"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = " \
    file://unoq-mender-persist \
    file://unoq-mender-persist.service \
    file://qbootctl-bless-boot-gate.conf \
    file://qbootctl-rootfs \
"

inherit systemd

SYSTEMD_SERVICE:${PN} = "unoq-mender-persist.service"
SYSTEMD_AUTO_ENABLE = "enable"

# qbootctl for the update module; mkfs.ext4 for the /data (userdata) x-systemd.makefs
RDEPENDS:${PN} = "qbootctl e2fsprogs-mke2fs"

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${UNPACKDIR}/unoq-mender-persist ${D}${bindir}/unoq-mender-persist

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${UNPACKDIR}/unoq-mender-persist.service ${D}${systemd_system_unitdir}/

    # drop-in that gates meta-qcom's qbootctl-bless-boot.service during a Mender update
    install -d ${D}${systemd_system_unitdir}/qbootctl-bless-boot.service.d
    install -m 0644 ${UNPACKDIR}/qbootctl-bless-boot-gate.conf \
        ${D}${systemd_system_unitdir}/qbootctl-bless-boot.service.d/10-mender-gate.conf

    # the custom Mender Update Module (payload type == filename)
    install -d ${D}${datadir}/mender/modules/v3
    install -m 0755 ${UNPACKDIR}/qbootctl-rootfs ${D}${datadir}/mender/modules/v3/qbootctl-rootfs
}

FILES:${PN} += " \
    ${systemd_system_unitdir}/qbootctl-bless-boot.service.d/10-mender-gate.conf \
    ${datadir}/mender/modules/v3/qbootctl-rootfs \
"
