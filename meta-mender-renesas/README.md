# meta-mender-renesas

# Notes

Supported boards:

 - [RZ/G2L](https://www.renesas.com/us/en/products/microcontrollers-microprocessors/rz-mpus/rzg2l-general-purpose-microprocessors-dual-core-arm-cortex-a55-12-ghz-cpus-and-single-core-arm-cortex-m33)(smarc-rzg2l)

# Dependencies

This layer depends on:

```
URI: https://github.com/renesas-rz/meta-renesas.git
tag: BSP-3.0.1
revision: HEAD
```

```
URI: https://github.com/mendersoftware/meta-mender.git
layers: meta-mender-core
branch: dunfell
revision: HEAD
```

# Build
The following commands will setup the environment and allow you to build images
that have Mender integrated.

- Download the source
```
mkdir mender-rzg2l && cd mender-rzg2l
repo init -u https://github.com/mendersoftware/meta-mender-community \
           -m meta-mender-renesas/scripts/manifest-renesas.xml \
           -b dunfell
repo sync
```
- Setup the environment
```
source setup-environment renesas
```

- Build
```
bitbake core-image-minimal
```

# Setup the board
For flashing and setting up the board, follow the official [Renesas documentation](https://www.renesas.com/us/en/document/gde/smarc-evk-rzg2l-rzg2lc-rzg2ul-rzv2l-and-rzfive-start-gude-rev103?language=en&r=1467981).

The board can boot in different modes, the SW11 switch is responsable to define the boot mode and input voltage mode. SW11[4] = 1, means 5V input and SW11[4] = 0, means 9V as input voltage.

|     Boot Mode      | SW11[1..4] |
| :----------------: | :--------: |
|     QSPI Mode      |    0001    |
| SCIF Download Mode |    0101    |
|        eMMC        |    1001    |
|        eSD         |    1101    |

The board also has a debug mode & main boot device selection

|    Debug mode    | SW1[1] |
| :--------------: | :----: |
|       JTAG       |   0    |
| Normal operation |   1    |

|     Boot devie     | SW1[2] |
| :----------------: | :----: |
|  eMMC on the SoM   |   0    |
| microSD on the SoM |   1    |

## Power on/off the board

- Press and hold for 1 second the SW9 push button to power on the board. The LED4 should be on.
- To turn it off, press and hold for 2 seconds the SW9 push button.


## Booting the Flash Writer
The following is the serial configuration for the board

|   Variable   |    Value     |
| :----------: | :----------: |
|    Speed     | 115200 bauds |
|     Data     |     8bit     |
|    Parity    |     None     |
|   Stop bit   |     1bit     |
| Flow control |     None     |

To enable send files to the board, set the SW11 switch to SCIF Download Mode (0101)

`TeraTerm > File > Send file > Open the Flash Writer file > Send the file.`

## Writing the bootloader

In the device terminal (Tera Term session), run the `XLS2` and send both bootloader files with their repective addresses.


|     Variable     |                            Value                            | Address to RAM  | Address to ROM  |
| :--------------: | :---------------------------------------------------------: | :-------------: | :-------------: |
|   Linux kernel   |                    Image-smarc-rzg2l.bin                    |   0x48080000    |        -        |
| Device tree file |                 Image-r9a07g044l2-smarc.dtb                 |   0x48000000    |        -        |
|   Boot loader    | bl2_bp-smarc-rzg2l_pmic.srec <br> fip-smarc-rzg2l_pmic.srec | 11E00 <br> 0000 | 0000 <br> 1D200 |
|   Flash Writer   |    Flash_Writer_SCIF_RZG2L_SMARC_PMIC_DDR4_2GB_1PCS.mot     |        -        |        -        |
|     Root FS      |              _IMAGE_NAME_-smarc-rzg2l.tar.bz2               |        -        |        -        |

In case a message to prompt to clear data, enter “y”.

### Using Renesas Macro to flash

There is an available [macro](https://github.com/seebe/rzg_stuff/blob/master/boards/rzg2l_smarc/rzg2l_smarc-rzg2l_flash_writer.ttl) to flash using Tera Term easily.

Create a folder with the following structure:

```bash
renesas_macro
├── Binaries
│   ├── bl2...
│   └── fip...
└── rzg2l_smarc-rzg2l_flash_writer.ttl
```
Copy the binaries files to flash and load the macro:

`TeraTerm > Control > Macro > Open Macro File`

## Preparing the microSD card

The SD layout it is as following

| Type/Number |         Size          | Filesystem |           Contents            |
| :---------: | :-------------------: | :--------: | :---------------------------: |
| Primary #1  | 500MB (minimum 128MB) |   FAT32    | Linux kernel <br> Device tree |
| Primary #2  |   1/2 of remaining    |    Ext4    |      AB Root filesystem       |
| Primary #3  |   1/2 of remaining    |    Ext4    |      AB Root filesystem       |
| Primary #4  |          TBD          |    Ext4    |        Data partition         |

### Repartitioning

1. Run `fdisk` command to repartition the microSD card

```
# fdisk /dev/SD_DEV
```

2. Enter `o` (new DOS disklabel)
3. Enter `n` (boot partition)
   - `p` (primary partition)
   - `Enter` (keep the default)
   - `+500M` (the size)
   - `Enter` (keep the default)
   - `Y` (remove the signatures)
4. Enter `n` (rootfs partition)

   - `p`
   - `Enter` (keep the default)
   - `Enter` (keep the default)
   - `+2048M` (the size)
   - `Y` (remove the signatures)

   _Repeat the step 3 to create the additional partition for AB system & data_

5. Enter `p` (review the changes)
6. Enter `t` (change partition type)
   - `1` (boot partition)
   - `b` (W95 FAT32)
7. Enter `w` (save & write the changes)

### Validate the partitions

1. Run the following commands

```
$ partprobe
# fdisk -l /dev/SD_DEV
```

_Validate the microSD card has the wanted layout_

### Format the partitions

```
# mkfs.vfat -v -c -F 32 /dev/SD_DEV_1
# mkfs.ext4 -L rootfs /dev/SD_DEV_2
# mkfs.ext4 -L rootfs /dev/SD_DEV_3
# mkfs.ext4 -L rootfs /dev/SD_DEV_4
```

### Copying files

1. Create mounting directories

```
# mkdir /mnt/sd_boot
# mkdir /mnt/sd_rootfs_a
# mkdir /mnt/sd_rootfs_b
# mkdir /mnt/sd_data
```

2. Mount the partitions

```
# mount /dev/SD_DEV_1 /mnt/sd_boot
# mount /dev/SD_DEV_2 /mnt/sd_rootfs_a
# mount /dev/SD_DEV_3 /mnt/sd_rootfs_b
# mount /dev/SD_DEV_4 /mnt/sd_data
```

3. Check the partitions correctly mounted

```
$ df
```

4. Copy the boot files

```
$ cp $WORK/build/tmp/deploy/images/<board>/<Linux kernel> /mnt/sd_boot/Image-smarc-rzg2l.bin
$ cp $WORK/build/tmp/deploy/images/<board>/<Device tree> /mnt/sd_boot/Image-r9a07g044l2-smarc.dtb
```

5. Expand the rootfs in partition 2 & 3

```
$ cd /mnt/sd_rootfs_a
# tar jxvf $WORK/build/tmp/deploy/images/<board>/<root filesystem>
$ cd /mnt/sd_rootfs_b
# tar jxvf $WORK/build/tmp/deploy/images/<board>/<root filesystem>
```

6. Copy the fw_env.config file
```
$ mkdir -p /mnt/sd_data/u-boot
$ cp meta-mender-renesas/misc/fw_env.config /data/u-boot/fw_env.config
```

7. Copy the device_type file
```
$ mkdir -p /mnt/sd_data/mender
$ cp meta-mender-renesas/misc/device_type /data/mender/device_type
```

# Boot and setup U-boot

To use U-boot, set the SW11 switch to QSPI Mode (0001). On first boot, reset the enviroment:

```
env default -a
saveenv
```

Then you can boot the board with `boot` command or reset it.
