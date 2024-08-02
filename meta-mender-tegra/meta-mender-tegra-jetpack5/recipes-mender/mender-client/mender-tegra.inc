EXTRADEPS:tegra = "tegra-bup-payload tegra-uefi-capsules libubootenv-fake mender-update-verifier"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:remove:mender-persist-systemd-machine-id = " \
    file://mender-client-set-systemd-machine-id.sh \
"
SRC_URI:append:mender-persist-systemd-machine-id = " \
    file://tegra-mender-client-set-systemd-machine-id.sh \
    file://efi_systemd_machine_id.sh \
"

do_install:prepend:class-target:mender-persist-systemd-machine-id() {
    install -d -m 755 ${D}${bindir}
    install -m 755 ${WORKDIR}/efi_systemd_machine_id.sh ${D}${bindir}/
    cp ${WORKDIR}/tegra-mender-client-set-systemd-machine-id.sh ${WORKDIR}/mender-client-set-systemd-machine-id.sh 
}
