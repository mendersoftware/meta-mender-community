# Mender integration for Rockchip based boards

Supported boards:

 - Tinker Board

## Build

Download the source:

    $ mkdir mender-rockchip
    $ cd mender-rockchip
    $ repo init \
           -u https://github.com/mirzak/meta-mender-community \
           -m meta-mender-rockchip/scripts/manifest-rockchip.xml \
           -b sumo
    $ repo sync

Setup environment

    $ export TEMPLATECONF=../meta-mender-community/meta-mender-rockchip/templates
    $ . sources/poky/oe-init-build-env build

Build

    $ bitbake core-image-base
