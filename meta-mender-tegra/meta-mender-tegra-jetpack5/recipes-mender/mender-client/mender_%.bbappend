require mender-tegra.inc

RDEPENDS:mender-update += "${EXTRADEPS}"

FILES:mender-update:append:mender-persist-systemd-machine-id = " \
    ${bindir}/efi_systemd_machine_id.sh \
"