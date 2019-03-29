# Mender integration for nxp based boards

Supported boards:

 - Pico-Pi i.MX7D
 - pico-imx7d - Technexion Pico-Pi i.MX7D System-on-module (https://d15z4ngi7vchau.cloudfront.net/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/p/i/picoimx7-revb1-topweb_5.jpg)

## Build

Download the source:

    $ mkdir mender-nxp
    $ cd mender-nxp
    $ repo init \
           -u https://github.com/mendersoftware/meta-mender-community \
           -m meta-mender-nxp/scripts/manifest-nxp.xml \
           -b warrior
    $ repo sync

Setup environment

    $ . setup-environment nxp

Build

    $ bitbake core-image-base
