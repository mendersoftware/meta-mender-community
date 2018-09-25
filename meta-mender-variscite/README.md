# Mender integration for Variscite SoMs

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
           -u https://github.com/mendersoftware/meta-mender-community \
           -m meta-mender-variscite/scripts/manifest-variscite.xml \
           -b sumo
    $ repo sync

Setup environment

    $ . setup-environment variscite

Build

    $ bitbake core-image-base
