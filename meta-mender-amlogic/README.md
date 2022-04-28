# Mender integration for Amlogic based boards

Tested boards:

 - libretech-cc

## Build

Download the source:

    $ mkdir mender-amlogic
    $ cd mender-amlogic
    $ repo init \
           -u https://github.com/mendersoftware/meta-mender-community \
           -m meta-mender-amlogic/scripts/manifest-amlogic.xml \
           -b kirkstone
    $ repo sync

Setup environment

    $ . setup-environment amlogic

Build

    $ bitbake core-image-base
