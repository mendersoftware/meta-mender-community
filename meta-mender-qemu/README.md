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
           -u https://github.com/mendersoftware/meta-mender-community \
           -m meta-mender-qemu/scripts/manifest-qemu.xml \
           -b sumo
    $ repo sync

Setup environment

    $ . setup-environment qemu

Build

    $ bitbake core-image-base
