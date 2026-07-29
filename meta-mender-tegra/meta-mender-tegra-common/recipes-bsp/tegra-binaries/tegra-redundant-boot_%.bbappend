FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = "\
    file://nv_update_verifier.sh \
"

do_install:append() {
    install -d ${D}/${sbindir}
    install -m 0755 ${S}/nv_update_verifier.sh ${D}/${sbindir}/nv_update_verifier
}

# nv_update_verifier reads "fw_printenv upgrade_available" to decide whether an
# update is in flight. The Tegra-native update scheme does not install
# libubootenv-fake, so fw_printenv does not exist, the value comes back empty,
# and empty never equals "0". The script then takes its "upgrade in progress"
# branch on every boot and runs "systemctl reboot -f" the second time it boots
# the same slot, which is an infinite reboot loop.
#
# Leave the unit installed but do not enable it. Its two jobs are covered:
# marking the running slot good is done by the update module in ArtifactCommit,
# and forcing reboots to drain the UEFI retry counter is something UEFI already
# does on its own for an unverified slot.
SYSTEMD_AUTO_ENABLE:${PN} = "${@'disable' if bb.utils.to_boolean(d.getVar('TEGRA_MENDER_NATIVE_UPDATE')) else 'enable'}"
