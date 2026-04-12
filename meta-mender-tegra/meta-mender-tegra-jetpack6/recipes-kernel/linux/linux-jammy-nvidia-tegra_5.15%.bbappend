# Rather ugly hack to ensure that meta-mender-core's files directory
# is also removed from consideration, since linux-yocto.bbclass adds
# all directories that contain config fragments into its file-cksums
# list, which needlessly (for us) changes the task hash.
python() {
    extrapaths = d.getVar('FILESEXTRAPATHS').split(':')
    newpaths = ':'.join([path for path in extrapaths if not path.endswith('meta-mender-core/recipes-kernel/linux/files')])
    d.setVar('FILESEXTRAPATHS', newpaths)
}

FILESEXTRAPATHS:prepend := "${THISDIR}/linux-jammy-nvidia-tegra-5.15:"

# Realtek RTL8168/8111 PCIe Ethernet (used on Orin Nano devkit carrier board)
SRC_URI += "file://r8169.cfg"
