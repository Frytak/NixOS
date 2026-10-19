#!/usr/bin/env bash
#
# Enlarge the BBM swap partition (/dev/nvme1n1p3) so it is at least as large as
# RAM, guaranteeing hibernation fits. RUN FROM A NIXOS LIVE USB, not from the
# installed system (ext4 cannot be shrunk while mounted).
#
# Current geometry (512-byte sectors), read from /sys/class/block:
#   nvme1n1p1  start=2048        size=2095104      ESP / boot   (untouched)
#   nvme1n1p2  start=2097152     size=7749439488   root (ext4)  (shrunk)
#   nvme1n1p3  start=7751536640  size=62498816     swap         (enlarged)
#   disk       ...               end =7814035455   (swap already ends at tail)
#
# The root ext4 filesystem is shrunk by ~1.3 GiB to free room; the swap
# partition then grows by the same amount, keeping its end at the disk tail.
# Partition types/UUIDs/names are preserved, only size/start move.
#
# The NixOS config references these partitions by label (nixos/boot/swap), so
# the changed partition UUIDs and offsets do not matter.
#
# Optional: SWAP_HEADROOM_MIB=N adds N MiB on top of RAM (default 0 = exact).

set -euo pipefail

DISK=/dev/nvme1n1
P2_PART=${DISK}p2
P3_PART=${DISK}p3

P2_START=2097152            # first sector of the root partition
SWAP_END=7814035455         # last sector of the (tail) swap partition
ALIGN=2048                  # 1 MiB alignment, in 512-byte sectors
SWAP_HEADROOM_MIB=${SWAP_HEADROOM_MIB:-0}

log() { printf '\n==> %s\n' "$*"; }
die() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

[[ $EUID -eq 0 ]] || die "must run as root (from a live USB)"
[[ -b $DISK ]] || die "$DISK not found"
[[ -b ${DISK}p2 && -b ${DISK}p3 ]] || die "expected partitions not found on $DISK"
for t in sfdisk resize2fs e2fsck mkswap blockdev; do
  command -v "$t" >/dev/null || die "required tool '$t' not found"
done

log "Current layout"
lsblk -o NAME,SIZE,FSTYPE,LABEL,MOUNTPOINT "$DISK"
sfdisk --dump "$DISK"

# --- safety checks ---------------------------------------------------------
for part in "$P2_PART" "$P3_PART"; do
  grep -qs "^$part " /proc/mounts && die "$part is mounted; run from a live USB"
done
if grep -qs "^$P3_PART " /proc/swaps; then
  log "Disabling swap on $P3_PART"
  swapoff "$P3_PART"
fi

# --- compute new geometry --------------------------------------------------
mem_kib=$(awk '/^MemTotal:/{print $2}' /proc/meminfo)
mem_bytes=$(( mem_kib * 1024 ))
swap_sectors=$(( (mem_bytes + SWAP_HEADROOM_MIB * 1048576 + 511) / 512 ))
swap_sectors=$(( (swap_sectors + ALIGN - 1) / ALIGN * ALIGN ))   # round up to 1 MiB

p2_new_size=$(( SWAP_END + 1 - swap_sectors - P2_START ))
p3_new_start=$(( SWAP_END + 1 - swap_sectors ))
p3_new_size=$swap_sectors

(( p2_new_size > 0 )) || die "computed root partition size is not positive"
(( p3_new_size >= (mem_bytes + 511) / 512 )) || die "swap would be smaller than RAM"

log "Planned geometry"
printf '  RAM               : %s bytes (%s sectors)\n' "$mem_bytes" "$(( (mem_bytes + 511) / 512 ))"
printf '  p2 root new size  : %s sectors\n' "$p2_new_size"
printf '  p3 swap new start : %s sectors\n' "$p3_new_start"
printf '  p3 swap new size  : %s sectors (%s bytes)\n' "$p3_new_size" "$(( p3_new_size * 512 ))"

# --- backup ----------------------------------------------------------------
backup=/root/bbm-gpt-backup-$(date +%Y%m%d-%H%M%S).txt
log "Backing up partition table to $backup"
sfdisk --dump "$DISK" > "$backup"

log "This will SHRINK ${P2_PART} (data preserved) and REFORMAT ${P3_PART}."
log "ALL DATA ON ${P3_PART} (swap) IS DESTROYED."
read -r -p "Type 'yes' to continue: " reply
[[ $reply == yes ]] || die "aborted by user"

# --- 1. shrink the ext4 filesystem -----------------------------------------
log "Checking and shrinking ext4 on ${P2_PART} to ${p2_new_size}s"
e2fsck -fy "$P2_PART"
resize2fs "$P2_PART" "${p2_new_size}s"

# --- 2. rewrite the partition table ----------------------------------------
log "Rewriting partition table (preserving types/UUIDs/names)"
sfdisk --dump "$DISK" \
  | awk -v p2="$P2_PART" -v p3="$P3_PART" \
        -v p2size="$p2_new_size" -v p3start="$p3_new_start" -v p3size="$p3_new_size" '
      $1 == p2 { sub(/size=[0-9]+/, "size=" p2size) }
      $1 == p3 { sub(/start=[0-9]+/, "start=" p3start);
                 sub(/size=[0-9]+/,  "size=" p3size) }
      { print }
    ' \
  | sfdisk --force "$DISK"

# --- 3. reload, then recreate swap -----------------------------------------
log "Reloading partition table and creating swap"
blockdev --rereadpt "$DISK" 2>/dev/null || partprobe "$DISK" 2>/dev/null || true
udevadm settle 2>/dev/null || true
mkswap -L swap "$P3_PART"

log "Done. Final layout:"
lsblk -o NAME,SIZE,FSTYPE,LABEL,MOUNTPOINT "$DISK"
blkid "$P3_PART" || true
log "Next: reboot into NixOS, run 'nixos-rebuild boot', reboot, then verify with"
log "'swapon --show' and 'grep SwapTotal /proc/meminfo'."
