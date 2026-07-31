require mender-tegra.inc

# What the client needs on Tegra whichever scheme is selected. The scheme layers
# append what only they need; :append fragments from several layers merge, which
# is what lets each of them contribute without knowing about the others.
RDEPENDS:mender-update:append:tegra = " tegra-redundant-boot"

FILES:mender-update:append:mender-persist-systemd-machine-id = " \
    ${bindir}/efi_systemd_machine_id.sh \
"