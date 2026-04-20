# meta-mender-st-stm32mp

Mender integration layer for STM32MP family of boards.

The supported and tested boards are:

- [STM32MP257F-DK Discovery Kit] (https://www.st.com/en/evaluation-tools/stm32mp257f-dk.html)


Useful links
- [STM32MPU Yocto](https://wiki.st.com/stm32mpu/index.php?title=STM32MPU_Distribution_Package&sfr=stm32mpu)


## Dependencies

* [KAS] (https://kas.readthedocs.io/en/1.0/index.html)
* A machine capable of building Yocto

## Quick start

The following commands set up the environment and allow you to build images
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

## STM32MP2 U-Boot note

On STM32MP2, U-Boot does not use Mender's standard bootcount flow cleanly across all boot paths. In particular, STM32 programmer and related boot modes do not behave like the normal eMMC boot path, so the rollback decision logic has been moved into the U-Boot environment instead of relying on the usual bootcount handling.

This layer therefore keeps the upgrade and rollback state in the U-Boot environment for STM32MP2 boards.

## STM32MP2 eMMC layout

The default eMMC configuration in [kas/stm32mp2emmc.yml](kas/stm32mp2emmc.yml) uses the following Mender-managed layout:

* Rootfs A: partition 6, 1536 MB
* Rootfs B: partition 7, 1536 MB
* Data: partition 8, 3072 MB
* U-Boot environment offsets: `0x9f8000` and `0x9fc000`
* Mender-managed storage size: 6146 MB

The full eMMC is larger than this. The remaining space is used by the STM32MP boot chain and flash layout metadata, so it is intentionally outside the Mender-managed area.

The partition sizes are defined in [meta-mender-st-stm32mp/conf/machine/stm32mp2-dk-mender-emmc.conf](meta-mender-st-stm32mp/conf/machine/stm32mp2-dk-mender-emmc.conf).

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

For eMMC, if the image ends up too large for the device, you can reduce the rootfs partition size.
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

It is known that Gnome Firmware Updater can affect flashing. 

If `STM32_Programmer_CLI --list usb` does not fully recognize the device, or the Product ID is missing, `fwupd` is often the cause.

```sudo systemctl stop fwupd``` will temporarily disable it.

Sometimes the OP-TEE may not compile correctly. You may want to copy over fip-stm32mp257f-dk-optee-programmer-usb.bin (or similar) from a vanilla build: https://wiki.st.com/stm32mpu/index.php?title=STM32MPU_Distribution_Package&sfr=stm32mpu

Only that is required; other FIP files contain U-Boot and may break the Mender integration.