DESCRIPTION = "The IPK Update Module installs opkg-based package in the target."

require mender-update-modules.inc

inherit allarch

python do_configure() {
    if not bb.utils.contains('PACKAGE_CLASSES', 'package_ipk', True, False, d) or \
       not bb.utils.contains('IMAGE_FEATURES', 'package-management', True, False, d):
           bb.error("Installing ipk update module without on-target IPK package management.")
           bb.error("Install package management by adding the following to your local.conf:")
           bb.error("     IMAGE_FEATURES_append = \" package-management \"")
           bb.error("Select IPK style packaging using the following:")
           bb.error("     PACKAGE_CLASSES = \"package_ipk\"")
}

do_install_class-target() {
    install -d ${D}/${datadir}/mender/modules/v3
    install -m 755 ${S}/ipk/module/ipk ${D}/${datadir}/mender/modules/v3/ipk
}

FILES_${PN} += "${datadir}/mender/modules/v3/ipk"
