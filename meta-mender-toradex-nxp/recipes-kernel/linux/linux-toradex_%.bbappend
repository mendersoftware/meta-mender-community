FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append_mender-grub = " file://enable-efi.cfg"

do_configure_append_mender-grub () {
    # linux-toradex does not seem to respect config file
    # fragments so we manually add our config settings.
    cat ${WORKDIR}/enable-efi.cfg >> ${B}/.config
}