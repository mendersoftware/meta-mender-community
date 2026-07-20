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

- meta-mender-amlogic
- meta-mender-nxp
- meta-mender-tegra
- meta-mender-xilinx
...

Vendor-oriented:

- meta-mender-raspberrypi
- meta-mender-toradex-nxp
- meta-mender-octavo-osd32mp
...

Naming of integration layers follows the upstream naming conventions with SoM
vendor layer name having priority. The convention is:

```
   meta-mender-<upstream suffix>
```

This should make it clear which layer is targeting what BSP.

## Contributing

We welcome and ask for your contribution. If you would like to contribute to
Mender, please read our guide on how to best get started [contributing code or
documentation](https://github.com/mendersoftware/mender/blob/master/CONTRIBUTING.md).

Community contributed layers will be co-maintained by the Mender team on a best-effort
base. Coordination of reviews and merges happens case by case and based on responsiveness,
respectively activity. Reviews and acknowledgements by the original contributors are explicitly
not required for further contributions, in order to not block development and maintenance.

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
