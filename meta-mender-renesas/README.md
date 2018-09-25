# Mender integration for Renesas based boards

Supported boards:
    - R-Car M3/H3

## Build

Download the source:

    $ mkdir mender-renesas
    $ cd mender-renesas
    $ repo init \
           -u https://github.com/mendersoftware/meta-mender-community \
           -m meta-mender-renesas/scripts/manifest-renesas.xml \
           -b rocko
    $ repo sync

Setup environment

    $ export TEMPLATECONF=../meta-mender-community/meta-mender-renesas/templates/
    $ . sources/poky/oe-init-build-env build

Build

    $ bitbake core-image-base
