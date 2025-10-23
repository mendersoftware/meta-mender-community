# Custom class to demonstrate explicit WIC partitioning while keeping Mender A/B functionality
# This replaces Mender's dynamic image generation with explicit WKS files and adds
# .mender Artifact generation for OTA updates

# Inherit essential Mender functionality but NOT image generation classes
inherit mender-setup mender-systemd mender-uboot

# Enable only essential Mender features (no dynamic image generation)
MENDER_FEATURES_ENABLE:append = " \
    mender-uboot \
    mender-auth-install \
    mender-update-install \
    mender-systemd \
    mender-growfs-data \
"

# Explicitly disable dynamic partitioning features
MENDER_FEATURES_DISABLE:append = " mender-image mender-part-images"

# Use explicit WKS file instead of dynamic generation
WKS_FILE = "mender-explicit-${MACHINE}.wks"
WKS_SEARCH_PATH:prepend = "${LAYERDIR_meta-mender-explicit-wic}/wic:"

# Image types: WIC for disk images, mender for OTA artifacts
IMAGE_FSTYPES:append = " wic wic.bz2 mender"
IMAGE_FSTYPES:remove = " bootimg dataimg sdimg"

# Configure artifact generation
ARTIFACTIMG_FSTYPE ?= "ext4"

# Ensure U-Boot environment is created
do_image_wic[depends] += "${@bb.utils.contains('MENDER_FEATURES_ENABLE', 'mender-uboot', 'u-boot:do_deploy', '', d)}"

# Minimal implementation of Mender Artifact generation
# This creates .mender files without requiring mender-image feature
IMAGE_CMD:mender() {
    # Validate required variables
    if [ -z "${MENDER_ARTIFACT_NAME}" ]; then
        bbfatal "MENDER_ARTIFACT_NAME not set. Please define it in your configuration."
    fi
    
    if [ -z "${MENDER_DEVICE_TYPES_COMPATIBLE}" ]; then
        bbfatal "MENDER_DEVICE_TYPES_COMPATIBLE not set. Please define it in your configuration."
    fi
    
    # Input rootfs image
    ROOTFS_IMG="${IMGDEPLOYDIR}/${IMAGE_NAME}${IMAGE_NAME_SUFFIX}.${ARTIFACTIMG_FSTYPE}"
    
    if [ ! -f "${ROOTFS_IMG}" ]; then
        bbfatal "Rootfs image ${ROOTFS_IMG} not found. Ensure ${ARTIFACTIMG_FSTYPE} is in IMAGE_FSTYPES."
    fi
    
    # Output artifact
    MENDER_ARTIFACT="${IMGDEPLOYDIR}/${IMAGE_NAME}${IMAGE_NAME_SUFFIX}.mender"
    
    # Build device type arguments
    DEVICE_TYPE_ARGS=""
    for DEVICE_TYPE in ${MENDER_DEVICE_TYPES_COMPATIBLE}; do
        DEVICE_TYPE_ARGS="${DEVICE_TYPE_ARGS} -t ${DEVICE_TYPE}"
    done
    
    # Create the .mender Artifact
    bbnote "Creating Mender Artifact: ${MENDER_ARTIFACT_NAME}"
    mender-artifact write rootfs-image \
        --artifact-name ${MENDER_ARTIFACT_NAME} \
        ${DEVICE_TYPE_ARGS} \
        --file ${ROOTFS_IMG} \
        --output-path ${MENDER_ARTIFACT} \
        ${MENDER_ARTIFACT_EXTRA_ARGS}
    
    # Create symlink
    if [ -n "${IMAGE_LINK_NAME}" ]; then
        ln -sf ${IMAGE_NAME}${IMAGE_NAME_SUFFIX}.mender \
            ${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.mender
    fi
}

# Ensure Mender Artifact generation has proper dependencies
do_image_mender[depends] += " \
    mender-artifact-native:do_populate_sysroot \
    ${PN}:do_image_${ARTIFACTIMG_FSTYPE} \
"