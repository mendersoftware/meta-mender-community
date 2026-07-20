# meta-mender-xilinx

Mender integration for Xilinx / AMD Zynq based boards.

The supported and tested boards are:

 - [Digilent Arty Z7-20](https://digilent.com/reference/programmable-logic/arty-z7/start) (Zynq-7000 xc7z020)

Visit the individual board links above for more information on status of the
integration and more detailed instructions on how to build and use images
together with Mender for the mentioned boards.

## Layer structure

Board bring-up (machine, devicetree, U-Boot control DTS, platform-init) lives
in the nested BSP sub-layer [`meta-arty-z7`](meta-arty-z7/README.md), kept
separate from the Mender integration so a plain bring-up build stays free of
Mender patches. Both layers are added together by the kas configuration.

This layer itself carries:

- `recipes-bsp/u-boot` — Mender integration for the `u-boot-xlnx` fork
  (meta-mender only appends to the plain `u-boot` recipe): `PROVIDES "u-boot"`,
  a rebased boot-code patch, and a Zynq `env_get_location` MMC fix required for
  Mender's redundant raw-MMC environment on SD boot.
- `recipes-mender/fpga-bitstream-module` — a Mender Update Module that deploys
  Zynq PL bitstreams to `/data/fpga` and programs them via the kernel FPGA
  manager, with a boot-time reload service. It survives rootfs A/B updates and
  needs no reboot.

## Dependencies

This layer depends on:

```
URI: https://github.com/Xilinx/meta-xilinx
layers: meta-xilinx-core
branch: wrynose-next
revision: HEAD
```

```
URI: https://git.yoctoproject.org/meta-arm
layers: meta-arm, meta-arm-toolchain
branch: wrynose
revision: HEAD
```

```
URI: https://github.com/mendersoftware/meta-mender.git
layers: meta-mender-core
branch: master-next
revision: HEAD
```

meta-xilinx has no released `wrynose` branch yet, so `wrynose-next` (its
staging branch) is used with `XILINX_RELEASE_VERSION = "v2026.1"` (linux-xlnx
6.18, u-boot-xlnx 2026.01). wrynose needs the 2026.01 U-Boot: meta-mender's
wrynose U-Boot integration expects the 2026.01+ Kconfig symbol names that the
2025.01 U-Boot does not provide. meta-mender tracks `master-next` for wrynose,
matching the mender-community-images wrynose build configs.

It also depends on the nested `meta-arty-z7` BSP sub-layer in this repository.

## Quick start

The wrynose build configuration lives in
[mender-community-images](https://github.com/theyoctojester/mender-community-images);
it wires up this layer, its nested BSP sub-layer and meta-xilinx. With
[kas](https://kas.readthedocs.io/) installed:

```
git clone https://github.com/theyoctojester/mender-community-images
kas build mender-community-images/yocto/wrynose/floating/arty-z7-20.yml
```

The Vivado-free bitstream build flow used to produce the demo `fpga-bitstream`
artifacts is documented in the Arty Z7-20 Mender Hub tutorials.
