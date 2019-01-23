# Mender integration for 96boards

You can find detailed information about usage of board integrations on [Mender Hub](https://hub.mender.io/).

Supported boards:

 - [Poplar](https://hub.mender.io/t/96boards-poplar/181)

## Quick start

Download the source:

    $ mkdir mender-poplar && cd mender-poplar
    $ repo init -u https://github.com/96boards/oe-rpb-manifest.git -b sumo
    $ wget --directory-prefix .repo/manifests/ https://raw.githubusercontent.com/mendersoftware/meta-mender-community/sumo/meta-mender-96boards/scripts/manifest-96boards.xml
    $ repo init -m manifest-96boards.xml
    $ repo sync

Setup environment

    $ MACHINE=poplar DISTRO=rpb source setup-environment-mender

Build

    $ bitbake rpb-console-image
