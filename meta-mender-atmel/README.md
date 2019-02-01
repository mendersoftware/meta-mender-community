# Mender integration for atmel based boards

Supported boards:

 - sama5d27-som1-ek-sd
 - sama5d3-xplained-sd

## Build

Download the source:

    $ mkdir mender-atmel
    $ cd mender-atmel
    $ repo init \
           -u https://github.com/mendersoftware/meta-mender-community \
           -m meta-mender-atmel/scripts/manifest-atmel.xml \
           -b thud
    $ repo sync

Setup environment

    $ . setup-environment atmel

Build

    $ bitbake core-image-base
