# The classic Tegra update scheme.
#
# Mender's stock rootfs-image update module is written for u-boot and GRUB
# systems, so on Tegra it works through a stack of adapters this layer provides:
# libubootenv-fake supplies the fw_printenv/fw_setenv the module calls, three
# Mender state scripts perform the slot switch the module cannot, and
# mender-update-verifier undoes state the shims cannot express.
#
# This is the entry point for a classic build. Inherit it instead of
# tegra-mender-common, which it pulls in itself:
#
#   INHERIT += "tegra-mender-classic"

inherit tegra-mender-common

TEGRA_MENDER_SCHEME = "classic"

# These have to live in the same layer as libubootenv-fake_1.0.bb, and that is
# worth being explicit about, because getting it wrong is silent. A
# PREFERRED_PROVIDER naming a recipe no layer in the build provides is neither an
# error nor a warning: bitbake looks for the name among the eligible providers,
# does not find it, and falls through to whatever else provides the target. Left
# behind in the common layer, these lines would still expand in a build that does
# not carry libubootenv-fake, and libubootenv would quietly resolve to oe-core's
# real implementation instead.
PREFERRED_PROVIDER_u-boot-fw-utils = "u-boot-fw-utils-tegra"
PREFERRED_PROVIDER_libubootenv:tegra = "libubootenv"
PREFERRED_RPROVIDER_u-boot-fw-utils = "u-boot-fw-utils-tegra"
PREFERRED_RPROVIDER_libubootenv-bin:tegra = "libubootenv-bin"
PREFERRED_PROVIDER_libubootenv:tegra234 = "libubootenv-fake"
PREFERRED_PROVIDER_libubootenv:tegra264 = "libubootenv-fake"

# The state scripts are bundled into the artifact, so they have to be deployed
# before it is built.
_MENDER_IMAGE_DEPS_EXTRA = ""
_MENDER_IMAGE_DEPS_EXTRA:tegra = "tegra-state-scripts:do_deploy"
do_image_mender[depends] += "${_MENDER_IMAGE_DEPS_EXTRA}"
