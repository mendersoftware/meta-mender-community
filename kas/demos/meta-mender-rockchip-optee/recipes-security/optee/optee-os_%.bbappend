# Add Rockchip RK3568 EVB support to optee-os
COMPATIBLE_MACHINE:rockchip-rk3568-evb = "rockchip-rk3568-evb"
COMPATIBLE_MACHINE:rock-4c-plus = "rock-4c-plus"

# Set the OPTEE platform for RK3568 - use rk3399 flavor as base for ARM64
OPTEEMACHINE:rockchip-rk3568-evb = "rockchip-rk3399"
OPTEEMACHINE:rock-4c-plus = "rockchip-rk3399"
OPTEE_ARCH:rockchip-rk3568-evb = "arm64"
OPTEE_ARCH:rock-4c-plus = "arm64"
OPTEE_CORE:rockchip-rk3568-evb = "arm64"
OPTEE_CORE:rock-4c-plus = "arm64"

# Suppress RWX segment warnings in optee-os 3.13.0 (older version doesn't support proper W^X)
EXTRA_OEMAKE:append = " LDFLAGS=--no-warn-rwx-segments"

# Add missing pycryptodome dependency
DEPENDS += "python3-pycryptodome-native"

# rock-4c-plus builds optee-os from source; we provide a custom signing key
# that both OP-TEE OS and all TAs will use. This ensures signature verification works.
#
# rockchip-rk3568-evb uses a pre-built OP-TEE that embeds the Radxa OEM public key.
# That key is supplied to TA builds via SRC_URI in the individual TA bbappends.
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# Provide custom TA signing key for rock-4c-plus
SRC_URI:append:rock-4c-plus = " file://keys/ta_sign_key.pem"

# Tell optee-os to use our custom key instead of generating one
EXTRA_OEMAKE:append:rock-4c-plus = " TA_SIGN_KEY=${WORKDIR}/keys/ta_sign_key.pem"

EXTRA_OEMAKE:append = " CFG_TA_GPROF_SUPPORT=y"
EXTRA_OEMAKE:append = " ta-targets=ta_arm64"
