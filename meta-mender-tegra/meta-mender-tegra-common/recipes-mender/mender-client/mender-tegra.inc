# Under the native scheme the update module talks to nvbootctrl directly, so the
# fw_printenv/fw_setenv shims and the verifier that patches up their limitations
# are not pulled in. The capsule and tegra-redundant-boot are still needed:
# applying the capsule is what switches the boot slot.
EXTRADEPS:tegra = "${@'tegra-uefi-capsules tegra-redundant-boot' if bb.utils.to_boolean(d.getVar('TEGRA_MENDER_NATIVE_UPDATE')) else 'tegra-uefi-capsules libubootenv-fake mender-update-verifier tegra-redundant-boot'}"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:remove:mender-persist-systemd-machine-id = " \
    file://mender-set-systemd-machine-id.sh \
"
SRC_URI:append:mender-persist-systemd-machine-id = " \
    file://tegra-mender-client-set-systemd-machine-id.sh \
    file://efi_systemd_machine_id.sh \
"

do_install:prepend:class-target:mender-persist-systemd-machine-id() {
    install -d -m 755 ${D}${bindir}
    install -m 755 ${UNPACKDIR}/efi_systemd_machine_id.sh ${D}${bindir}/
    cp ${UNPACKDIR}/tegra-mender-client-set-systemd-machine-id.sh ${UNPACKDIR}/mender-set-systemd-machine-id.sh
}
