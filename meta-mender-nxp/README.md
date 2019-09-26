# Mender integration for nxp based boards

Supported boards:

 - WaRP7
 - Pico-Pi i.MX7D
 - Nitrogen8M

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
