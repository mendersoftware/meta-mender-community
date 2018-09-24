# Mender integration for QEMU machines

Supported targets:

- qemux86-64 (default)
- vexpress-qemu
- vexpress-qemu-flash

## Build

Download the source:

    $ mkdir mender-qemu
    $ cd mender-qemu
    $ repo init \
           -u https://github.com/mirzak/meta-mender-community \
           -m meta-mender-qemu/scripts/manifest-qemu.xml \
           -b sumo
    $ repo sync

Setup environment

    $ export MENDER_LAYER=${PWD}/sources/meta-mender-community/meta-mender-qemu
    $ export TEMPLATECONF=${MENDER_LAYER}/templates/
    $ . sources/poky/oe-init-build-env build

Build

    $ bitbake core-image-base
