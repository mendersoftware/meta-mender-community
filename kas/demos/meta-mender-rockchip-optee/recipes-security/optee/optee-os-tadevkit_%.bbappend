# Add Rockchip RK3568 EVB support to optee-os-tadevkit
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
EXTRA_OEMAKE:append:rockchip-rk3568-evb = " LDFLAGS=--no-warn-rwx-segments"
EXTRA_OEMAKE:append:rock-4c-plus = " LDFLAGS=--no-warn-rwx-segments"

# For rock-4c-plus: OP-TEE OS uses our custom key via TA_SIGN_KEY, which gets
# automatically copied into the TA dev kit during build. The do_install:append
# below ensures it's properly installed for both rock-4c-plus and rockchip-rk3568-evb.
#
# For rockchip-rk3568-evb: Use Rockchip OEM signing key for compatibility with
# Radxa's pre-built OP-TEE binary which embeds that public key.
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:append:rock-4c-plus = " file://keys/ta_sign_key.pem"
SRC_URI:append:rockchip-rk3568-evb = " file://keys/ta_sign_key.pem"

# Replace default_ta.pem in TA dev kit with our custom key
do_install:append() {
    if [ -f "${WORKDIR}/keys/ta_sign_key.pem" ]; then
        install -m 0644 ${WORKDIR}/keys/ta_sign_key.pem ${D}${includedir}/optee/export-user_ta/keys/default_ta.pem
    fi
}                                                                                                                                                   