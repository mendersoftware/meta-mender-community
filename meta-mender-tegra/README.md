# meta-mender-tegra

Mender integration layer for NVIDIA Tegra hardware.

The boards with a published build configuration, and the update schemes each one
has a configuration for:

| Board | `MACHINE` | Boot medium | classic | native |
|---|---|---|---|---|
| Orin Nano devkit | `jetson-orin-nano-devkit` | microSD | yes | yes |
| Orin Nano devkit | `jetson-orin-nano-devkit-nvme` | NVMe | yes | yes |
| Orin NX 8GB, p3768 | `p3768-0000-p3767-0001` | NVMe | yes | yes |
| Orin NX 16GB, p3768 | `p3768-0000-p3767-0000` | NVMe | yes | yes |
| AGX Thor devkit | `jetson-agx-thor-devkit` | NVMe | yes | no |

The layer itself is not limited to those machines, and anything meta-tegra
supports on this branch can be configured by hand; the table is what has a
configuration in `mender-community-images` and has been built. AGX Orin has no
configuration here, so it is untested on this branch.

Hardware verification is per board, and lags the configurations: the two Orin
Nano configurations and the Orin NX 8GB have been flashed and deployed to on both
schemes, the Orin NX 16GB and Thor are build-verified only.

meta-tegra's `wrynose` branch is L4T 39.2.0 (Jetpack 7) and carries machines for
tegra234 and tegra264 only. The Jetpack 4 and 5 era platforms (Nano, TX1, TX2,
Xavier) are not available here; use the `scarthgap` branch for those.

## Dependencies

These layers depend on:

```
URI: https://github.com/OE4T/meta-tegra.git
layers: meta-tegra
branch: wrynose
revision: HEAD
```

```
URI: https://github.com/mendersoftware/meta-mender.git
layers: meta-mender-core
branch: master
revision: HEAD
```

## Layer structure

A build takes three of these: the common layer, one update scheme, one Jetpack
release.

- `meta-mender-tegra-common`
  What both schemes need, across Jetpack releases: partition numbers, the storage
  device, the A/B slot size calculation, the flash layouts, the persistent
  machine-id, and the disk and ESP detection both schemes resolve their
  partitions with.

- `meta-mender-tegra-classic`
  The classic update scheme: Mender's stock `rootfs-image` update module, driven
  through this layer's state scripts and the `fw_printenv`/`fw_setenv` shims.

- `meta-mender-tegra-native`
  The Tegra-native update scheme: a `tegra-rootfs-image` update module driving
  `nvbootctrl`, the BSP partlabels and the UEFI capsule directly, with none of
  those adapters.

- `meta-mender-tegra-jetpack7`
  Jetpack 7 specific parts, matching the `wrynose` branch of `meta-tegra`.

### Selecting an update scheme

One scheme layer in `BBLAYERS`, its class in `INHERIT`:

```
BBLAYERS += "\
    ${TOPDIR}/../meta-mender-community/meta-mender-tegra/meta-mender-tegra-common \
    ${TOPDIR}/../meta-mender-community/meta-mender-tegra/meta-mender-tegra-classic \
    ${TOPDIR}/../meta-mender-community/meta-mender-tegra/meta-mender-tegra-jetpack7 \
"
INHERIT += "tegra-mender-classic"
```

For the native scheme, substitute `meta-mender-tegra-native` and
`INHERIT += "tegra-mender-native"`.

Two things are refused at parse time. Inheriting `tegra-mender-common` directly:
the scheme class pulls it in, and on its own it would configure no scheme at all.
And two scheme layers at once: the bbappends of both would apply whichever class
was inherited, yielding an image whose slot verification belongs to the other
scheme.

The schemes are mutually exclusive on the device as well. Neither can install the
other's artifact, so there is no migration path; see
[meta-mender-tegra-native/README.md](meta-mender-tegra-native/README.md).

## Quick start

