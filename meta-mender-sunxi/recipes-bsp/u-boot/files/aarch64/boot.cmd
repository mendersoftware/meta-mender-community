run mender_setup;
setenv bootargs console=${console} console=tty1 root=${mender_kernel_root} rootwait panic=10 ${extra}
mmc dev ${mender_uboot_dev};
load ${mender_uboot_root} ${fdt_addr_r} /boot/${fdtfile};
load ${mender_uboot_root} ${kernel_addr_r} /boot/Image;
booti ${kernel_addr_r} - ${fdt_addr_r};
run mender_try_to_recover;
