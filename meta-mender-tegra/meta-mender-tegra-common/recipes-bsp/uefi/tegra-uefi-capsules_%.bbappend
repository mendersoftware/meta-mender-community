inherit l4t_version

do_install:append() {
    if [ -n "${TEGRA_UEFI_CAPSULE_INSTALL_DIR}" ]; then
        if [ -e ${B}/tegra-bl.cap ]; then
            echo "${L4T_VERSION}" > ${D}${TEGRA_UEFI_CAPSULE_INSTALL_DIR}/tegra-bl.cap.version
        fi
    fi
}
