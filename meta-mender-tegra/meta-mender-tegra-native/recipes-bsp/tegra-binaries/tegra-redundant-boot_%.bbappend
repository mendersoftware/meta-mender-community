# meta-tegra's nv_update_verifier.service runs "nvbootctrl verify" on every boot.
# Under this scheme that is exactly the wrong thing: verifying the running slot is
# what the update module does in ArtifactCommit, once Mender has decided the
# deployment succeeded. A unit that does it unconditionally at boot marks the new
# slot good before the client has committed, and with RootfsRetryCountMax at 1
# there is then nothing left to roll back to.
#
# The unit stays installed and is only left disabled, for two reasons. Masking it
# breaks the rootfs build in tegra-redundant-boot's own postinstall, and the
# package is not ours to leave out anyway: it arrives through
# MACHINE_EXTRA_RDEPENDS in meta-tegra's tegra-common.inc, so dropping this
# bbappend would enable the unit, not remove it.
#
# tegra-rootfs-verify, from tegra-rootfs-update-module, takes over the job: it
# marks the running slot good on an ordinary boot and stands down while the module
# has an update awaiting its verdict.
SYSTEMD_AUTO_ENABLE:${PN} = "disable"
