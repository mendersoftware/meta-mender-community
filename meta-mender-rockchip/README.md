# Mender integration for Rockchip based boards

Supported boards:

 - [Rock Pi E](https://rockpi.eu/RockpiE)

## Build

Download the source:

    $ mkdir mender-rockchip
    $ cd mender-rockchip
    $ repo init \
           -u https://github.com/mendersoftware/meta-mender-community \
           -m meta-mender-rockchip/scripts/manifest-rockchip.xml \
           -b kirkstone
    $ repo sync

Setup environment

    $ . setup-environment rockchip

Build

    $ bitbake core-image-base
