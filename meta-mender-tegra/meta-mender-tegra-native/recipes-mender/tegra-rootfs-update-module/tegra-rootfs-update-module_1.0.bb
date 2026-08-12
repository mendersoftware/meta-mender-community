SUMMARY = "Tegra-native Mender update module for A/B rootfs updates"
DESCRIPTION = "Mender update module for Tegra A/B rootfs updates, using the BSP's \
own tooling (nvbootctrl, partlabels, UEFI capsule) instead of the u-boot \
environment shims the stock rootfs-image module needs."
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRC_URI = "\
    file://tegra-rootfs-image \
    file://tegra-rootfs-verify \
    file://tegra-rootfs-verify.service \
"

S = "${UNPACKDIR}"

COMPATIBLE_MACHINE = "(tegra)"

# nvbootctrl comes from tegra-redundant-boot-base; uefi_common.func,
# oe4t-set-uefi-OSIndications and the ESP mount come from setup-nv-boot-control;
# mender-flash does the sparse-aware write to the passive slot;
# tegra-mender-helpers carries the disk and ESP detection the module sources at
# runtime, shared with the classic scheme.
RDEPENDS:${PN} = "mender-flash tegra-redundant-boot-base setup-nv-boot-control tegra-mender-helpers"

inherit systemd
SYSTEMD_SERVICE:${PN} = "tegra-rootfs-verify.service"

do_install() {
    install -d ${D}${datadir}/mender/modules/v3
    install -m 0755 ${S}/tegra-rootfs-image ${D}${datadir}/mender/modules/v3/tegra-rootfs-image

    # Replaces the disabled nv_update_verifier: keeps the running slot marked
    # good on an ordinary boot, and stays out of the way while the update module
    # has an update awaiting its verdict.
    install -d ${D}${sbindir}
    install -m 0755 ${S}/tegra-rootfs-verify ${D}${sbindir}/tegra-rootfs-verify
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${S}/tegra-rootfs-verify.service ${D}${systemd_system_unitdir}/
}

# Only the module needs listing. The default FILES:${PN} already covers
# ${sbindir}/*, and systemd.bbclass appends the unit and its preset, but the
# default reaches only ${datadir}/${BPN}, not ${datadir} as a whole.
FILES:${PN} += "${datadir}/mender/modules/v3/tegra-rootfs-image"

# Shell scripts, so the content is architecture independent, but allarch and
# COMPATIBLE_MACHINE do not mix. Machine-specific packages it is.
PACKAGE_ARCH = "${MACHINE_ARCH}"
