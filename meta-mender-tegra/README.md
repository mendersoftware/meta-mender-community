# meta-mender-tegra

Mender integration layer for NVIDIA Tegra hardware.

The supported boards are:

- Thor
- AGX Orin
- Orin Nano
- Orin NX

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

- `meta-mender-tegra-common`
  Holds the parts of the Mender integration for Tegra that are common across
  Jetpack releases

- `meta-mender-tegra-jetpack7`
  Holds Jetpack release 7 specific parts of the Mender integration for Tegra.
  This correlates with the `wrynose` branch of `meta-tegra`.

## Quick start

See the mender hub pages and the documentation for the `tegrademo-mender`
distro on the [tegra-demo-distro](https://github.com/OE4T/tegra-demo-distro) repository
for the most up to date instructions on starting out with mender and tegra.

## [`kas`](https://github.com/siemens/kas) configurations

Build configs (kas) live in the companion
[mender-community-images](https://github.com/theyoctojester/mender-community-images)
repo, under `yocto/<release>/{tagged,floating}/tegra/jetpack<N>/`:

```
git clone https://github.com/theyoctojester/mender-community-images
kas build mender-community-images/yocto/wrynose/tagged/tegra/jetpack7/jetson-agx-thor-devkit.yml
```

Jetpack 5 and 6 machines are covered by the `scarthgap` configurations in the
same repository.

### Jetson Orin NX

Mender leverages the UDA partition to store the persistent data between updates. But with the
Orin NX which uses an NVMe the current process doesn't work. Based on nvidia feedback [UDA is
reserved](https://forums.developer.nvidia.com/t/jetson-orin-nx-custom-partition-layout-fails-with-uda-at-the-end/316401/6) by nvidia.

To solve this issue we create a new [custom partition layout](recipes-bsp/tegra-binaries/tegra-storage-layout/flash_l4t_t234_nvme_rootfs_ab.xml) with a dedicated partition, `permanet_user_storage` at `id=17`, for persistent data. `UDA` is left without a filename in that layout.

### Auto Grow UDA Partition

It is possible to auto-grow the UDA partition to fill remaining space with [this](https://gist.github.com/rishabnayak/a734d2720f43b8908e59564c14fa52e9) bbappend in a layer above `meta-mender-tegra`. It sets the UDA allocation attribute to `0x808`, removes partition id numbers, and moves the UDA partition to right before the `secondary_gpt` partition following [Nvidia documentation](https://docs.nvidia.com/jetson/archives/r35.6.0/DeveloperGuide/AR/BootArchitecture/PartitionConfiguration.html#partition-child-elements).

## Shell portability

This layer installs shell scripts onto the target: the Mender state scripts, the
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
