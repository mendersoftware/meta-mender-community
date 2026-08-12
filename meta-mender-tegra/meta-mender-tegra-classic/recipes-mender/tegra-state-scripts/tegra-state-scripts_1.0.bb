SRC_URI = " \
    file://switch-rootfs \
    file://verify-slot \
    file://abort-blupdate \
"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

S = "${UNPACKDIR}"

inherit mender-state-scripts

PERSIST_MACHINE_ID = ""
PERSIST_MACHINE_ID:mender-persist-systemd-machine-id = "yes"

# For the staged helpers only; these scripts travel inside the artifact.
DEPENDS = "tegra-mender-helpers"
TEGRA_DISK_HELPERS = "${STAGING_DATADIR}/tegra-mender/disk-helpers.sh"

# A state script runs from the artifact on whatever rootfs is booted, so it cannot
# source the library: a device flashed before it existed would fail its next
# update. Splice it in at the marker instead.
tegra_splice_helpers() {
    sed -e '/^#TEGRA_DISK_HELPERS$/r '"${TEGRA_DISK_HELPERS}" \
        -e '/^#TEGRA_DISK_HELPERS$/d' \
        "$1" > "$2"
    grep -q '^tegra_booted_disk()' "$2" || bbfatal "helpers were not spliced into $2"
}

do_compile() {
    tegra_splice_helpers ${S}/switch-rootfs ${MENDER_STATE_SCRIPTS_DIR}/ArtifactInstall_Leave_50_switch-rootfs
    cp ${S}/verify-slot ${MENDER_STATE_SCRIPTS_DIR}/ArtifactCommit_Leave_50_verify-slot
    tegra_splice_helpers ${S}/abort-blupdate ${MENDER_STATE_SCRIPTS_DIR}/ArtifactRollback_Leave_50_abort-blupdate
}

# Make sure scripts aren't left around from old builds
do_deploy:prepend() {
    rm -rf ${DEPLOYDIR}/mender-state-scripts
}

PACKAGE_ARCH = "${MACHINE_ARCH}"
