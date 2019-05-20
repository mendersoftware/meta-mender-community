do_deploy_append() {
    # from poplar-tools/poplar_recovery_builder.sh
    #
    # Create the loader file.  It is always in partition 1.
    #
    # The first sector of l-loader.bin is removed in the loader "loader.bin"
    # we maintain.  The boot ROM ignores the first sector, but the "l-loader.bin"
    # must be built to contain space for it.  We create "loader.bin" by dropping
    # that first sector.  That way "loader.bin" can be written directly into the
    # first partition without disturbing the MBR.  We have already verified
    # "l-loader" isn't too large for the first partition; it's OK if it's smaller.
    dd if=${DEPLOYDIR}/fastboot.bin of=${DEPLOYDIR}/loader.bin status=none bs=512 skip=1
}
