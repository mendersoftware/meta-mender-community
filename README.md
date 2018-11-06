# Yocto community integration layers for Mender

Mender is an open source over-the-air (OTA) software updater for embedded Linux
devices. Mender comprises a client running at the embedded device, as well as
a server that manages deployments across many devices.

This repository contains Yocto integration layers for various boards.

Please check out https://hub.mender.io for more information on
supported boards and instructions on how to setup environment and build images.

![Mender logo](https://mender.io/user/pages/resources/06.digital-assets/mender.io.png)

## Structure

This section is for anyone interested in contribution support for a board.

meta-mender-community is a repository containing multiple Yocto layers for
integrating Mender onto various boards.

The layers are structured based on upstream BSP layers and not individual
boards.

There are multiple types of layers included here.

SoC-oriented:

- meta-freescale
- meta-sunxi
- meta-rockchip
- meta-renesas

Vendor-oriented:

- meta-variscite
- meta-phytec
- meta-toradex-nxp

Naming of integration layers follows the upstream naming conventions with SoM
vendor layer name having priority. The convention is:

```
   meta-mender-<upstream suffix>
```

This should make it clear which layer is targeting what BSP.

### Manifest files

The google repo tool and associated manifest files are used for managing the
list of repositories needed for these builds. The common manifest
(meta-mender-community/scripts/mender.xml) is included by board-specific
manifests and include the required Mender layers:

    meta-mender-community/scripts/mender.xml

This includes the required Mender layers,
[meta-mender](https://github.com/mendersoftware/meta-mender) and
[meta-mender-community](https://github.com/mendersoftware/meta-mender-community).

Each integration layer should provide a manifest file, e.g

    meta-mender-community/meta-mender-sunxi/scripts/manifest-sunxi.xml

### Templates and configuration fragments

To use this layer:

1. Download the source:

```
    $ mkdir mender-<vendor/soc name>
    $ cd mender-<vendor/soc name>
    $ repo init \
           -u https://github.com/mendersoftware/meta-mender-community \
           -m meta-mender-<vendor/soc name>/scripts/manifest-<vendor/soc name>.xml \
           -b sumo
```

2. Setup environment:

```
    $ . setup-environment <vendor/soc name>
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

## License

Mender is licensed under the Apache License, Version 2.0. See
[LICENSE](https://github.com/mendersoftware/meta-mender-community/blob/sumo/LICENSE) for the
full license text.

## Connect with us

* Join our [Google
  group](https://groups.google.com/a/lists.mender.io/forum/#!forum/mender)
* Follow us on [Twitter](https://twitter.com/mender_io?target=_blank). Please
  feel free to tweet us questions.
* Fork us on [Github](https://github.com/mendersoftware)
* Email us at [contact@mender.io](mailto:contact@mender.io)
