include conf/machine/include/st-machine-common-stm32mp.inc
include conf/machine/include/st-machine-providers-stm32mp.inc

#
# This machine configuration is largely based on ST's machine config for the
# EK and DK boards.
# It focuses mainly on the mender integration and most peripherals/features not
# strictly necessary are disabled to a) keep things simple and b) reduce any
# potential sources of enthropy.
# It is possible to enable these features, possibly acompanied by changes to the
# devicetree to enable/configure the related peripherals.

# Define specific familly common machine name
MACHINEOVERRIDES .= ":stm32mp1common:stm32mp15common"

# =========================================================================
# Chip architecture
# =========================================================================
DEFAULTTUNE = "cortexa7thf-neon-vfpv4"
include conf/machine/include/arm/armv7a/tune-cortexa7.inc

# =========================================================================
# boot scheme
# =========================================================================
# Only trusted is supported for now. Optee should work too only requiring the
# matching devicetree for the board.
BOOTSCHEME_LABELS += "trusted"
#BOOTSCHEME_LABELS += "optee"

OSD32MP1_DEVICETREE = "stm32mp157c-osd32mp1-red"

STM32MP_DEVICETREE:append = " ${OSD32MP1_DEVICETREE}"

# =========================================================================
# Machine features
# =========================================================================
#MACHINE_FEATURES += "splashscreen"
MACHINE_FEATURES += "watchdog"
MACHINE_FEATURES += "bluetooth"
MACHINE_FEATURES += "wifi"
#MACHINE_FEATURES += "gpu"
#MACHINE_FEATURES += "m4copro"

# Bluetooth
BLUETOOTH_LIST += "linux-firmware-bluetooth-bcm4343"
# Wifi
WIFI_LIST += "linux-firmware-bcm43430"

# =========================================================================
# Kernel
# =========================================================================
KERNEL_MODULE_AUTOLOAD = " \
    brcmfmac \
"

UBOOT_EXTLINUX_FDT = "/${OSD32MP1_DEVICETREE}.dtb"
