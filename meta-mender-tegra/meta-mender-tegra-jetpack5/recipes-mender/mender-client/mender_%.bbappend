require mender-tegra.inc

FILES:mender-update:append:mender-persist-systemd-machine-id = " \
    ${bindir}/efi_systemd_machine_id.sh \
"