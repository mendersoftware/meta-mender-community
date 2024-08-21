FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = "\
    file://nv_update_verifier.sh \
"

do_install:append() {
    install -d ${D}/${sbindir}
    install -m 0755 ${S}/nv_update_verifier.sh ${D}/${sbindir}/nv_update_verifier
}
