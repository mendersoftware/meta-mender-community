# meta-mender-tegra

Mender integration layer for NVIDIA Tegra hardware.

The supported and tested boards are:

- [Jetson TX2](https://hub.mender.io/t/nvidia-tegra-jetson-tx2/123)
- [Jetson Nano](https://hub.mender.io/t/nvidia-tegra-jetson-nano/1360)
- [Jetson Xavier NX](https://hub.mender.io/t/nvidia-tegra-jetson-xavier-nx/2615)
- [Jetson AGX Xavier](https://hub.mender.io/t/nvidia-tegra-agx-xavier/2616)

Visit the individual board links above for more information on status of the
integration and more detailed instructions on how to build and use images
together with Mender for the mentioned boards.


## Dependencies

This layer depends on:

```
URI: https://github.com/OE4T/meta-tegra.git
layers: meta-tegra
branch: kirkstone-l4t-r32.7.x
revision: HEAD
```

```
URI: https://github.com/mendersoftware/meta-mender.git
layers: meta-mender-core
branch: kirkstone
revision: HEAD
```

## Quick start

See the mender hub pages and the documentation for the `tegrademo-mender`
distro on the [tegra-demo-distro](https://github.com/OE4T/tegra-demo-distro) repository
for the most up to date instructions on starting out with mender and tegra.

## [`kas`](https://github.com/siemens/kas) configurations

The following configuration files for building using the `kas` tool are provided:

- [jetson-agx-xavier-devkit.yml](../kas/jetson-agx-xavier-devkit.yml)
- [jetson-nano-2gb-devkit.yml](../kas/jetson-nano-2gb-devkit.yml)
- [jetson-nano-devkit-emmc.yml](../kas/jetson-nano-devkit-emmc.yml)
- [jetson-nano-devkit.yml](../kas/jetson-nano-devkit.yml)
- [jetson-tx2-devkit-4gb.yml](../kas/jetson-tx2-devkit-4gb.yml)
- [jetson-tx2-devkit-tx2i.yml](../kas/jetson-tx2-devkit-tx2i.yml)
- [jetson-tx2-devkit.yml](../kas/jetson-tx2-devkit.yml)
- [jetson-xavier-nx-devkit-emmc.yml](../kas/jetson-xavier-nx-devkit-emmc.yml)
- [jetson-xavier-nx-devkit-tx2-nx.yml](../kas/jetson-xavier-nx-devkit-tx2-nx.yml)
- [jetson-xavier-nx-devkit.yml](../kas/jetson-xavier-nx-devkit.yml)

## Acknowlegements

Special thanks to [Matt Madison](https://github.com/madisongh) for his contributions to
support zeus and later branches and his work on meta-tegra which makes this mender
integration possible.

Thanks also to [Kurt Keifer](https://github.com/kekiefer/) for his contributions and
cleanup to support additional platforms and the tegra-demo-distro on the dunfell release.
