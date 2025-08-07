SUMMARY = "Mender A/B demo image using explicit WIC partitioning"
DESCRIPTION = "Demonstrates Mender A/B functionality with explicit WKS files instead of dynamic image generation"

# Inherit from core-image-minimal and add our explicit WIC functionality
inherit core-image mender-explicit-wic

# Image configuration
IMAGE_LINGUAS = " "
LICENSE = "MIT"

# Essential packages for Mender A/B functionality
IMAGE_INSTALL = "\
    packagegroup-core-boot \
    ${CORE_IMAGE_EXTRA_INSTALL} \
    mender-auth \
    mender-update \
    mender-configure \
    mender-connect \
    kernel-image \
    kernel-devicetree \
"

# Remove incompatible packages
IMAGE_INSTALL:remove = "packagegroup-core-device-devel"

# Configure for A/B updates
IMAGE_OVERHEAD_FACTOR = "1.3"
IMAGE_ROOTFS_EXTRA_SPACE = "0"

# Create /data directory structure in rootfs
ROOTFS_POSTPROCESS_COMMAND += "create_mender_data_structure; "

create_mender_data_structure() {
    # Create basic /data directory structure that Mender expects
    install -d ${IMAGE_ROOTFS}/data
    install -d ${IMAGE_ROOTFS}/data/mender
    install -d ${IMAGE_ROOTFS}/data/mender-configure
    
    # Add a demo file to show data persistence
    echo "Mender explicit WIC demo - persistent data" > ${IMAGE_ROOTFS}/data/demo.txt
    echo "Created: $(date)" >> ${IMAGE_ROOTFS}/data/demo.txt
}