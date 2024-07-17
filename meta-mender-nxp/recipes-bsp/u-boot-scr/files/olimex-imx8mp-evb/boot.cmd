run sr_ir_v2_cmd
mmc dev 1
setenv devtype mmc
setenv devnum 1
setenv distro_bootpart 1
run scan_dev_for_efi
setenv bootargs '${jh_clk} ${mcore_clk} console=${console},${baudrate} root=${mender_kernel_root} rootwait rw'
run mender_setup
mmc dev ${mender_uboot_dev}
fatload mmc ${mmcdev}:${mmcpart} ${loadaddr} ${image}
booti ${loadaddr} - ${fdt_addr_r}
run mender_try_to_recover
