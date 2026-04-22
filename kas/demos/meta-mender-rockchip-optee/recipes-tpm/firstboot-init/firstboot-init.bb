SUMMARY = "TPM-based encrypted partition setup service"
DESCRIPTION = "Systemd service that runs on boot to set up TPM-based disk encryption on the persistent partition"
HOMEPAGE = "https://github.com/mendersoftware/meta-mender-community"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit systemd

SRC_URI = " \
    file://crypttab \
    file://firstboot-init.sh \
    file://firstboot-init.service \
    file://check-ftpm.sh \
    file://load-ftpm-tee.service \
    file://blacklist-tpm-ftpm-tee.conf \
    file://override.conf \
"

S = "${WORKDIR}"

SYSTEMD_SERVICE:${PN} = "firstboot-init.service load-ftpm-tee.service"

# Runtime dependencies
RDEPENDS:${PN} = " \
    cryptsetup \
    e2fsprogs \
    e2fsprogs-mke2fs \
    util-linux-blkid \
    util-linux-lsblk \
    openssl \
    coreutils \
"

do_install() {
    # Install the initialization script
    install -d ${D}${sbindir}
    install -m 0755 ${S}/firstboot-init.sh ${D}${sbindir}/firstboot-init.sh
    install -m 0755 ${S}/check-ftpm.sh ${D}${sbindir}/check-ftpm.sh
    
    # Install the systemd services
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${S}/firstboot-init.service ${D}${systemd_system_unitdir}/firstboot-init.service
    install -m 0644 ${S}/load-ftpm-tee.service ${D}${systemd_system_unitdir}/load-ftpm-tee.service

    # Install module blacklist to prevent auto-loading before tee-supplicant is ready
    install -d ${D}${sysconfdir}/modprobe.d
    install -m 0644 ${S}/blacklist-tpm-ftpm-tee.conf ${D}${sysconfdir}/modprobe.d/blacklist-tpm-ftpm-tee.conf

    # Install the crypttab
    install -d ${D}${sysconfdir}
    install -m 0400 ${S}/crypttab ${D}${sysconfdir}

    # Install systemd-cryptsetup@static override so the ordering/TPM wait is
    # always present on every rootfs, not just written at runtime by firstboot-init.sh
    install -d ${D}${sysconfdir}/systemd/system/systemd-cryptsetup@static.service.d
    install -m 0644 ${S}/override.conf \
        ${D}${sysconfdir}/systemd/system/systemd-cryptsetup@static.service.d/override.conf
}