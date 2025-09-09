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
"

S = "${WORKDIR}"

SYSTEMD_SERVICE:${PN} = "firstboot-init.service"

# Runtime dependencies
RDEPENDS:${PN} = " \
    cryptsetup \
    systemd-crypt \
    tpm2-tools \
"

do_install() {
    # Install the initialization script
    install -d ${D}${sbindir}
    install -m 0755 ${S}/firstboot-init.sh ${D}${sbindir}/firstboot-init.sh
    
    # Install the systemd service
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${S}/firstboot-init.service ${D}${systemd_system_unitdir}/firstboot-init.service

    # Install the crypttab
    install -d ${D}${sysconfdir}
    install -m 0400 ${S}/crypttab ${D}${sysconfdir}
}