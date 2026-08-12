# The adapters the stock rootfs-image module needs on Tegra. The common layer
# appends what both schemes need; :append fragments from both layers merge.
RDEPENDS:mender-update:append:tegra = " libubootenv-fake mender-update-verifier tegra-uefi-capsules"
