require mender-tegra.inc

# What the client needs on Tegra beyond what meta-mender pulls in itself. Stated
# here rather than routed through a variable the .inc sets, because :append
# fragments from several layers merge, which is what lets a layer above this one
# add to the list without either of them having to know about the other.
RDEPENDS:mender-update:append:tegra = " tegra-uefi-capsules libubootenv-fake mender-update-verifier tegra-redundant-boot"

FILES:mender-update:append:mender-persist-systemd-machine-id = " \
    ${bindir}/efi_systemd_machine_id.sh \
"