# Mender integration for Variscite SoMs

Variscite SoM's are configurable when you order them, this means that the
integration can be configuration specific and you might need to make
adjustments based on your configuration.

The goal of this layer is to support as many configurations as possible,
ultimately all of them, but to be able to do that we need to collaborate.

Supported SoMs:

- imx8mm-var-dart - [i.MX8M Mini](https://www.variscite.com/product/system-on-module-som/cortex-a53-krait/dart-mx8m-mini-nxp-i-mx8m-mini/) (uSD)

## Dependencies
This layer depends on:

```
URI: https://github.com/varigit/variscite-bsp-platform.git
branch: kirkstone
revision: HEAD
```

```
URI: https://github.com/mendersoftware/meta-mender.git
layers: meta-mender-core
branch: kirkstone
revision: HEAD
```

## Setup resources
- Variscite sources
```bash
repo init -u https://github.com/varigit/variscite-bsp-platform \
          -m imx-5.15.71-2.2.0.xml \
          -b kirkstone
repo sync -j$(nproc)
```

- Mender sources
```bash
cd sources
git clone https://github.com/mendersoftware/meta-mender.git \
         -b kirkstone
git clone https://github.com/mendersoftware/meta-mender-community.git \
         -b kirkstone
cd ..
```

## Build
- Setup the enviroment.
```bash
MACHINE=<machine> DISTRO=fslc-x11 source ./var-setup-release.sh build
```
For example, `MACHINE=imx8mm-var-dart`.

- Remove `meta-qt5` from bblayers.conf

- Add mender to the bblayers
```bash
bitbake-layers add-layer ../sources/meta-mender/meta-mender-core
bitbake-layers add-layer ../sources/meta-mender/meta-mender-demo
bitbake-layers add-layer ../sources/meta-mender-community/meta-mender-variscite
```

- Apply the local.conf changes
```bash
cat ../sources/meta-mender-community/templates/local.conf.append >> conf/local.conf
cat ../sources/meta-mender-community/meta-mender-variscite/templates/local.conf.append >> conf/local.conf
cat ../sources/meta-mender-community/meta-mender-variscite/templates/local-sdcard.conf.append >> conf/local.conf
```

- Build the image
```bash
bitbake core-image-base
```

## Boot the board
- Flash the image to the sd card
```bash
dd if=build/tmp/deploy/images/<machine>/core-image-base-<machine>.sdimg | pv | dd of=/dev/SD_CARD
```

- Set the correct BOOT_SELECT swith

    To boot from SD set the switch to ON (see the board datasheet)

- Reset the env variables
```bash
env default -a -f
saveenv
saveenv
reset
```

## References
- See specifics for the Compulab CL-SOM-iMX8 board at [Mender Hub](https://hub.mender.io/t/compulab-cl-som-imx8/416).
- See specifics for the Variscite DART-MX8M-MINI board at [Mender Hub](https://hub.mender.io/TBD).
