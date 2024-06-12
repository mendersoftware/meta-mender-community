DESCRIPTION = "The SWU Update Module"

require mender-update-modules.inc

inherit allarch

RDEPENDS:${PN} += "jq swupdate-client"

do_configure[noexec] = "1"
do_compile[noexec] = "1"

do_install() {
    install -d ${D}/${datadir}/mender/modules/v3
    install -m 755 ${S}/swu/module/swu ${D}/${datadir}/mender/modules/v3/swu
}

do_install:class-native() {
    install -d ${D}/${bindir}
    install -m 755 ${S}/swu/module-artifact-gen/swu-artifact-gen ${D}/${bindir}/swu-artifact-gen
}

FILES:${PN} += "${datadir}/mender/modules/v3/swu"
FILES:${PN}-class-native += "${bindir}/swu-artifact-gen"

BBCLASSEXTEND = "native"
