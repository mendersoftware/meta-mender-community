DESCRIPTION = "The Directory Overlay Update Module installs a user defined file tree structure into a given destination directory in the target."

require mender-update-modules.inc

inherit allarch

do_install_class-target() {
    install -d ${D}/${datadir}/mender/modules/v3
    install -m 755 ${S}/dir-overlay/module/dir-overlay ${D}/${datadir}/mender/modules/v3/dir-overlay
}

do_install_class-native() {
    install -d ${D}/${bindir}
    install -m 755 ${S}/dir-overlay/module-artifact-gen/dir-overlay-artifact-gen ${D}/${bindir}/dir-overlay-artifact-gen
}

FILES_${PN} += "${datadir}/mender/modules/v3/dir-overlay"
FILES_${PN}-class-native += "${bindir}/dir-overlay-artifact-gen"

BBCLASSEXTEND = "native"
