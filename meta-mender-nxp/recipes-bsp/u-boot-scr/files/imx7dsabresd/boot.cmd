setenv bootargs 'console=${console},${baudrate} root=${mender_kernel_root} rootwait rw'
run mender_setup
mmc dev ${mender_uboot_dev}
load ${mender_uboot_root} ${loadaddr} /boot/${image}
load ${mender_uboot_root} ${fdt_addr} /boot/${fdt_file}
bootz ${loadaddr} - ${fdt_addr}
run mender_try_to_recover
