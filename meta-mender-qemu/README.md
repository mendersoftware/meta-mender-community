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
           -b rocko
    $ repo sync

Setup environment

    $ export TEMPLATECONF=../meta-mender-community/meta-mender-qemu/templates/
    $ . sources/poky/oe-init-build-env build

Build

    $ bitbake core-image-base
