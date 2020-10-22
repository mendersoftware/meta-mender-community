#
# Currently u-boot-imx uses version 2019.04 which is not
# within the range of versions of U-Boot containing the data abort
# issue documented in:
#    https://tracker.mender.io/browse/MEN-2404
#
# We need to explicitly remove the conflict that was entered in
# version_logic.inc to allow it to coexist.
#

RCONFLICTS_${PN}_remove_mender-grub = "u-boot-imx (<= 1:2019.07)"
