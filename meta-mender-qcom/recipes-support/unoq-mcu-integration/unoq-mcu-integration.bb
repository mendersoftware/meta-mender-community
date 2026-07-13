SUMMARY = "Mender Update Module (zephyr-mcu): flash Zephyr firmware to the Uno Q STM32U585 over SWD"
DESCRIPTION = "Installs the 'zephyr-mcu' Mender v3 Update Module and its OpenOCD \
config. The module programs the Arduino Uno Q's on-board STM32U585 MCU firmware \
over the QRB2210's internal SWD link (OpenOCD + linuxgpiod), with SWD read-back \
verify and backup/re-flash rollback. A second Mender update type beside the \
qbootctl-rootfs A/B rootfs module."
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = " \
    file://zephyr-mcu \
    file://openocd_gpiod.cfg \
"

# openocd (built with the linuxgpiod driver, see the openocd bbappend) is the
# flasher; it pulls in libgpiod/libusb at runtime.
RDEPENDS:${PN} = "openocd"

do_install() {
    # payload/update type == the module filename ("zephyr-mcu")
    install -d ${D}${datadir}/mender/modules/v3
    install -m 0755 ${UNPACKDIR}/zephyr-mcu ${D}${datadir}/mender/modules/v3/zephyr-mcu

    install -d ${D}${datadir}/unoq-mcu
    install -m 0644 ${UNPACKDIR}/openocd_gpiod.cfg ${D}${datadir}/unoq-mcu/openocd_gpiod.cfg
}

FILES:${PN} += " \
    ${datadir}/mender/modules/v3/zephyr-mcu \
    ${datadir}/unoq-mcu/openocd_gpiod.cfg \
"
