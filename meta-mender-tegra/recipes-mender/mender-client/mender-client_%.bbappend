EXTRADEPS = ""
EXTRADEPS_tegra = "tegra-bup-payload tegra-boot-tools tegra-boot-tools-nvbootctrl tegra-boot-tools-lateboot${@' libubootenv-fake' if d.getVar('PREFERRED_PROVIDER_virtual/bootloader').startswith('cboot') else ''}"
EXTRADEPS_tegra210 = "tegra-bup-payload tegra-boot-tools"
RDEPENDS_${PN} += "${EXTRADEPS}"

# zstd prevent the build on tegra platforms with the oe4t toolchain for any version > 3.4
EXTRA_OEMAKE:append = " TAGS='nozstd'"
PTEST_ENABLED = "0"
