FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://flash_l4t_t186.custom.xml"

do_preconfigure_append() {
    cp ${WORKDIR}/flash_l4t_t186.custom.xml ${S}/
}

