# Override fw_env.config for x86-64 U-Boot EFI mode.
# The mender-uboot class creates /etc/fw_env.config pointing to device-offset
# based config. We override it to use file-based config for the env partition
# mounted at /uboot (FAT partition 2, separate from ESP).
#
# Redundant env: uboot.env + uboot-redund.env, both 128KB (0x20000).
do_install[postfuncs] += "fixup_fw_env_config"

fixup_fw_env_config() {
    if [ -d "${D}/data/u-boot" ]; then
        printf '/uboot/uboot.env\t0x0\t0x20000\n/uboot/uboot-redund.env\t0x0\t0x20000\n' > ${D}/data/u-boot/fw_env.config
    fi
    rm -f ${D}${sysconfdir}/fw_env.config
    install -d ${D}${sysconfdir}
    printf '/uboot/uboot.env\t0x0\t0x20000\n/uboot/uboot-redund.env\t0x0\t0x20000\n' > ${D}${sysconfdir}/fw_env.config
}
