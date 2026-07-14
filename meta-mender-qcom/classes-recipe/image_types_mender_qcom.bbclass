# Image type that wraps the generated rootfs filesystem image in a Mender
# artifact for the qbootctl-rootfs Update Module, so the build directly emits
# a deployable artifact alongside the flashable image set.
#
# Usage (build configuration):
#   IMAGE_CLASSES += "image_types_mender_qcom"
#   IMAGE_FSTYPES += "mender-qbootctl"
#
# The type name is deliberately NOT "mender": meta-mender-core registers its
# own "mender" image type (rootfs-image artifacts for the dual-rootfs layout)
# unconditionally via mender-setup, and that writer does not apply to the
# qbootctl A/B integration. The produced file is a regular Mender artifact;
# only the filename extension differs.

inherit image_types

IMAGE_TYPES += "mender-qbootctl"

# Filesystem image type used as the artifact payload.
MENDER_QBOOTCTL_ARTIFACT_FSTYPE ??= "ext4"

# Extra arguments that should be passed to mender-artifact.
MENDER_ARTIFACT_EXTRA_ARGS ?= ""

# The key used to sign the artifact, if any.
MENDER_ARTIFACT_SIGNING_KEY ?= ""

do_image_mender_qbootctl[depends] += "mender-artifact-native:do_populate_sysroot"

IMAGE_CMD:mender-qbootctl () {
    if [ -z "${MENDER_ARTIFACT_NAME}" ]; then
        bbfatal "Need to define MENDER_ARTIFACT_NAME variable."
    fi
    if [ -z "${MENDER_DEVICE_TYPES_COMPATIBLE}" ]; then
        bbfatal "MENDER_DEVICE_TYPES_COMPATIBLE variable cannot be empty."
    fi

    extra_args=

    for dev in ${MENDER_DEVICE_TYPES_COMPATIBLE}; do
        extra_args="$extra_args -t $dev"
    done

    if [ -n "${MENDER_ARTIFACT_SIGNING_KEY}" ]; then
        extra_args="$extra_args -k ${MENDER_ARTIFACT_SIGNING_KEY}"
    fi

    mender-artifact write module-image \
        -T qbootctl-rootfs \
        -n ${MENDER_ARTIFACT_NAME} \
        $extra_args \
        -f ${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.${MENDER_QBOOTCTL_ARTIFACT_FSTYPE} \
        ${MENDER_ARTIFACT_EXTRA_ARGS} \
        -o ${IMGDEPLOYDIR}/${IMAGE_NAME}${IMAGE_NAME_SUFFIX}.mender-qbootctl
}

# The payload filesystem image must be generated first.
IMAGE_TYPEDEP:mender-qbootctl = "${MENDER_QBOOTCTL_ARTIFACT_FSTYPE}"
