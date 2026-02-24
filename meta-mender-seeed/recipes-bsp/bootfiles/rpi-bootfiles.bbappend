SRC_URI:append:seeed-reterminal-mender = " https://datasheets.raspberrypi.org/cmio/dt-blob-disp1-cam2.bin;name=dtblob"
SRC_URI[dtblob.sha256sum] = "286b7ffd127a5aaabb2b162cb5e7cc8ac8e15f097bd26a47b899d0b2b30a4b44"

do_deploy:append:seeed-reterminal-mender() {
    install -m 0644 ${WORKDIR}/dt-blob-disp1-cam2.bin ${DEPLOYDIR}/${BOOTFILES_DIR_NAME}/dt-blob.bin
}
