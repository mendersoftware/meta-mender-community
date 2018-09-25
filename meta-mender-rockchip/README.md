# Mender integration for Rockchip based boards

Supported boards:

- Tinker Board

## Build

Download the source:

    $ mkdir mender-rockchip
    $ cd mender-rockchip
    $ repo init \
           -u https://github.com/mendersoftware/meta-mender-community \
           -m meta-mender-rockchip/scripts/manifest-rockchip.xml \
           -b rocko
    $ repo sync

Setup environment

    $ export TEMPLATECONF=../meta-mender-community/meta-mender-rockchip/templates/
    $ . sources/poky/oe-init-build-env build

Build

    $ bitbake core-image-base
