# meta-mender-st-stm32mp

Mender integration layer for STM32MP family of boards.

The supported and tested boards are:
 
- [STM32MP157C Discovery Kit](https://hub.mender.io/t/stm32mp157c-discovery-kit/1676)

Visit the individual board links above for more information on status of the
integration and more detailed instructions on how to build and use images
together with Mender for the mentioned boards.

This layer was build for Kirkstone Yocto version with the help of mender wiki that mentioned above. 
However the links on mender wiki are old. you need to use new ST wiki for kirkstone:
- [STM32MP1 kirkstone wiki](https://wiki.st.com/stm32mpu/wiki/STM32MP1_Distribution_Package)

1. Setup enviroment with ST wiki.
2. Add meta-mender layer - kirkstone branch
3. Add meta-mender-community layer - kirkstone branch
4. folow the Setup build environment on the Mender wiki.

## Dependencies

This layer depends on:

```
URI: https://github.com/STMicroelectronics/meta-st-stm32mp
branch: kirkstone
revision: HEAD
```

```
URI: https://github.com/STMicroelectronics/meta-st-openstlinux
branch: kirkstone
revision: HEAD
```

```
URI: https://github.com/STMicroelectronics/meta-st-stm32mp-addons
branch: kirkstone
revision: HEAD
```

```
URI: https://github.com/mendersoftware/meta-mender.git
layers: meta-mender-core
branch: kirkstone
revision: HEAD
```

## Quick start

The following commands will setup the environment and allow you to build images
that have Mender integrated.

1. Setup enviroment with ST [wiki](https://wiki.st.com/stm32mpu/wiki/STM32MP1_Distribution_Package).
2. Add meta-mender layer - kirkstone branch
3. Add meta-mender-community layer - kirkstone branch
4. run init script of meta-mender-community layer in meta-mender-st-stm32mp/scripts
```
. stm32mp-setup-mender.sh
```

5. Configure Mender server URL according mender [wiki](https://hub.mender.io/t/stm32mp157c-discovery-kit/1676)

6. Building the image
    You can now proceed with building an image:
    ```
    bitbake st-image-core   (Replace st-image-core with your desired image target.)
    ```

7. Using the build output
    After a successful build, the images and build artifacts are placed in:
    tmp-glibc/deploy/images/"your build name"/.

    tmp-glibc/deploy/images/stm32mp1-disco/st-image-core-stm32mp1-disco.gptimg

    tmp-glibc/deploy/images/stm32mp1-disco/st-image-core-stm32mp1-disco.mender

## Flash the image from scratch:


   * For first time board flash to eMMC you need to build image according ST wiki without mender layers and save the bootloaders files:
        * tmp-glibc/deploy/images/stm32mp1-disco/arm-trusted-firmware/tf-a-stm32mp157d-dk1-usb.stm32
        * tmp-glibc/deploy/images/stm32mp1-disco/fip/fip-stm32mp157d-dk1-trusted.bin
        * tmp-glibc/deploy/images/stm32mp1-disco/flashlayout_st-image-core\trusted\FlashLayout_emmc_stm32mp157d-dk1-trusted.tsv
    This files need to add to the STM32CubeProgrammer on the first burning stage.
   
   * Build the mender image according quick start
   * Change the name of gptimg to ".img"    
   * Modify FlashLayout_emmc_stm32mp157d-dk1-trusted.tsv file to this example: 
```
    #Opt	Id	Name	Type	IP	Offset	Binary
-	0x01	fsbl-boot	Binary	    none	0x0	        arm-trusted-firmware/tf-a-stm32mp157d-dk1-usb.stm32
-	0x03	fip-boot	FIP	        none	0x0	        /fip/fip-stm32mp157d-dk1-trusted.bin
P	0x04	fsbl1		Binary		mmc1	boot1		arm-trusted-firmware/tf-a-stm32mp157d-dk1-emmc.stm32
P	0x05	fsbl2		Binary		mmc1	boot2		arm-trusted-firmware/tf-a-stm32mp157d-dk1-emmc.stm32
P	0x10	emmc	    RawImage	mmc1	0x0	        st-image-core-stm32mp1-disco.img
```
    
* First 0x01 - 0x04 partitions are files from the regular ST wiki build without mender layers. 
* The 0x10 partition are the image that you build with mender layers. 
* Burn the board with STM32CubeProgrammer (you can find help in ST wiki).
    
    * for SD card we need to change the stm32mp-gptimg.bbclass and add fsbl1 ,fsbl2 to the first partitions ( see the quotes in this class)
    * end change the tsv file:
        * remove partition 0x04 and 0x05. 
        * change 0x10 to: sdcard	    RawImage	mmc0	0x0	        st-image-core-stm32mp1-disco.img

