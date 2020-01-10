SRC_URI = " \
    file://redundant-boot-commit-script \
    file://redundant-boot-commit-check-script-uboot \
    file://redundant-boot-install-script \
    file://redundant-boot-install-script-uboot \
    file://redundant-boot-rollback-script \
    file://redundant-boot-rollback-script-uboot \
    file://redundant-boot-rollback-reboot-script \
"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

S = "${WORKDIR}"

inherit mender-state-scripts

PERSIST_MACHINE_ID=""
PERSIST_MACHINE_ID_mender-persist-systemd-machine-id = "yes"

# We have a different install script for U-Boot vs. cboot, since
# the mechanism for determining boot partitions is different between
# the two, and with cboot there is no U-Boot environment for copying
# the machine-id.
copy_install_script() {
    sed -e's,@COPY_MACHINE_ID@,${PERSIST_MACHINE_ID},' ${S}/redundant-boot-install-script > ${MENDER_STATE_SCRIPTS_DIR}/ArtifactInstall_Leave_80_bl-update
    cp ${S}/redundant-boot-rollback-script ${MENDER_STATE_SCRIPTS_DIR}/ArtifactRollback_Leave_80_bl-rollback
}

copy_install_script_mender-uboot() {
    cp ${S}/redundant-boot-install-script-uboot ${MENDER_STATE_SCRIPTS_DIR}/ArtifactInstall_Leave_80_bl-update
    cp ${S}/redundant-boot-rollback-script-uboot ${MENDER_STATE_SCRIPTS_DIR}/ArtifactRollback_Leave_80_bl-rollback
    cp ${S}/redundant-boot-commit-check-script-uboot ${MENDER_STATE_SCRIPTS_DIR}/ArtifactCommit_Enter_80_bl-check-update
}

copy_other_scripts() {
    cp ${S}/redundant-boot-commit-script ${MENDER_STATE_SCRIPTS_DIR}/ArtifactCommit_Leave_90_bl-commit
    cp ${S}/redundant-boot-rollback-reboot-script ${MENDER_STATE_SCRIPTS_DIR}/ArtifactRollbackReboot_Leave_90_bl-rolledback
}

# These scripts are only needed for tegra platforms with the
# A/B-redundant bootloader, which currently are just TX2
# (tegra186) and Xavier (tegra194).
do_compile() {
    :
}

do_compile_tegra194() {
    copy_install_script
    copy_other_scripts
}

do_compile_tegra186() {
    copy_install_script
    copy_other_scripts
}

# Make sure scripts aren't left around from old builds
do_deploy_prepend() {
    rm -rf ${DEPLOYDIR}/mender-state-scripts
}

PACKAGE_ARCH = "${MACHINE_ARCH}"
