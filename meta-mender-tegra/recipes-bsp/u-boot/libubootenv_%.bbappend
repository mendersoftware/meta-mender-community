include recipes-bsp/u-boot/u-boot-mender-tegra-vars.inc

# Stash an extra copy of fw_env.config in the rootfs so we
# can handle a change in the env offset/size during an upgrade
do_install:append_tegra() {
    install -d ${D}${datadir}/u-boot
    install -m 0644 ${WORKDIR}/fw_env.config ${D}${datadir}/u-boot/
}
FILES:${PN}:append_tegra = " ${datadir}/u-boot"

# The default environment must be provided by the
# u-boot recipe
RPROVIDES:${PN}:remove_tegra = "u-boot-default-env"
