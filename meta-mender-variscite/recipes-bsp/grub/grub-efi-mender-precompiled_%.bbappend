#
# Currently u-boot-variscite uses version 2018.03 which is not
# within the range of versions of U-Boot containing the data abort
# issue documented in:
#    https://tracker.mender.io/browse/MEN-2404
#
# We need to explicitly remove the conflict that was entered in
# version_logic.inc to allow it to coexist.
#

RCONFLICTS_${PN}_remove_mender-grub = "u-boot-variscite (<= 1:2019.07)"
