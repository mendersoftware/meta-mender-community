# Mender integration for nxp based boards

Supported boards:

 - WaRP7

## Build

Download the source:

    $ mkdir mender-nxp
    $ cd mender-nxp
    $ repo init \
           -u https://github.com/mendersoftware/meta-mender-community \
           -m meta-mender-nxp/scripts/manifest-nxp.xml \
           -b sumo
    $ repo sync

Setup environment

    $ . setup-environment nxp

Build

    $ bitbake core-image-base