See the mender hub pages and the documentation for the `tegrademo-mender`
distro on the [tegra-demo-distro](https://github.com/OE4T/tegra-demo-distro) repository
for the most up to date instructions on starting out with mender and tegra.

## [`kas`](https://github.com/siemens/kas) configurations

Build configs (kas) live in the companion
[mender-community-images](https://github.com/theyoctojester/mender-community-images)
repo, under `yocto/<release>/{tagged,floating}/tegra/jetpack<N>/<scheme>/`, where
the last directory is the update scheme the configuration selects:

```
git clone https://github.com/theyoctojester/mender-community-images
kas build mender-community-images/yocto/wrynose/tagged/tegra/jetpack7/classic/jetson-agx-thor-devkit.yml
```

Substitute `native/` for a configuration on the Tegra-native scheme. Not every
board carries one.

Jetpack 5 and 6 machines are covered by the `scarthgap` configurations in the
same repository.

### Jetson Orin NX

Mender leverages the UDA partition to store the persistent data between updates. But with the
Orin NX which uses an NVMe the current process doesn't work. Based on nvidia feedback [UDA is
reserved](https://forums.developer.nvidia.com/t/jetson-orin-nx-custom-partition-layout-fails-with-uda-at-the-end/316401/6) by nvidia.

To solve this issue we create a new [custom partition layout](meta-mender-tegra-common/recipes-bsp/tegra-binaries/tegra-storage-layout/flash_l4t_t234_nvme_rootfs_ab.xml) with a dedicated partition, `permanet_user_storage` at `id=17`, for persistent data. `UDA` is left without a filename in that layout.

### Auto Grow UDA Partition

It is possible to auto-grow the UDA partition to fill remaining space with [this](https://gist.github.com/rishabnayak/a734d2720f43b8908e59564c14fa52e9) bbappend in a layer above `meta-mender-tegra`. It sets the UDA allocation attribute to `0x808`, removes partition id numbers, and moves the UDA partition to right before the `secondary_gpt` partition following [Nvidia documentation](https://docs.nvidia.com/jetson/archives/r35.6.0/DeveloperGuide/AR/BootArchitecture/PartitionConfiguration.html#partition-child-elements).

## The classic update scheme

Mender's stock `rootfs-image` update module is written for u-boot and GRUB
systems. `meta-mender-tegra-classic` supplies the adapters it needs on Tegra:

| adapter | provides |
|---|---|
| `libubootenv-fake` | the `fw_printenv`/`fw_setenv` the module calls. `fw_printenv mender_boot_part` is answered from `nvbootctrl get-current-slot`, `fw_setenv upgrade_available` is kept in a flag file |
| `ArtifactInstall_Leave_50_switch-rootfs` | the slot switch. Mounts the freshly written slot read only to copy the UEFI capsule out of it |
| `ArtifactCommit_Leave_50_verify-slot` | `nvbootctrl verify` |
| `ArtifactRollback_Leave_50_abort-blupdate` | removal of the staged capsule on rollback |
| `mender-update-verifier` | reading `RootfsStatusSlot{A,B}` and clearing `upgrade_available` |
| `nv_update_verifier` | the wrapper meta-tegra's verifier unit runs, keying the verification window off `upgrade_available` |
| `RootfsPartA`/`RootfsPartB` in `mender.conf` | the rootfs partition names, which the BSP layout calls `APP` and `APP_b` |

This is the scheme every published Tegra build uses and the one verified on
hardware.

## The native update scheme

`meta-mender-tegra-native` replaces that stack with a single update module,
`tegra-rootfs-image`, calling the BSP directly: `nvbootctrl -t rootfs` for slot
state and verification, `/dev/disk/by-partlabel/APP{,_b}` for the partitions,
`mender-flash` for the write, the UEFI capsule for the switch. The capsule ships
inside the artifact, so nothing has to mount the freshly written slot.

The artifact keeps the canonical `.mender` name and still provides
`rootfs-image.version`, so the upload and the server side are unchanged. Only the
payload type inside differs; `mender-artifact read` tells the two apart.

Verification window, why `nv_update_verifier` is disabled rather than removed, and
the scheme's limitations:
[meta-mender-tegra-native/README.md](meta-mender-tegra-native/README.md).

## Shell portability

These layers install shell scripts onto the target: the Mender state scripts, the
`fw_printenv`/`fw_setenv` shims, the update verifiers and the machine-id helper.
They run on images such as `core-image-minimal`, where `/bin/sh` is busybox ash
and bash is not installed at all, so they must not use bash-only syntax.

busybox ash accepts more than POSIX does. `local`, `source`, `[[ ]]`, the
`function` keyword, `${var:offset:length}` and `${#var}` all work. What does not:

- herestrings (`<<<`)
- C-style `for (( ; ; ))` loops
- `var+=value` appending. This one is the dangerous case: ash parses it as a
  command name rather than an assignment, so it does not fail the script, it
  just leaves the variable empty.
- a `#!/bin/bash` interpreter line

Check a script before committing it:

```
busybox ash -n path/to/script
```

Note that this only catches parse errors. `var+=value` parses fine and fails at
runtime, so grep for it as well.

## Acknowlegements

Special thanks to [Matt Madison](https://github.com/madisongh) for his contributions to
support zeus and later branches and his work on meta-tegra which makes this mender
integration possible.

Thanks also to [Kurt Keifer](https://github.com/kekiefer/) for his contributions and
cleanup to support additional platforms and the tegra-demo-distro on the dunfell release.
