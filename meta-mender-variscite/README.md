# Mender integration for Variscite SoMs

Variscite offers a large variety of SoM and carrier boards. This layer aims to provide baseline integrations for as many of those as possible, applicable to the respective Yocto release.

Supported SoMs:

- imx93-var-som - [VAR-SOM-MX93](https://www.variscite.com/product/system-on-module-som/cortex-a55/var-som-mx93-nxp-i-mx-93/) (uSD)

## Dependencies
This layer depends on:

```
  meta-openembedded:
    url: https://git.openembedded.org/meta-openembedded

  meta-arm:
    url: https://git.yoctoproject.org/meta-arm

  meta-freescale:
    url: https://github.com/Freescale/meta-freescale

  meta-freescale-3rdparty:
    url: https://github.com/Freescale/meta-freescale-3rdparty

  meta-freescale-distro:
    url: https://github.com/Freescale/meta-freescale-distro

  meta-nxp:
    url: https://github.com/nxp-imx/meta-imx

  meta-variscite-bsp-common:
    url: https://github.com/varigit/meta-variscite-bsp-common

  meta-variscite-bsp-imx:
    url: https://github.com/varigit/meta-variscite-bsp-imx
```

The respective revisions and sub-layers are defined per integration in the kas configuration file.

## VAR-SOM-MX93

### Set up and run Yocto build

```bash
cd meta-mender-community
mkdir build-var-som-mx93
cd build-var-som-mx93
kas build ../kas/imx93-var-som.yml
```

### Flash uSD card

You can identify your uSD card by using the `mount`, `blkid` or `dmesg` commands. Replace `/dev/SD_CARD` in the command line below accordingly.

```bash
dd if=build/tmp/deploy/images/imx93-var-som/core-image-minimal-imx93-var-som.sdimg of=/dev/SD_CARD conv=fsync
```

### Boot the board

Insert flashed uSD card, set boot mode switch to SD and power on.
