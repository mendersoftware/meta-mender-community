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

## Tegra-native update scheme (opt in)

By default this layer drives Mender's stock `rootfs-image` update module. That module
is written for u-boot and GRUB systems, so on Tegra it only works through a stack of
adapters: `libubootenv-fake` provides `fw_printenv`/`fw_setenv` (where
`fw_setenv mender_boot_part` is a no-op), three Mender state scripts perform the
actual slot switch outside the module, and `mender-update-verifier` exists to undo
state the shims cannot express.

Setting

```
TEGRA_MENDER_NATIVE_UPDATE = "1"
```

selects an alternative that talks to the BSP directly. It uses `nvbootctrl -t rootfs`
for slot queries and verification, `/dev/disk/by-partlabel/APP{,_b}` for the
partitions, `mender-flash` for the write, and `oe4t-set-uefi-OSIndications` to arm the
capsule. None of the shims, state scripts or `mender.conf` partition entries are
needed, and none are installed.

### What changes

The image builds a `.tegra-mender-native` artifact instead of a `.mender` one. It
carries the payload type `tegra-rootfs-image` and two payload files, the rootfs
`.ext4` and `tegra-bl.cap`. Shipping the capsule inside the artifact is what removes
the worst of the glue, since the legacy `switch-rootfs` state script has to mount the
freshly written slot just to fetch it.

The artifact still provides `rootfs-image.version` and clears `rootfs-image.*`, so
inventory and deployment logic look unchanged to the server.

Note that the payload type is what selects the module, so the two schemes cannot be
mixed within one artifact. The stock `rootfs-image` module is deliberately left in the
image: without `libubootenv-fake` it fails immediately on the missing `fw_printenv`,
which is the loud failure you want if an ordinary `rootfs-image` artifact is deployed
to a device running this scheme.

### Slot verification

This platform sets `RootfsRetryCountMax` to 1, so a slot that is never verified does
not survive a boot. Something has to run `nvbootctrl verify` on an ordinary boot, and
it must stand down while an update is awaiting its verdict, or the new slot is marked
good before Mender commits and the A/B rollback is gone.

The legacy scheme keys that window off `upgrade_available` in the u-boot environment.
The native scheme has no u-boot environment, so meta-tegra's `nv_update_verifier` is
disabled and replaced by `tegra-rootfs-verify.service`. The update module writes
`/var/lib/mender/tegra-update-pending` naming the slot the update is aiming at, and
the verifier stands down only while that slot is the one running. A marker left behind
by an interrupted deployment therefore cannot stop verification of some unrelated slot
forever, which would condemn it.

### Migrating an existing device

Update modules are dispatched by the running rootfs, so a device on the legacy scheme
has no `tegra-rootfs-image` module yet and cannot install a native artifact. Migration
takes two deployments: first a legacy `.mender` artifact built from an image that
already contains `tegra-rootfs-update-module`, then the native artifact. The same
applies to changes to the module itself, which take effect one deployment later than
you might expect.

Note that this splits a single deployment across two revisions of the module: the
states up to the reboot run from the old rootfs, and everything after it from the new
one. The pending marker crosses that boundary, so a deployment that upgrades the
module is written by one revision and read by the next. A marker the new verifier
cannot attribute to the running slot is treated as stale and the slot is verified, so
such a deployment runs without the deferral. Mender's own rollback is unaffected;
what is skipped for that one boot is the firmware's automatic fallback.

### Known limitations

**Every rootfs update reflashes the bootloader.** The capsule is bundled in every
artifact and armed unconditionally, so each deployment writes the inactive boot chain
even when the firmware is byte for byte what is already there. On an Orin NX that is
roughly 11 MB of QSPI written per update. This matches the legacy scheme, which arms
the capsule the same way, so it is inherited behaviour rather than a regression. If
that write is unwanted, the place to fix it is the module's `ArtifactInstall`, which
could compare the capsule against the installed firmware version and skip arming when
they agree. Nothing in the current design depends on the capsule being applied when
the firmware has not changed, other than the slot switch itself, which is precisely
what the capsule performs, so the two cannot simply be separated.

**Rollback does not roll back firmware.** The capsule has already updated the other
boot chain by the time a rollback happens, so a rolled-back device carries the new
firmware on its standby chain. This also matches the legacy scheme.

That has a consequence worth stating plainly. After a rolled-back update the standby
chain holds the new firmware alongside a rootfs that failed its commit, and that slot
is still flagged bootable. The module flags the target unbootable only while it is
being written, and clears the flag once the write completes, so a slot that was written
successfully but never committed remains a valid fallback target. If the active chain
later fails to boot, the firmware falls back to a rootfs and firmware pair that was
never validated together. Mender does not know about that slot either, so the device
would come up reporting an artifact the server never recorded as installed.

**The unbootable-rootfs fallback gap** applies here as it does to the legacy scheme.
A/B recovers a rootfs that boots but never commits. It does not recover one that fails
to boot, and a rootfs that panics is never condemned at all.

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
