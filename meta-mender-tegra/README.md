# meta-mender-tegra

Mender integration layer for NVIDIA Tegra hardware.

The supported and tested boards are:

- AGX Orin
- AGX Xavier
- Orin Nano
- Orin NX


## Dependencies

This layer depends on:

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

## [`kas`](https://github.com/siemens/kas) configurations

The following configuration files for building using the `kas` tool are provided:

- [jetson-agx-orin-devkit.yml](../kas/jetson-agx-orin-devkit.yml)
- [jetson-agx-xavier-devkit.yml](../kas/jetson-agx-xavier-devkit.yml)
- [jetson-orin-nano-devkit.yml](../kas/jetson-orin-nano-devkit.yml)
- [jetson-orin-16gb-nx-p3786.yml](../kas/jetson-orin-16gb-nx-p3786.yml)

### Jetson Orin NX

Mender leverages the UDA partition to store the persistent data between updates. But with the 
Orin NX which uses an NVMe the current process doesn't work. Based on nvidia feedback [UDA is 
reserved](https://forums.developer.nvidia.com/t/jetson-orin-nx-custom-partition-layout-fails-with-uda-at-the-end/316401/6) by nvidia.

To solve this issue we create a new [custom partition layout](recipes-bsp/tegra-binaries/tegra-storage-layout/flash_l4t_t234_nvme_rootfs_ab.xml) with a dedicated partition `id=17` for persistent data.

## Acknowlegements

Special thanks to [Matt Madison](https://github.com/madisongh) for his contributions to
support zeus and later branches and his work on meta-tegra which makes this mender
integration possible.

Thanks also to [Kurt Keifer](https://github.com/kekiefer/) for his contributions and
cleanup to support additional platforms and the tegra-demo-distro on the dunfell release.
