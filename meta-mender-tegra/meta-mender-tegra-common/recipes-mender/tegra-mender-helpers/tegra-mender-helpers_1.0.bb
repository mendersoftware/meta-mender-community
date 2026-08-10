SUMMARY = "Shared disk and ESP detection for the Mender Tegra integration"
DESCRIPTION = "A POSIX shell library resolving the booted disk, the partition \
carrying a given label on it, and its ESP. Shared by both update schemes, since a \
board with two Tegra layouts makes the partition labels ambiguous."
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRC_URI = "file://disk-helpers.sh"

S = "${UNPACKDIR}"

COMPATIBLE_MACHINE = "(tegra)"

# Staged as well as packaged: the update module sources it from the rootfs, the
# classic state scripts splice the staged copy in at build time.
do_install() {
    install -d ${D}${datadir}/tegra-mender
    install -m 0644 ${S}/disk-helpers.sh ${D}${datadir}/tegra-mender/disk-helpers.sh
}

FILES:${PN} = "${datadir}/tegra-mender/disk-helpers.sh"

# Shell, so architecture independent, but allarch and COMPATIBLE_MACHINE do not mix.
PACKAGE_ARCH = "${MACHINE_ARCH}"
