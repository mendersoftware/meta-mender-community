do_install:append() {
    ln -sf /run/nv_boot_control/nv_boot_control.conf ${D}${sysconfdir}/
}
