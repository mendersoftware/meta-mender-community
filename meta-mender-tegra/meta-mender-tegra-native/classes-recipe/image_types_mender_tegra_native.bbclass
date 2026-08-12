# Builds a Mender artifact for the tegra-rootfs-image update module.
#
# Unlike the stock "mender" image type this emits a module-image artifact with a
# payload type of tegra-rootfs-image, carrying two files: the rootfs and the
# UEFI capsule. Carrying the capsule in the artifact is what lets the module
# stage it without mounting the freshly written slot, which is what the
# switch-rootfs state script has to do today.
#
# The file itself keeps the canonical .mender extension. Only the payload type
# inside it differs, this is still an ordinary Mender artifact, and naming it
# anything else would break every script and upload step that expects one.
#
# Modelled on meta-mender's mender-artifact-uefi-capsule.bbclass, which does the
# same shape of thing for -T uefi-capsule, and likewise writes a .mender file
# from an image type not called "mender".

inherit image_types_mender_tegra

TEGRA_NATIVE_ARTIFACT_TYPE ?= "tegra-rootfs-image"

# The capsule that tegra-uefi-capsules built for this machine.
TEGRA_NATIVE_CAPSULE ?= "${DEPLOY_DIR_IMAGE}/tegra-bl.cap"

do_image_tegra_mender_native[depends] += " \
    mender-artifact-native:do_populate_sysroot \
    tegra-uefi-capsules:do_deploy \
"

IMAGE_TYPEDEP:tegra-mender-native = "${ARTIFACTIMG_FSTYPE}"

# Same name the stock "mender" type gives its artifact, which is the point.
TEGRA_NATIVE_ARTIFACT ?= "${IMAGE_NAME}${IMAGE_NAME_SUFFIX}.mender"

IMAGE_CMD:tegra-mender-native () {
    if [ ! -e "${TEGRA_NATIVE_CAPSULE}" ]; then
        bbfatal "TEGRA_NATIVE_CAPSULE (${TEGRA_NATIVE_CAPSULE}) does not exist. The" \
                "tegra-rootfs-image module needs the capsule in the artifact, since" \
                "applying it is what switches the boot slot."
    fi

    extra_args=""
    for dev in ${MENDER_DEVICE_TYPES_COMPATIBLE}; do
        extra_args="$extra_args -c $dev"
    done
    if [ -n "${MENDER_ARTIFACT_SIGNING_KEY}" ]; then
        extra_args="$extra_args -k ${MENDER_ARTIFACT_SIGNING_KEY}"
    fi

    # Provide rootfs-image.version, the same key the stock rootfs-image module
    # provides, so inventory and the server's already-installed check are
    # unchanged by switching schemes. --software-filesystem alone will not do:
    # it composes <filesystem>.<type>.version, which would yield
    # rootfs-image.tegra-rootfs-image.version. Set it explicitly instead.
    mender-artifact write module-image \
        -n ${MENDER_ARTIFACT_NAME} \
        -T ${TEGRA_NATIVE_ARTIFACT_TYPE} \
        $extra_args \
        -f ${IMGDEPLOYDIR}/${IMAGE_NAME}${IMAGE_NAME_SUFFIX}.${ARTIFACTIMG_FSTYPE} \
        -f ${TEGRA_NATIVE_CAPSULE} \
        --no-default-software-version \
        --no-default-clears-provides \
        --provides rootfs-image.version:${MENDER_ARTIFACT_NAME} \
        --clears-provides "rootfs-image.*" \
        -o ${IMGDEPLOYDIR}/${TEGRA_NATIVE_ARTIFACT}

    # create_symlinks in image.bbclass makes the stable, timestamp-free symlink
    # for each type in IMAGE_FSTYPES, but it looks for <IMAGE_NAME>.<type> and
    # this type is not called "mender". It logs "Skipping symlink, source does
    # not exist" and moves on, so make the same relative symlink here. Without it
    # the artifact is only reachable under its timestamped name, which the stock
    # scheme does not ask of anyone.
    if [ -n "${IMAGE_LINK_NAME}" ]; then
        ln -sf ${TEGRA_NATIVE_ARTIFACT} ${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.mender
    fi
}
