# Add Rockchip RK3568 EVB support to optee-ftpm
COMPATIBLE_MACHINE:rockchip-rk3568-evb = "rockchip-rk3568-evb"
COMPATIBLE_MACHINE:rock-4c-plus = "rock-4c-plus"

# Add optee-os source for required headers
SRC_URI += "git://github.com/OP-TEE/optee_os.git;branch=master;protocol=https;name=optee-os;destsuffix=git/optee-os"
SRCREV_optee-os = "30c13f9e2ff178c9a299e409de75d50529cf5064"
SRCREV_FORMAT = "default_optee-os"

# Add missing pycryptodome dependency
DEPENDS += "python3-pycryptodome-native"

# Use custom signing key that matches the key embedded in OP-TEE OS
# For rock-4c-plus: OP-TEE OS is built from source with our custom key
# For rockchip-rk3568-evb: Uses Radxa's default OEM key for pre-built OP-TEE
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:append:rock-4c-plus = " file://keys/ta_sign_key.pem"
SRC_URI:append:rockchip-rk3568-evb = " file://keys/ta_sign_key.pem"
EXTRA_OEMAKE:append:rockchip-rk3568-evb = " TA_SIGN_KEY=${WORKDIR}/keys/ta_sign_key.pem"
EXTRA_OEMAKE:append:rock-4c-plus = " TA_SIGN_KEY=${WORKDIR}/keys/ta_sign_key.pem"