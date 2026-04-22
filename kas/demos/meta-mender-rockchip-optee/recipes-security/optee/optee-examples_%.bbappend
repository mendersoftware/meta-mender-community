# Add Rockchip RK3568 EVB support to optee-examples
COMPATIBLE_MACHINE:rockchip-rk3568-evb = "rockchip-rk3568-evb"
COMPATIBLE_MACHINE:rock-4c-plus = "rock-4c-plus"
# Add missing pycryptodome dependency
DEPENDS += "python3-pycryptodome-native"

# OP-TEE is built from source; TAs are signed via the tadevkit key.
# rock-4c-plus: do NOT override TA_SIGN_KEY - the ta-dev-kit supplies the
# correct key that matches the key embedded in the from-source OP-TEE binary.
# (Radxa OEM key override was only valid with the old pre-built bl32 binary.)
#
# rockchip-rk3568-evb still uses a pre-built OP-TEE → keep its OEM key.
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:append:rockchip-rk3568-evb = " file://keys/ta_sign_key.pem"
EXTRA_OEMAKE:append:rockchip-rk3568-evb = " TA_SIGN_KEY=${WORKDIR}/keys/ta_sign_key.pem"

# Exclude plugins from build by overriding EXAMPLE_LIST
EXTRA_OEMAKE += 'EXAMPLE_LIST="acipher aes hello_world hotp random secure_storage"'

# Pass LDFLAGS to ensure binaries have GNU_HASH
EXTRA_OEMAKE += 'LDFLAGS="${LDFLAGS}"'

# Skip ldflags QA check as optee-examples Makefiles don't properly respect LDFLAGS
INSANE_SKIP:${PN} += "ldflags"

do_install() {
    mkdir -p ${D}${nonarch_base_libdir}/optee_armtz
    mkdir -p ${D}${bindir}
    install -D -p -m0755 ${B}/ca/* ${D}${bindir}
    install -D -p -m0444 ${B}/ta/* ${D}${nonarch_base_libdir}/optee_armtz
}
