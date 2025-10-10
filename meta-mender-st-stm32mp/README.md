# meta-mender-st-stm32mp

Mender integration layer for STM32MP family of boards.

The supported and tested boards are:
 
- [STM32MP257F-DK Discovery Kit] (https://www.st.com/en/evaluation-tools/stm32mp257f-dk.html)


Useful Link(s)
- [STM32MPU Yocto](https://wiki.st.com/stm32mpu/index.php?title=STM32MPU_Distribution_Package&sfr=stm32mpu)


## Dependencies

* [KAS] (https://kas.readthedocs.io/en/1.0/index.html)
* Computer that can build yocto

## Quick start

The following commands will setup the environment and allow you to build images
that have Mender integrated.

```
mkdir my-stm32mp2
cd my-stm32mp2/
kas build ../kas/stm32mp2.yml
```
or
```
kas build ../kas/stm32mp2emmc.yml
```

## Flash the image from scratch:

```
cd build/tmp-glibc/deploy/images/stm32mp2-dk-mender
export SDCARD_SIZE=16000
 ./scripts/create_sdcard_from_flashlayout.sh flashlayout_st-image-core/opteemin/FlashLayout_sdcard_stm32mp257f-dk-opteemin.tsv
sudo dd if='flashlayout_st-image-core/opteemin/../../FlashLayout_sdcard_stm32mp257f-dk-opteemin.raw' of=/dev/sdb bs=8M conv=fdatasync status=progress
```
This file is the partition file; you can see the layout of the drive in the STM compatible file:
```
flashlayout_st-image-core/opteemin/FlashLayout_sdcard_stm32mp257f-dk-opteemin.tsv
```

For emmc if image end up too big for the emmc you can set rootfs size.
```
my-stm32/meta-st-stm32mp/conf/machine/include/st-machine-flashlayout-stm32mp.inc
```

```
FLASHLAYOUT_PARTITION_SIZE:emmc:${STM32MP_ROOTFS_LABEL} = "1572864"
```

https://wiki.st.com/stm32mpu/wiki/STM32MP25_Discovery_kits_-_Starter_Package#Flash_microSD_card
```
STM32_Programmer_CLI  -c port=usb1  -w ./flashlayout_st-image-core/optee/FlashLayout_emmc_stm32mp257f-dk-optee.tsv 
```    
## Troubleshooting flashing

It is known that Gnome firmware update can affect flashing. 
STM32_Programmer_CLI  --list usb does full rescongie the devie missing Product ID.
'sudo systemctl stop fwupd' will temporarily disable it.

Sometimes the OP-TEE may not compile correctly. You may want to copy over fip-stm32mp257f-dk-optee-programmer-usb.bin (or similar) from a vanilla build: https://wiki.st.com/stm32mpu/index.php?title=STM32MPU_Distribution_Package&sfr=stm32mpu
Only that is required; other FIP files contain U-Boot and may break the Mender integration.