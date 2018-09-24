# Mender integration for Freescale/NXP based boards

Some BSPs depend on libraries and packages which are covered by Freescale's
End User License Agreement (EULA). To have the right to use these binaries in
your images, you need to read and accept the terms. You can find the EULA in
meta-freescale/EULA. Please read it and accept it by adding:

    ACCEPT_FSL_EULA = "1"

to your `local.conf`

## Variscite

Variscite SoM's are configurable when you order them, this means that the
integration can be configuration specific and you might need to make
adjustments based on your configuration.

The goal of this layer is to support as many configurations as possible,
ultimately all of them, but to be able to do that we need to collaborate.

Supported SoMs:

    - imx6ul-var-dart - DART-6UL (uSD/eMMC, WiFi)

### Build

Download the source:

    $ mkdir mender-variscite
    $ cd mender-variscite
    $ repo init \
           -u https://github.com/mirzak/meta-mender-community \
           -m meta-mender-freescale/scripts/manifest-variscite.xml \
           -b sumo
    $ repo sync

Setup environment

    $ export MENDER_LAYER=${PWD}/sources/meta-mender-community/meta-mender-freescale
    $ export TEMPLATECONF=${MENDER_LAYER}/templates/variscite
    $ . sources/poky/oe-init-build-env build

Build

    $ bitbake core-image-base
