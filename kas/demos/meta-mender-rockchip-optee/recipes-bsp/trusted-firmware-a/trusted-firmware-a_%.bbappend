# Enable OP-TEE (BL32) support for Rockchip RK3399 platforms
# TFA_SPD selects the Secure Payload Dispatcher - "opteed" for OP-TEE
#
# Note: For Rockchip, BL32 (OP-TEE) is NOT embedded in TF-A.
# Instead, U-Boot SPL loads OP-TEE via the FIT image and TF-A
# expects it to be in memory when BL31 starts.
# The BL32 variables are not needed here - only SPD=opteed.

TFA_SPD:rk3399 = "opteed"
