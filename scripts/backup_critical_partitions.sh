#!/usr/bin/env bash
# ==============================================================================
# Moto G55 5G (XT2435-1 / taipei) Critical Partitions Backup Script
# Creates a 1:1 bit-by-bit raw dump of all security, radio, and calibration blocks
# Author: JoshRob
# ==============================================================================

set -e

BACKUP_DIR="./backup_critical_partitions_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo "========================================================"
echo "Moto G55 5G - Critical Partitions Backup (Insurance Policy)"
echo "Target directory: $BACKUP_DIR"
echo "========================================================"

if ! command -v adb &> /dev/null; then
    echo "Error: 'adb' not found in PATH. Install Android platform-tools."
    exit 1
fi

echo "Verifying ADB root access on device..."
adb wait-for-device
if [ "$(adb shell su -c id -u 2>/dev/null)" != "0" ]; then
    echo "Error: Root access not granted. Please grant superuser permissions in Magisk app."
    exit 1
fi

PARTITIONS=(
    "nvram"
    "nvdata"
    "nvcfg"
    "persist"
    "prodpersist"
    "protect1"
    "protect2"
    "seccfg"
    "boot_a"
    "vendor_boot_a"
    "frp"
)

echo "Dumping critical blocks from /dev/block/by-name/..."

for part in "${PARTITIONS[@]}"; do
    echo "[+] Dumping partition: $part"
    adb shell "su -c 'dd if=/dev/block/by-name/$part of=/sdcard/$part.img bs=4096 2>/dev/null'"
    adb pull "/sdcard/$part.img" "$BACKUP_DIR/$part.img"
    adb shell "rm -f /sdcard/$part.img"
done

echo "========================================================"
echo "Backup complete! All 11 critical partition dumps saved to:"
echo "  $BACKUP_DIR"
echo "Keep these files safe! They contain your unique radio calibration & IMEI data."
echo "========================================================"
