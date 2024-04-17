EXTRADEPS = ""
EXTRADEPS:tegra = "tegra-bup-payload tegra-boot-tools tegra-boot-tools-nvbootctrl tegra-boot-tools-lateboot${@' libubootenv-fake' if d.getVar('PREFERRED_PROVIDER_virtual/bootloader').startswith('cboot') else ''}"
EXTRADEPS:tegra210 = "tegra-bup-payload tegra-boot-tools"
RDEPENDS:mender-update += "${EXTRADEPS}"
