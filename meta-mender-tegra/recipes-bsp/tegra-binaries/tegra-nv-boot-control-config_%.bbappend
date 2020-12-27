do_install_append() {
    # Override the symlink to always target a volatile location for nv_boot_control.conf
    ln -sf /run/nvbootctrl/nv_boot_control.conf ${D}${sysconfdir}/
}
