# Yocto community integration layers for Mender

Mender is an open source over-the-air (OTA) software updater for embedded Linux
devices. Mender comprises a client running at the embedded device, as well as
a server that manages deployments across many devices.

This repository contains Yocto integration layers for various boards.

Please check out https://hub.mender.io for more information on
supported boards and instructions on how to setup environment and build images.

![Mender logo](https://github.com/mendersoftware/mender/raw/master/mender_logo.png)

## Structure

This section is for anyone interested in contributing support for a board.

meta-mender-community is a repository containing multiple Yocto layers for
integrating Mender onto various boards.

The layers are structured based on upstream BSP layers and not individual
boards.

There are multiple types of layers included here.

SoC-oriented:

- meta-amlogic
- meta-freescale
- meta-sunxi
- meta-rockchip
- meta-renesas

Vendor-oriented:

- meta-variscite
- meta-phytec
- meta-toradex-nxp
- meta-mender-octavo-osd32mp

Naming of integration layers follows the upstream naming conventions with SoM
vendor layer name having priority. The convention is:

```
   meta-mender-<upstream suffix>
```

This should make it clear which layer is targeting what BSP.

## Build setup

Traditionally `meta-mender-community` has required board integrations to provide build setup configuration through the [repo](https://gerrit.googlesource.com/git-repo) tool by Google. As it has a number of shortcomings, things are being moved to [kas](https://github.com/siemens/kas).

All submitted board integrations need to provide a build setup strategy. New `repo`-based setups will usually be rejected.

### `kas`

For an introduction on `kas`, please see the [tutorial article](https://hub.mender.io/t/using-kas-to-reproduce-your-yocto-builds/6020) on the Mender Hub.

#### Building an image for a supported board

##### TL;DR

To build an image using `kas`, you simply call it with the `build` verb and the desired configuration. Example for the Raspberry Pi 4, 64bit:
```
kas build meta-mender-community/kas/raspberrypi4-64.yml
```

##### A full getting started build procedure

Install the `kas` tool (optionally, you can install globally for all users. Run as `root`, respectively under `sudo` then):
```
pip install kas
```

Clone this repository:
```
git clone https://github.com/mendersoftware/meta-mender-community
```

Create a build directory and change into it:
```
mkdir -p meta-mender-community/my-build && cd meta-mender-community/my-build
```

Call kas to build for the Raspberry Pi 4, 64bit:
```
kas build ../kas/raspberrypi4-64.yml
```

The canonical build structure including resulting deployable images is located under `meta-mender-community/my-build/build`.

#### Adding a new build configuration

In the most straightforward case, a board integration can simply consist of a `kas` configuration file. Those are located in the `kas` top level directory.

Some relevant best practises:
- if possible, common parts of board integrations should be factored out into includes. Those are located in the `kas/include` directory.
- the `mender-full.yml` or `mender-full-ubi.yml` includes should be used as baseline
- a minimal approach concerning image and `DISTRO` should be preferred
  - the default image is `core-image-minimal`, consider keeping it unless your platform has specific requirements
  - the default `DISTRO` is a `nodistro`, pure OpenEmbedded setup. While selecting a larger or custom `DISTRO` is acceptable, consider being as slim as possible to provide the highest degree of freedom to your users.

Requirements:
- revisions of metadata layers defined in the configurations must be fixed. Exception: the `master` branch which tracks the Yocto Project / OpenEmbedded upstream
- the primary targetted branch must be a Yocto Project LTS correlated one
- add your board to the automated build configuration at `.github/workflows/build.yml`, marked as `experimental`. It will be moved out of experimental after a number of successful builds by the Mender team.

### Google repo

**Note: `repo` support is currently kept for compatibility reasons but will be removed in the future.**

#### Manifest files

The google repo tool and associated manifest files are used for managing the
list of repositories needed for these builds. The common manifests
(meta-mender-community/scripts/mender.xml) is included by board-specific
manifests and include the required Mender layers:

    meta-mender-community/scripts/mender.xml

This includes the required Mender layers,
[meta-mender](https://github.com/mendersoftware/meta-mender) and
[meta-mender-community](https://github.com/mendersoftware/meta-mender-community).

Each integration layer should provide a manifest file, e.g

    meta-mender-community/meta-mender-sunxi/scripts/manifest-sunxi.xml

#### Templates and configuration fragments

To use this layer:

1. Download the source:

```
    $ mkdir mender-<vendor/soc name>
    $ cd mender-<vendor/soc name>
    $ repo init \
           -u https://github.com/mendersoftware/meta-mender-community \
           -m meta-mender-<vendor/soc name>/scripts/manifest-<vendor/soc name>.xml \
           -b kirkstone
    $ repo sync
```

2. Setup environment:

```
    $ . ./setup-environment <vendor/soc name>
```

3. Build:

```
    $ bitbake core-image-base
```

The `setup-environment` script provided is a wrapper for the Yocto
`oe-init-build-env` script.

Each integration layer must provide:

- local.conf.append: this contains board-specific changes to be appended to
the Yocto-generated local.conf file
- bblayers.conf.sample: a template that will be copied to bblayers.conf
- an entry in [setup-environment](https://github.com/mendersoftware/meta-mender-community/blob/rocko/scripts/setup-environment#L20-L25)

## Contributing

We welcome and ask for your contribution. If you would like to contribute to
Mender, please read our guide on how to best get started [contributing code or
documentation](https://github.com/mendersoftware/mender/blob/master/CONTRIBUTING.md).

### Community maintainers

A list of community maintainers and the description of the role is located [here](https://github.com/mendersoftware/meta-mender-community/wiki/Community-maintainers).

## License

Mender is licensed under the Apache License, Version 2.0. See
[LICENSE](https://github.com/mendersoftware/meta-mender-community/blob/master/LICENSE) for the
full license text.


## Connect with us

* Join the [Mender Hub discussion forum](https://hub.mender.io)
* Follow us on [Twitter](https://twitter.com/mender_io). Please
  feel free to tweet us questions.
* Fork us on [Github](https://github.com/mendersoftware)
* Create an issue in the [bugtracker](https://tracker.mender.io/projects/MEN)
* Email us at [contact@mender.io](mailto:contact@mender.io)
* Connect to the [#mender IRC channel on Libera](https://web.libera.chat/?#mender)


## Authors

Mender was created by the team at [Northern.tech AS](https://northern.tech), with many contributions from
the community. Thanks [everyone](https://github.com/mendersoftware/mender/graphs/contributors)!

[Mender](https://mender.io) is sponsored by [Northern.tech AS](https://northern.tech).
