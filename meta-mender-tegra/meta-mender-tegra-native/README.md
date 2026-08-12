# meta-mender-tegra-native

The Tegra-native update scheme: a `tegra-rootfs-image` update module that talks to
the BSP directly, in place of Mender's stock `rootfs-image` module and the adapters
that one needs on Tegra.

It uses `nvbootctrl -t rootfs` for slot queries and verification, `mender-flash`
for the write and `oe4t-set-uefi-OSIndications` to arm the capsule. Which device a
partition label means, and which ESP the capsule belongs on, come from
`meta-mender-tegra-common`'s `disk-helpers.sh`, sourced at runtime and shared with
the classic scheme. `libubootenv-fake`, the Mender
state scripts, `mender-update-verifier` and the `RootfsPartA`/`RootfsPartB` entries
in `mender.conf` are neither needed nor installed.

One of two mutually exclusive scheme layers. Select it by adding it to `BBLAYERS`
alongside `meta-mender-tegra-common` and a Jetpack layer, plus:

```
INHERIT += "tegra-mender-native"
```

Inheriting `tegra-mender-common` directly, or having both scheme layers in
`BBLAYERS`, is refused at parse time. See ../README.md for the layer set as a whole.

## What the build produces

One `.mender` file under the usual name, in a deploy directory that looks like the
classic scheme's. Inside it the payload type is `tegra-rootfs-image` and there are
two payload files, the rootfs `.ext4` and `tegra-bl.cap`. Carrying the capsule in
the artifact is what removes the classic `switch-rootfs` mount of the freshly
written slot.

`rootfs-image.version` is still provided and `rootfs-image.*` still cleared, so
inventory and deployment logic look unchanged to the server. The file name does not
say which scheme built it; `mender-artifact read` does, via the payload type.

The stock `rootfs-image` module is deliberately left in the image. Without
`libubootenv-fake` it fails immediately on the missing `fw_printenv`, which is the
loud failure wanted if an ordinary `rootfs-image` artifact reaches a device on this
scheme.

## Slot verification

`RootfsRetryCountMax` is 1 on this platform, so a slot that is never verified does
not survive a boot. Something has to run `nvbootctrl verify` on an ordinary boot,
and stand down while an update awaits its verdict, or the new slot is marked good
before Mender commits and the A/B rollback is gone.

The classic scheme keys that window off `upgrade_available` in the u-boot
environment. There is no u-boot environment here, so meta-tegra's
`nv_update_verifier` is left disabled and `tegra-rootfs-verify.service` takes over.
The update module writes `/var/lib/mender/tegra-update-pending` naming the slot the
update aims at, and the verifier stands down only while that slot is the one
running, so a marker left by an interrupted deployment cannot condemn an unrelated
slot.

`nv_update_verifier` is disabled, not removed. It arrives through
`MACHINE_EXTRA_RDEPENDS` in meta-tegra's `tegra-common.inc`, so it is in the image
either way, and masking it instead breaks the rootfs build in
`tegra-redundant-boot`'s postinstall.

## Moving a device between schemes

There is no migration path. Update modules are dispatched by the running rootfs, so
neither scheme can install the other's artifact. Both failures are immediate and
leave the slots untouched: a `rootfs-image` artifact on a native device dies on the
missing `fw_printenv`, a `tegra-rootfs-image` artifact on a classic device dies
because there is no such module under `/usr/share/mender/modules/v3`. Changing
scheme means reflashing, or writing the other scheme's rootfs into the inactive slot
out of band and letting the capsule switch to it.

Before the split a classic image could also carry `tegra-rootfs-update-module` and
migrate over two deployments. The module recipe now lives in this layer and a build
cannot have both scheme layers, so that route is closed.

Changes to the module itself take effect one deployment later than you might
expect, since the states up to the reboot run from the old rootfs and everything
after it from the new one. The pending marker crosses that boundary, so a deployment
that upgrades the module is written by one revision and read by the next. A marker
the new verifier cannot attribute to the running slot is treated as stale and the
slot is verified, so that one deployment runs without the deferral. Mender's own
rollback is unaffected; what is skipped for that boot is the firmware's automatic
fallback.

## Known limitations

- **Every rootfs update reflashes the bootloader.** The capsule is bundled in every
  artifact and armed unconditionally, so each deployment writes the inactive boot
  chain even when the firmware is byte for byte what is already there, roughly
  11 MB of QSPI per update on an Orin NX. The classic scheme arms the capsule the
  same way, so this is inherited behaviour rather than a regression. The place to
  fix it is the module's `ArtifactInstall`, comparing the capsule against the
  installed firmware version and skipping the arming, except that arming the capsule
  is also what performs the slot switch, so the two cannot simply be separated.

- **Rollback does not roll back firmware.** The capsule has already updated the
  other boot chain by the time a rollback happens, so the standby chain carries the
  new firmware next to a rootfs that failed its commit, and that slot is still
  flagged bootable: the module flags the target unbootable only while it is being
  written. If the active chain later fails to boot, the firmware falls back to a
  rootfs and firmware pair that was never validated together, running an artifact
  the server never recorded as installed. The classic scheme behaves the same way.

- **The unbootable-rootfs fallback gap** applies as it does to the classic scheme.
  A/B recovers a rootfs that boots but never commits, not one that fails to boot,
  and a rootfs that panics is never condemned at all.
