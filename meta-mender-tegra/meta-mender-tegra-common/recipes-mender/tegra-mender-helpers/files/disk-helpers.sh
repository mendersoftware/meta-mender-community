# Disk and ESP detection for the Mender Tegra integration.
#
# On a board with two Tegra layouts, an NVMe and a card, the partition names are
# ambiguous: both disks carry APP, APP_b and esp, both ESPs share a filesystem
# UUID, and the partition UUIDs are assigned at flash time. by-partlabel follows
# whichever disk udev settled last, /boot/efi whichever gpt-auto picked. Acting on
# the wrong one is silent, so everything here derives from the mounted root.
#
# POSIX shell, busybox ash compatible. PROC_MOUNTS, SYS_BLOCK, ESP_MOUNT and
# PARTLABEL_DIR are overridable for the offline tests, and read at each use.
#
# Sourced at runtime by the update module; spliced in at build time by the classic
# state scripts, which run from the artifact and cannot rely on the rootfs.

tegra_log() {
	echo "${TEGRA_LOG_PREFIX:-tegra-mender}: $*" 1>&2
}

# The disk / was mounted from. Non-zero when unknown, as from a recovery ramdisk.
tegra_booted_disk() {
	_tgh_root=$(readlink -f "$(awk '$2 == "/" { print $1; exit }' "${PROC_MOUNTS:-/proc/mounts}")" 2>/dev/null)
	_tgh_part=${_tgh_root##*/}
	[ -n "$_tgh_part" ] || return 1
	_tgh_disk=$(readlink -f "${SYS_BLOCK:-/sys/class/block}/${_tgh_part}/..") || return 1
	_tgh_disk=${_tgh_disk##*/}
	[ -n "$_tgh_disk" ] && [ "$_tgh_disk" != "block" ] || return 1
	echo "$_tgh_disk"
}

# <disk> <label> -> the device carrying that label on that disk. blkid is the
# fallback for an initramfs, which often has no lsblk, or none with PARTLABEL.
tegra_partlabel_on_disk() {
	_tgh_dev=$(lsblk -n -r -o NAME,PARTLABEL "/dev/$1" 2>/dev/null \
		| awk -v l="$2" '$2 == l { print "/dev/" $1; exit }')
	if [ -z "$_tgh_dev" ]; then
		for _tgh_cand in "${SYS_BLOCK:-/sys/class/block}/$1"/"$1"*; do
			[ -e "$_tgh_cand/partition" ] || continue
			_tgh_n=${_tgh_cand##*/}
			[ "$(blkid -o value -s PARTLABEL "/dev/$_tgh_n" 2>/dev/null)" = "$2" ] || continue
			_tgh_dev="/dev/$_tgh_n"
			break
		done
	fi
	[ -n "$_tgh_dev" ] || return 1
	echo "$_tgh_dev"
}

# <label> -> the device carrying it on the booted disk. The symlink is consulted
# only when the booted disk is unknown: if it is known and lacks the label, the
# symlink points at another disk and following it would act on the wrong medium.
tegra_partlabel_dev() {
	if _tgh_bdisk=$(tegra_booted_disk); then
		tegra_partlabel_on_disk "$_tgh_bdisk" "$1" && return 0
		tegra_log "no partition labelled $1 on the booted disk /dev/$_tgh_bdisk"
		return 1
	fi
	# readlink -f reports success for a path that does not exist, so check it.
	_tgh_link=$(readlink -f "${PARTLABEL_DIR:-/dev/disk/by-partlabel}/$1" 2>/dev/null) || return 1
	[ -n "$_tgh_link" ] && [ -e "$_tgh_link" ] || return 1
	echo "$_tgh_link"
}

# The ESP of the booted disk. No symlink fallback: a caller that cannot derive it
# is better off with whatever is mounted, correct on any single-ESP board.
tegra_esp_device() {
	_tgh_edisk=$(tegra_booted_disk) || return 1
	tegra_partlabel_on_disk "$_tgh_edisk" esp
}

# The device currently backing the ESP mount point, empty when nothing is there.
tegra_esp_mounted_device() {
	_tgh_have=$(awk -v m="${ESP_MOUNT:-/boot/efi}" '$2 == m { print $1; exit }' \
		"${PROC_MOUNTS:-/proc/mounts}")
	[ -n "$_tgh_have" ] || return 0
	readlink -f "$_tgh_have"
}

# Make the ESP mount point the booted disk's ESP, remounting if something else got
# there first. Keeps an existing mount when the derivation fails, and returns
# non-zero only when there is nothing usable: fatal to the caller staging a
# capsule, not to one cleaning an old one up.
tegra_ensure_esp_mounted() {
	_tgh_want=$(tegra_esp_device) || {
		_tgh_mounted=$(tegra_esp_mounted_device)
		if [ -n "$_tgh_mounted" ]; then
			tegra_log "cannot determine the booted disk's ESP; keeping ${ESP_MOUNT:-/boot/efi} as mounted ($_tgh_mounted)"
			return 0
		fi
		tegra_log "cannot determine the booted disk's ESP and nothing is mounted at ${ESP_MOUNT:-/boot/efi}"
		return 1
	}
	_tgh_mounted=$(tegra_esp_mounted_device)
	if [ "$_tgh_mounted" = "$_tgh_want" ]; then
		tegra_log "ESP $_tgh_want mounted at ${ESP_MOUNT:-/boot/efi}"
		return 0
	fi
	if [ -n "$_tgh_mounted" ]; then
		tegra_log "${ESP_MOUNT:-/boot/efi} is $_tgh_mounted but the booted disk's ESP is $_tgh_want; remounting"
		umount "${ESP_MOUNT:-/boot/efi}" || {
			tegra_log "cannot unmount ${ESP_MOUNT:-/boot/efi}"
			return 1
		}
	else
		tegra_log "nothing mounted at ${ESP_MOUNT:-/boot/efi}; mounting the booted disk's ESP $_tgh_want"
	fi
	mkdir -p "${ESP_MOUNT:-/boot/efi}"
	mount "$_tgh_want" "${ESP_MOUNT:-/boot/efi}" || {
		tegra_log "cannot mount $_tgh_want at ${ESP_MOUNT:-/boot/efi}"
		return 1
	}
	return 0
}
