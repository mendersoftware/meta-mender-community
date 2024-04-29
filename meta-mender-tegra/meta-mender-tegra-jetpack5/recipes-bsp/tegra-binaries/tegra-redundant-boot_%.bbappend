EXTRADEPS = "redundant-boot-overrides"
EXTRADEPS:tegra194 = ""
EXTRADEPS:tegra210 = ""
EXTRADEPS:tegra234 = ""
RDEPENDS:${PN} += "${EXTRADEPS}"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = "\
    file://nv_update_verifier.sh \
"

do_install:append:tegra234() {
    install -d ${D}/${sbindir}
    install -m 0755 ${S}/nv_update_verifier.sh ${D}/${sbindir}/nv_update_verifier
}
