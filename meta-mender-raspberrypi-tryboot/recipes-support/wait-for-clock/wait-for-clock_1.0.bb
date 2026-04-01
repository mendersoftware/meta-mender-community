SUMMARY = "Wait for NTP clock sync before Mender services"
DESCRIPTION = "Systemd oneshot service that blocks until the system clock is \
past year 2000, ensuring SSL connections work on RTC-less boards."
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRC_URI = " \
    file://wait-for-clock.service \
    file://mender-authd-wait.conf \
"

inherit systemd

SYSTEMD_SERVICE:${PN} = "wait-for-clock.service"

do_install() {
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/wait-for-clock.service ${D}${systemd_system_unitdir}/

    # Drop-in overrides for mender services
    for svc in mender-authd mender-updated mender-connect; do
        install -d ${D}${systemd_system_unitdir}/${svc}.service.d
        install -m 0644 ${WORKDIR}/mender-authd-wait.conf \
            ${D}${systemd_system_unitdir}/${svc}.service.d/wait-for-clock.conf
    done
}

FILES:${PN} += "${systemd_system_unitdir}"
