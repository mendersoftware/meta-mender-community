SRC_URI = " \
    file://switch-rootfs \
"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

S = "${WORKDIR}"

inherit mender-state-scripts

PERSIST_MACHINE_ID=""
PERSIST_MACHINE_ID:mender-persist-systemd-machine-id = "yes"

do_compile() {
    cp ${S}/switch-rootfs ${MENDER_STATE_SCRIPTS_DIR}/ArtifactInstall_Leave_50_switch-rootfs
}

# Make sure scripts aren't left around from old builds
do_deploy:prepend() {
    rm -rf ${DEPLOYDIR}/mender-state-scripts
}

PACKAGE_ARCH = "${MACHINE_ARCH}"
