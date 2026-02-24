FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append:seeed-reterminal-mender = " \
    file://0001-overlays-add-reTerminal-dtbo-to-Makefile.patch \
    file://enable-audio.cfg \
    file://vc4graphics.cfg \
    file://reTerminal-overlay.dts \
"

do_configure:append:seeed-reterminal-mender() {
    cp ${WORKDIR}/reTerminal-overlay.dts ${S}/arch/arm/boot/dts/overlays/
}
