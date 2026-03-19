# Include OP-TEE (BL32) in U-Boot's FIT image for Rockchip platforms
# The TEE variable tells U-Boot's make.sh to pack OP-TEE into the FIT image loaded by SPL.
# tee.bin is built by optee-os during this Yocto build (not a pre-built binary).

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# Add OP-TEE config fragment to U-Boot (enables CONFIG_TEE, CONFIG_OPTEE, etc.)
SRC_URI:append = " file://optee.cfg"

# Declare build-time dependency on optee-os when optee machine feature is enabled
DEPENDS:append:rk3399 = " ${@bb.utils.contains('MACHINE_FEATURES', 'optee', 'optee-os', '', d)}"

# Ensure optee-os is fully deployed (tee.bin available) before U-Boot compiles
do_compile[depends] += "${@bb.utils.contains('MACHINE_FEATURES', 'optee', 'optee-os:do_deploy', '', d)}"

# Pass TEE path to U-Boot's make.sh so BL32 is packed into the FIT image.
# Uses tee.bin (combined binary) that the optee-os recipe deploys under DEPLOY_DIR_IMAGE/optee/.
EXTRA_OEMAKE:append:rk3399 = " ${@bb.utils.contains('MACHINE_FEATURES', 'optee', 'TEE=${DEPLOY_DIR_IMAGE}/optee/tee.bin', '', d)}"
