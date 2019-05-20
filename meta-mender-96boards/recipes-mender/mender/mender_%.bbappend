FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://mender-device-identity"

do_install_append() {
    install -t ${D}/${datadir}/mender/identity -m 0755 \
        ${WORKDIR}/mender-device-identity
}
