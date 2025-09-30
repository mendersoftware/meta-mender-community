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

## Flash the image from scratch:

```
cd build/tmp-glibc/deploy/images/stm32mp2-dk-mender
export SDCARD_SIZE=16000
 ./scripts/create_sdcard_from_flashlayout.sh flashlayout_st-image-core/opteemin/FlashLayout_sdcard_stm32mp257f-dk-opteemin.tsv
sudo dd if='flashlayout_st-image-core/opteemin/../../FlashLayout_sdcard_stm32mp257f-dk-opteemin.raw' of=/dev/sdb bs=8M conv=fdatasync status=progress
```

This file is the parition file you can see the layot of the drive in stm compapateble file

flashlayout_st-image-core/opteemin/FlashLayout_sdcard_stm32mp257f-dk-opteemin.tsv

    
