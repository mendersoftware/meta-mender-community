# Mender integration for NVIDIA Tegra

This layer contains [mender](https://mender.io/) specific integrations for NVIDIA Tegra hardware, for Over The Air (OTA) software update support of Yocto based NVIDIA Tegra builds.

It depends on the [meta-tegra](https://github.com/madisongh/meta-tegra) layer with branch matching the selected branch name.

See integration details in the [Mender Hub Page](https://hub.mender.io/t/nvidia-tegra-jetson-tx2/123)

Supported and Tested Boards:
* Jetson TX2 Development Board

### Build
Download the source:

    $ mkdir mender-tegra
    $ cd mender-tegra
    $ repo init \
            -u https://github.com/mendersoftware/meta-mender-community \
            -m meta-mender-tegra/scripts/manifest-tegra.xml \
            -b sumo
    $ repo sync

Setup environment

    $ . setup-environment tegra

Build

    $ bitbake core-image-base

