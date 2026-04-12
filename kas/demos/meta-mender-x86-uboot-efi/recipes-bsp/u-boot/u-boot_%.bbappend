# U-Boot configuration for x86-64 EFI application mode with Mender A/B support
#
# This builds U-Boot as an EFI application (u-boot-app.efi) that runs under
# OVMF firmware, providing Mender A/B boot partition selection.
#
# Boot chain: OVMF -> u-boot-app.efi (from ESP) -> Linux kernel (from rootfs)

MENDER_X86_UBOOT_EFI_DIR := "${THISDIR}"
FILESEXTRAPATHS:prepend:qemux86-64 = "${MENDER_X86_UBOOT_EFI_DIR}/${BPN}-${PV}:${MENDER_X86_UBOOT_EFI_DIR}/files:"

COMPATIBLE_MACHINE:qemux86-64 = "qemux86-64"

# Disable Mender auto-configure — the EFI app defconfig is non-standard
MENDER_UBOOT_AUTO_CONFIGURE:qemux86-64 = "0"

# The EFI app defconfig produces u-boot-app.efi
UBOOT_BINARY:qemux86-64 = "u-boot-app.efi"

# The Mender integration patch (env_mender.h + config_mender.h) is applied
# automatically by the mender-uboot class from meta-mender-core.
SRC_URI:append:qemux86-64:mender-uboot = " \
    file://0001-configs-efi-x86-enable-mender-requirements.patch \
    file://startup.nsh \
"

DEPENDS:append:qemux86-64 = " dosfstools-native mtools-native"

do_deploy:append:qemux86-64() {
    if [ -f "${B}/u-boot-app.efi" ]; then
        install -m 0644 ${B}/u-boot-app.efi ${DEPLOYDIR}/u-boot-app.efi
    fi

    # fw_env.config pointing to the env partition mounted at /uboot
    printf '/uboot/uboot.env\t0x0\t0x20000\n/uboot/uboot-redund.env\t0x0\t0x20000\n' > ${DEPLOYDIR}/fw_env.config.default

    # Generate valid initial env with mender_saveenv_canary=1 pre-set
    ENVTXT="${WORKDIR}/initial-env.txt"
    if [ -f "${DEPLOYDIR}/u-boot-initial-env" ]; then
        cp "${DEPLOYDIR}/u-boot-initial-env" "${ENVTXT}"
    elif [ -f "${DEPLOYDIR}/u-boot-initial-env-${MACHINE}" ]; then
        cp "${DEPLOYDIR}/u-boot-initial-env-${MACHINE}" "${ENVTXT}"
    else
        echo "mender_saveenv_canary=1" > "${ENVTXT}"
    fi
    if ! grep -q "mender_saveenv_canary=1" "${ENVTXT}"; then
        echo "mender_saveenv_canary=1" >> "${ENVTXT}"
    fi

    # Override mender_try_to_recover: In EFI app mode, 'reset' causes OVMF
    # to fall through to its UI instead of retrying U-Boot. Handle recovery
    # inline by running altbootcmd + bootcmd directly.
    sed -i '/^mender_try_to_recover=/d' "${ENVTXT}"
    echo 'mender_try_to_recover=if test ${upgrade_available} = 1; then run mender_altbootcmd; run bootcmd; fi' >> "${ENVTXT}"
    mkenvimage -r -s 0x20000 -o ${DEPLOYDIR}/uboot.env "${ENVTXT}"
    mkenvimage -r -s 0x20000 -o ${DEPLOYDIR}/uboot-redund.env "${ENVTXT}"

    # Create a 4MB FAT image containing the env files for the dedicated
    # env partition (partition 2). This keeps env writes OFF the ESP so
    # OVMF's view of the ESP FAT stays clean across reboots.
    ENVIMG="${DEPLOYDIR}/uboot-env-partition.img"
    dd if=/dev/zero of=${ENVIMG} bs=1M count=4 2>/dev/null
    mkfs.vfat -n uboot-env ${ENVIMG}
    mcopy -i ${ENVIMG} ${DEPLOYDIR}/uboot.env ::uboot.env
    mcopy -i ${ENVIMG} ${DEPLOYDIR}/uboot-redund.env ::uboot-redund.env

    # Deploy startup.nsh for EFI Shell fallback
    install -m 0644 ${WORKDIR}/startup.nsh ${DEPLOYDIR}/startup.nsh
}

do_deploy[depends] += "u-boot-tools-native:do_populate_sysroot"
