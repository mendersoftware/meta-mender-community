SUMMARY = "Mender update module for Zynq-7000 PL bitstreams"
DESCRIPTION = "Installs the 'fpga-bitstream' Mender update module \
(persistent-app style: payload persisted in /data/fpga, programmed via the \
fpga_manager sysfs interface), a shared loader script, and a oneshot systemd \
service that reprograms the PL from /data/fpga at every boot."
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRC_URI = "file://fpga-bitstream \
           file://fpga-load.sh \
           file://fpga-load-on-boot.service \
           "

S = "${WORKDIR}"

inherit systemd

SYSTEMD_SERVICE:${PN} = "fpga-load-on-boot.service"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"

do_install() {
    install -d ${D}${datadir}/mender/modules/v3
    install -m 0755 ${WORKDIR}/fpga-bitstream ${D}${datadir}/mender/modules/v3/fpga-bitstream

    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/fpga-load.sh ${D}${bindir}/fpga-load.sh

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/fpga-load-on-boot.service ${D}${systemd_system_unitdir}/fpga-load-on-boot.service
}

FILES:${PN} += "${datadir}/mender/modules/v3/fpga-bitstream"
