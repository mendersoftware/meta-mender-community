meta-mender-update-modules
==========================

Mender is an open source over-the-air (OTA) software updater for embedded Linux devices. Mender comprises a client running at the embedded device, as well as a server that manages deployments across many devices.

This repository contains Yocto recipes for community supported Update Modules. An Update Module is an extension to the Mender client for supporting a new type of software update, such as a package manager, container, bootloader or even updates of nearby microcontrollers. An Update Module can be tailored to a specific device or environment (e.g. update a proprietary bootloader), or be more general-purpose (e.g. install a set of .deb packages.).

There are a couple of general-purpose Update Modules bundled together with the [Mender client source code](https://github.com/mendersoftware/mender/tree/master/support/modules), these can be installed using [meta-mender](https://github.com/mendersoftware/meta-mender).

![Mender logo](https://mender.io/user/pages/resources/06.digital-assets/mender.io.png)

## Getting started

To start using Mender, we recommend that you begin with the Getting started
section in [the Mender documentation](https://docs.mender.io/).

To start using Mender Update Modules, we recommend that you begin with the Update Modules - Introduction
section in [the Mender documentation](https://docs.mender.io/devices/update-modules).

You can find detailed information about available Update Modules on [Mender Hub](https://hub.mender.io/c/update-modules).

## Contributing

We welcome and ask for your contribution. If you would like to contribute to Mender, please read our guide on how to best get started [contributing code or
documentation](https://github.com/mendersoftware/mender/blob/master/CONTRIBUTING.md).

## Connect with us

* Join the [Mender Hub discussion forum](https://hub.mender.io)
* Follow us on [Twitter](https://twitter.com/mender_io). Please
  feel free to tweet us questions.
* Fork us on [Github](https://github.com/mendersoftware)
* Create an issue in the [bugtracker](https://tracker.mender.io/projects/MEN)
* Email us at [contact@mender.io](mailto:contact@mender.io)
* Connect to the [#mender IRC channel on Freenode](http://webchat.freenode.net/?channels=mender)


## Authors

Mender was created by the team at [Northern.tech AS](https://northern.tech), with many contributions from
the community. Thanks [everyone](https://github.com/mendersoftware/meta-mender-community/graphs/contributors)!

[Mender](https://mender.io) is sponsored by [Northern.tech AS](https://northern.tech).
