# Without mender-image feature, the client installs state to /var/lib/mender
# directly on the rootfs, which is lost on A/B switch. We override the
# persistent dir to /data/mender and create the symlink ourselves.

# Point persistent dir to /data/mender (same as mender-image would do)
_MENDER_PERSISTENT_DIR = "/data/mender"

# Create /data/mender before the base recipe tries to install files there
do_install:prepend() {
    install -m 755 -d ${D}/data/mender
}

# After base install, replace /var/lib/mender with symlink to persistent storage
# and remove the generic rootfs-image update module which is incompatible with
# the tryboot partition layout.
do_install:append() {
    if ! ${@bb.utils.contains('MENDER_FEATURES', 'mender-image', 'true', 'false', d)}; then
        rm -rf ${D}/${localstatedir}/lib/mender
        install -m 755 -d ${D}/${localstatedir}/lib
        ln -s /data/mender ${D}/${localstatedir}/lib/mender
    fi

    rm -f ${D}${datadir}/mender/modules/v3/rootfs-image
}

# Include /data/mender in the package (not /data itself, owned by data-partition)
FILES:mender-config += "/data/mender"
