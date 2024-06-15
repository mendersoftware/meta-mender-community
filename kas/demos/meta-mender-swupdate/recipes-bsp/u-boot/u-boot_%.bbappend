FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# The patches are only used on qemu - For the raspberrypi3 we provide a custom boot script in rpi-uboot-scr
SRC_URI:append:qemuall = " \
    file://0001-env-in-fat-defconfig-2022.01.patch \
    file://0002-swupdate_boot-boot-commands.patch \
    file://fw_env.config \
"