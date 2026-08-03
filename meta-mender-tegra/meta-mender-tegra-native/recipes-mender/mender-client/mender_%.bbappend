# Applying the UEFI capsule is what switches the boot slot, so the capsule
# package belongs in the image. The common layer appends what both schemes need;
# :append fragments from both layers merge.
#
# Note that the module does not read the on-device copy under
# /opt/nvidia/UpdateCapsule: it takes the capsule from the artifact payload. What
# it needs at runtime, mender-flash and the nvbootctrl and OsIndications helpers,
# the module recipe depends on itself.
RDEPENDS:mender-update:append:tegra = " tegra-uefi-capsules"
