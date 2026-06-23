# meta-mender-tegra

Mender integration layer for NVIDIA Tegra hardware.

The supported and tested boards are:

- AGX Orin
- AGX Xavier
- Orin Nano
- Orin NX

## Dependencies

These layers depend on:

```
URI: https://github.com/OE4T/meta-tegra.git
layers: meta-tegra
branch: scarthgap-l4t-r35.x (JP5)   or   scarthgap (JP6)
revision: HEAD
```

```
URI: https://github.com/mendersoftware/meta-mender.git
layers: meta-mender-core
branch: scarthgap
revision: HEAD
```

## Layer structure

- `meta-mender-tegra-common`
  Holds all common parts of the Mender integration for Tegra across all
  currently supported releases of Jetpack

- `meta-mender-tegra-jetpack5`
  Holds Jetpack release 5 specific parts of the Mender integration for Tegra.
  This correlates with the `scarthgap-l4t-r35.x` branch of `meta-tegra`.

- `meta-mender-tegra-jetpack6`
  Holds Jetpack release 6 specific parts of the Mender integration for Tegra.
  This correlates with the `scarthgap` branch of `meta-tegra`.

## Quick start

See the mender hub pages and the documentation for the `tegrademo-mender`
distro on the [tegra-demo-distro](https://github.com/OE4T/tegra-demo-distro) repository
for the most up to date instructions on starting out with mender and tegra.

## [`kas`](https://github.com/siemens/kas) configurations

The following configuration files for building using the `kas` tool are provided:

### Jetpack 5

- [jetson-agx-orin-devkit.yml](../kas/tegra/jetpack5/jetson-agx-orin-devkit.yml)
- [jetson-agx-xavier-devkit.yml](../kas/tegra/jetpack5/jetson-agx-xavier-devkit.yml)
- [jetson-orin-16gb-nx-p3786.yml](../kas/tegra/jetpack6/jetson-orin-16gb-nx-p3786.yml)
- [jetson-orin-nano-devkit.yml](../kas/tegra/jetpack5/jetson-orin-nano-devkit.yml)

### Jetpack 6

- [jetson-agx-orin-devkit-64.yml](../kas/tegra/jetpack6/jetson-agx-orin-devkit-64.yml)
- [jetson-agx-orin-devkit.yml](../kas/tegra/jetpack6/jetson-agx-orin-devkit.yml)
- [jetson-orin-16gb-nx-p3786.yml](../kas/tegra/jetpack6/jetson-orin-16gb-nx-p3786.yml)
- [jetson-orin-nano-devkit.yml](../kas/tegra/jetpack6/jetson-orin-nano-devkit.yml)

### Jetson Orin NX

Mender leverages the UDA partition to store the persistent data between updates. But with the
Orin NX which uses an NVMe the current process doesn't work. Based on nvidia feedback [UDA is
reserved](https://forums.developer.nvidia.com/t/jetson-orin-nx-custom-partition-layout-fails-with-uda-at-the-end/316401/6) by nvidia.

To solve this issue we create a new [custom partition layout](recipes-bsp/tegra-binaries/tegra-storage-layout/flash_l4t_t234_nvme_rootfs_ab.xml) with a dedicated partition `id=17` for persistent data.

### Auto Grow UDA Partition

It is possible to auto-grow the UDA partition to fill remaining space with [this](https://gist.github.com/rishabnayak/a734d2720f43b8908e59564c14fa52e9) bbappend in a layer above `meta-mender-tegra`. It sets the UDA allocation attribute to `0x808`, removes partition id numbers, and moves the UDA partition to right before the `secondary_gpt` partition following [Nvidia documentation](https://docs.nvidia.com/jetson/archives/r35.6.0/DeveloperGuide/AR/BootArchitecture/PartitionConfiguration.html#partition-child-elements).

## Acknowlegements

Special thanks to [Matt Madison](https://github.com/madisongh) for his contributions to
support zeus and later branches and his work on meta-tegra which makes this mender
integration possible.

Thanks also to [Kurt Keifer](https://github.com/kekiefer/) for his contributions and
cleanup to support additional platforms and the tegra-demo-distro on the dunfell release.
