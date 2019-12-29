SRC_URI = " \
    file://migrate-current-uboot-vars \
    file://redundant-boot-commit-script \
    file://redundant-boot-install-script \
    file://redundant-boot-rollback-script \
    file://rollback-uboot-vars \
"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

S = "${WORKDIR}"

inherit mender-state-scripts

PERSIST_MACHINE_ID=""
PERSIST_MACHINE_ID_mender-persist-systemd-machine-id = "yes"

copy_redundant_boot_scripts() {
    sed -e's,@COPY_MACHINE_ID@,${PERSIST_MACHINE_ID},' ${S}/redundant-boot-install-script > ${MENDER_STATE_SCRIPTS_DIR}/ArtifactInstall_Leave_80_bl-update
    cp ${S}/redundant-boot-rollback-script ${MENDER_STATE_SCRIPTS_DIR}/ArtifactRollback_Leave_80_bl-rollback
    cp ${S}/redundant-boot-commit-script ${MENDER_STATE_SCRIPTS_DIR}/ArtifactCommit_Leave_90_bl-commit
}

do_compile() {
    :
}

do_compile_tegra194() {
    copy_redundant_boot_scripts
}

do_compile_tegra186() {
    copy_redundant_boot_scripts
}

do_compile_append_tegra186_mender-uboot() {
    cp ${S}/migrate-current-uboot-vars ${MENDER_STATE_SCRIPTS_DIR}/ArtifactInstall_Leave_90_uboot-migrate
    cp ${S}/rollback-uboot-vars ${MENDER_STATE_SCRIPTS_DIR}/ArtifactRollback_Leave_90_uboot-migrate
}

# Make sure scripts aren't left around from old builds
do_deploy_prepend() {
    rm -rf ${DEPLOYDIR}/mender-state-scripts
}

PACKAGE_ARCH = "${MACHINE_ARCH}"
