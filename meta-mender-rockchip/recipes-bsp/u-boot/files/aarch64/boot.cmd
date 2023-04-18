run mender_setup;
setenv bootargs console=${console} console=ttyS2,1500000N8 console=tty1 root=${mender_kernel_root} rootwait panic=10 ${extra}
mmc dev ${mender_uboot_dev};
load ${mender_uboot_root} ${kernel_addr_r} /boot/fitImage;
bootm ${kernel_addr_r};
run mender_try_to_recover;
