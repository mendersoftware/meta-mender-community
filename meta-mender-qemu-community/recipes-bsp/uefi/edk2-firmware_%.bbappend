export GCC5_ARM_PREFIX = "${TARGET_PREFIX}"

export CLANG38_ARM_PREFIX = "${TARGET_PREFIX}"

#FIXME - arm32 doesn't work with clang due to a linker issue
TOOLCHAIN:arm = "gcc"

COMPATIBLE_MACHINE:qemuarm64 = "qemuarm64"
EDK2_PLATFORM:qemuarm64      = "ArmVirtQemu-AARCH64"
EDK2_PLATFORM_DSC:qemuarm64  = "ArmVirtPkg/ArmVirtQemu.dsc"
EDK2_BIN_NAME:qemuarm64      = "QEMU_EFI.fd"

COMPATIBLE_MACHINE:qemuarm = "qemuarm"
EDK2_PLATFORM:qemuarm      = "ArmVirtQemu-ARM"
EDK2_PLATFORM_DSC:qemuarm  = "ArmVirtPkg/ArmVirtQemu.dsc"
EDK2_BIN_NAME:qemuarm      = "QEMU_EFI.fd"

do_install:append:qemuarm64() {
    install ${B}/Build/${EDK2_PLATFORM}/${EDK2_BUILD_MODE}_${EDK_COMPILER}/FV/${EDK2_BIN_NAME} ${D}/firmware/
}

do_install:append:qemuarm() {
    install ${B}/Build/${EDK2_PLATFORM}/${EDK2_BUILD_MODE}_${EDK_COMPILER}/FV/${EDK2_BIN_NAME} ${D}/firmware/
}