# meta-mender-tegra

Mender integration layer for NVIDIA Tegra hardware.

The supported and tested boards are:

- AGX Orin
- AGX Xavier
- Orin Nano


## Dependencies

This layer depends on:

```
URI: https://github.com/madisongh/meta-tegra.git
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

- [jetson-agx-orin-devkit.yml](../../kas/jetson-agx-orin-devkit.yml)
- [jetson-agx-xavier-devkit.yml](../../kas/jetson-agx-xavier-devkit.yml)
- [jetson-orin-nano-devkit.yml](../../kas/jetson-orin-nano-devkit.yml)

## Acknowlegements

Special thanks to [Matt Madison](https://github.com/madisongh) for his contributions to
support zeus and later branches and his work on meta-tegra which makes this mender
integration possible.

Thanks also to [Kurt Keifer](https://github.com/kekiefer/) for his contributions and
cleanup to support additional platforms and the tegra-demo-distro on the dunfell release.
