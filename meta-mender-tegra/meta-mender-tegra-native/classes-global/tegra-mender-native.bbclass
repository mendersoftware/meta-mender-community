# The Tegra-native update scheme.
#
# A tegra-rootfs-image update module that drives nvbootctrl, the BSP partlabels
# and the UEFI capsule directly, in place of Mender's stock rootfs-image module
# and the adapters meta-mender-tegra-classic has to supply for it. The artifact
# it emits carries the tegra-rootfs-image payload type and the capsule alongside
# the rootfs, and keeps the canonical .mender name, since only the payload type
# inside it differs.
#
# This is the entry point for a native build. Inherit it instead of
# tegra-mender-common, which it pulls in itself:
#
#   INHERIT += "tegra-mender-native"

inherit tegra-mender-common

TEGRA_MENDER_SCHEME = "native"

IMAGE_CLASSES += "image_types_mender_tegra_native"

# This class is inherited build-wide, so the appends below reach every image
# recipe in the build, not just the OS image. meta-tegra's helper images must be
# excluded from both, or:
#
#   - the initramfs images deadlock, because the native artifact depends on the
#     UEFI capsule and meta-tegra builds the capsule from the initramfs:
#       tegra-uefi-capsules:do_compile -> tegra-minimal-initramfs:do_image_complete
#         -> do_image_tegra_mender_native -> tegra-uefi-capsules:do_deploy
#   - the initramfs also gains the update module and its runtime dependencies
#     (mender-flash, tegra-redundant-boot-base, setup-nv-boot-control), which it
#     has no use for, and which then grow the capsule built from it, and so the
#     payload of every artifact.
#   - tegra-espimage otherwise emits a meaningless update artifact holding the
#     ESP contents.
#
# The skip list is matched as a substring of the image name. That is blunt: an
# image whose name merely contains "initramfs" is skipped too. It is preferred to
# naming meta-tegra's helper images exactly, which breaks silently whenever one
# is renamed. The failure modes are asymmetric, which is what settles it: a false
# skip means a missing artifact, which is noticed immediately, while a false
# include means a dependency loop or a bloated capsule, which is not.
TEGRA_MENDER_NATIVE_SKIP_IMAGES ?= "initramfs espimage"

def tegra_mender_native_enabled(d):
    name = d.getVar('IMAGE_BASENAME') or d.getVar('PN') or ''
    for skip in (d.getVar('TEGRA_MENDER_NATIVE_SKIP_IMAGES') or '').split():
        if skip in name:
            return False
    return True

# The stock rootfs-image module is left in the image on purpose rather than
# surgically deleted. Under this scheme libubootenv-fake is not installed, so it
# fails immediately on the missing fw_printenv instead of running through a
# no-op fw_setenv and silently doing nothing. That is the loud failure we want
# if someone deploys an ordinary rootfs-image artifact here.
IMAGE_INSTALL:append:tegra = "${@' tegra-rootfs-update-module' if tegra_mender_native_enabled(d) else ''}"

# Swap the stock "mender" artifact for the module-image one. This has to be an
# :append:tegra plus a :remove:tegra, not a plain +=, because the tegra kas
# configurations set IMAGE_FSTYPES:tegra outright and that replaces anything
# appended to the unoverridden variable.
#
# The removal is not just tidiness. Both types write the artifact under the
# canonical .mender name, so leaving both in IMAGE_FSTYPES has the two do_image
# tasks writing the same path in IMGDEPLOYDIR, and whichever finishes last wins.
# A legacy artifact under the expected name is exactly the kind of thing that is
# only noticed on the device, so the check below refuses to build instead.
IMAGE_FSTYPES:append:tegra = "${@' tegra-mender-native' if tegra_mender_native_enabled(d) else ''}"
IMAGE_FSTYPES:remove:tegra = "mender"

# The :remove above makes this unreachable in an untouched configuration, since
# :remove wins over any assignment or append whatever the parse order. It is here
# for the configuration that overrides IMAGE_FSTYPES:remove:tegra itself, which
# puts "mender" back and is otherwise silent.
python () {
    fstypes = (d.getVar('IMAGE_FSTYPES') or '').split()
    if 'tegra-mender-native' in fstypes and 'mender' in fstypes:
        bb.fatal('IMAGE_FSTYPES contains both "mender" and "tegra-mender-native". '
                 'Both write the artifact under the same .mender name, so the two '
                 'do_image tasks would write one path and whichever finished last '
                 'would win. Take "mender" back out, or inherit '
                 'tegra-mender-classic instead.')
}
