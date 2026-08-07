EXTRADEPS = ""
EXTRADEPS:tegra = "tegra-uefi-capsules libubootenv-fake mender-update-verifier tegra-redundant-boot"

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
