# Add Rockchip RK3568 EVB support to optee-client
COMPATIBLE_MACHINE:rockchip-rk3568-evb = "rockchip-rk3568-evb"
COMPATIBLE_MACHINE:rock-4c-plus = "rock-4c-plus"

# Move fTPM NV storage from /var/lib/tee (rootfs, wiped on A/B flip) to
# /data/tee (persistent data partition, survives A/B flips).
EXTRA_OECMAKE:append = " -DCFG_TEE_FS_PARENT_PATH=/data/tee"

# Enable and start tee-supplicant service on boot
SYSTEMD_AUTO_ENABLE:${PN} = "enable"

# The service is templated (@.service), so we need to enable a specific instance
# For OP-TEE, typically use tee-supplicant@opteedev0.service
do_install:append() {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
        install -d ${D}${sysconfdir}/systemd/system/multi-user.target.wants
        ln -sf ${systemd_system_unitdir}/tee-supplicant@.service \
            ${D}${sysconfdir}/systemd/system/multi-user.target.wants/tee-supplicant@opteedev0.service

        # Order tee-supplicant AFTER data.mount so /data/tee is available for fTPM NV.
        # Also create /data/tee before starting the supplicant.
        install -d ${D}${sysconfdir}/systemd/system/tee-supplicant@opteedev0.service.d
        printf '[Unit]\nAfter=data.mount\nRequires=data.mount\n\n[Service]\nExecStartPre=/bin/mkdir -p /data/tee\n' \
            > ${D}${sysconfdir}/systemd/system/tee-supplicant@opteedev0.service.d/data-tee.conf

        # Order data.mount BEFORE cryptsetup-pre.target so the dependency chain works:
        # cryptsetup-pre.target -> load-ftpm-tee -> tee-supplicant -> data.mount
        install -d ${D}${sysconfdir}/systemd/system/data.mount.d
        printf '[Unit]\nBefore=cryptsetup-pre.target\n' \
            > ${D}${sysconfdir}/systemd/system/data.mount.d/before-cryptsetup.conf
    fi
}

FILES:${PN} += " \
    ${sysconfdir}/systemd/system/multi-user.target.wants/ \
    ${sysconfdir}/systemd/system/tee-supplicant@opteedev0.service.d/ \
    ${sysconfdir}/systemd/system/data.mount.d/ \
"
