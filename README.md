# Moto G55 5G (XT2435-1 / taipei) Technical Engineering Guide

[![CI](https://github.com/JoshRob297/moto-g55-taipei-guide/actions/workflows/ci.yml/badge.svg)](https://github.com/JoshRob297/moto-g55-taipei-guide/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Comprehensive engineering documentation, carrier bootloader unlocking bypasses, Magisk root guides, critical partition backup tools, and clean flashing guides for the **Motorola Moto G55 5G** (codename `taipei` / `taipei_g_sysn`, MediaTek Dimensity 7025 / `MT6855`).

---

## Table of Contents

1. [Overview & Engineering Breakthroughs](#overview--engineering-breakthroughs)
2. [Hardware & Platform Specifications](#hardware--platform-specifications)
3. [Step-by-Step Technical Pipeline](#step-by-step-technical-pipeline)
4. [Critical Partitions Backup (Safety First & Insurance Policy)](#critical-partitions-backup-safety-first--insurance-policy)
5. [Documentation Modules Directory](#documentation-modules-directory)
6. [Magisk Debloater Module (Requires Root)](#magisk-debloater-module-requires-root)
7. [Automated Scripts](#automated-scripts)
8. [Disclaimer & License](#disclaimer--license)

---

## Overview & Engineering Breakthroughs

Due to the absence of dedicated custom recoveries (TWRP) and strict MediaTek security enforcement (DAA/SBC), the Moto G55 5G has remained undocumented across major modding forums. Furthermore, carrier-branded devices are blocked from bootloader unlocking on Motorola's portal with *"Device not eligible for bootloader unlock"*.

This repository compiles the complete, end-to-end verified technical pipeline:
* **Firmware Tool Integration:** Direct factory stock firmware acquisition from Motorola AWS S3 buckets using [`moto-firmware-downloader`](https://github.com/JoshRob297/moto-firmware-downloader) (`npx moto-firmware-downloader`).
* **Carrier Unlock Bypass:** Exploitation of open MediaTek UTAG configuration handlers (`fastboot oem config carrier retla`) to bypass carrier eligibility rejections.
* **Clean Stock Fastboot Flashing:** Complete restoration across all 27 dynamic `super.img` sparsechunks.
* **Non-Recovery Kernel Patching:** Root injection using Magisk v28+ without TWRP.
* **Critical Hardware Backups:** 1:1 bit-by-bit raw dumping (`dd`) of all 11 unique baseband, radio calibration, and security blocks.
* **Post-Root Carrier Debloating:** Systemless neutralization of carrier bloatware and background telemetry services (`com.motorola.paks`, `PayJoyAccess`).
* **Play Integrity Fix:** Full restoration of Google Play certification for banking and DRM apps.

---

## Hardware & Platform Specifications

| Property | Value |
|---|---|
| **Device Model** | Motorola Moto G55 5G (`XT2435-1` / `XT2435-x`) |
| **Codename** | `taipei` / `taipei_g_sysn` |
| **SoC / Chipset** | MediaTek Dimensity 7025 (`MT6855`, 6nm Octa-Core) |
| **RAM / Flash** | 8 GB LPDDR4X / 256 GB Samsung UFS (`KM8F9001JM-B813`) |
| **Android Version** | Android 14 / Android 15 (Hello UI) |
| **Partition Architecture** | A/B Dynamic Partitions (`super.img` with 27 sparsechunks) |
| **Security Hardware** | Secure Boot (SBC) + Device Attestation (DAA) |

---

## Step-by-Step Technical Pipeline

The operations must be performed in the following logical sequence:

1. **Firmware Acquisition:** Download official factory ROM via `npx moto-firmware-downloader`.
2. **Bootloader Unlock:** Bypass carrier restriction with `fastboot oem config carrier retla` and unlock bootloader.
3. **Clean Stock Flashing:** Flash full firmware across all partitions and 27 sparsechunks (`scripts/flash_all.sh`).
4. **Kernel Rooting:** Patch clean `boot.img` with Magisk v28+ and flash to `boot_a` / `boot_b`.
5. **CRITICAL STEP — Hardware Partition Backup:** Immediately after obtaining Root, run `scripts/backup_critical_partitions.sh` to safeguard your unique IMEI, radio calibration, and security blocks before modifying system packages!
6. **Carrier Debloating (Post-Root):** Install `moto_g55_carrier_debloater_v2.0.zip` in Magisk to systemlessly disable carrier background packages.
7. **Play Integrity Restoration:** Enable Zygisk, configure DenyList, and install Play Integrity Fix (PIF).

---

## Critical Partitions Backup (Safety First & Insurance Policy)

> **WARNING:** Baseband, IMEI, and calibration partitions (`nvram`, `nvdata`, `persist`, etc.) are **device-unique**. If damaged, they cannot be recovered from generic stock ROMs. Always back them up immediately after rooting:

```bash
# Automated 1:1 bit-by-bit backup via ADB Root
./scripts/backup_critical_partitions.sh
```

See [`docs/06-CRITICAL-BACKUP-AND-DISASTER-RECOVERY.md`](docs/06-CRITICAL-BACKUP-AND-DISASTER-RECOVERY.md) for detailed partition mappings and emergency restoration commands.

---

## Documentation Modules Directory

Deep-dive technical writeups located in the [`docs/`](docs/) directory:

* [`docs/01-BOOTLOADER-CARRIER-BYPASS.md`](docs/01-BOOTLOADER-CARRIER-BYPASS.md) - UTAG hardware carrier switching (`fastboot oem config carrier retla`).
* [`docs/02-FASTBOOT-FLASHING-GUIDE.md`](docs/02-FASTBOOT-FLASHING-GUIDE.md) - Stock ROM acquisition via MFD tool and step-by-step 27 sparsechunk reconstruction.
* [`docs/03-ROOT-MAGISK-WITHOUT-TWRP.md`](docs/03-ROOT-MAGISK-WITHOUT-TWRP.md) - Kernel ramdisk patching and A/B slot flashing.
* [`docs/04-SYSTEMLESS-CARRIER-DEBLOATING.md`](docs/04-SYSTEMLESS-CARRIER-DEBLOATING.md) - Post-root systemless debloating and Zygisk PIF configuration.
* [`docs/05-HARDWARE-SPECIFICATIONS-AND-FORENSICS.md`](docs/05-HARDWARE-SPECIFICATIONS-AND-FORENSICS.md) - Hardware specs, carrier services architecture, and 11 critical partition blocks.
* [`docs/06-CRITICAL-BACKUP-AND-DISASTER-RECOVERY.md`](docs/06-CRITICAL-BACKUP-AND-DISASTER-RECOVERY.md) - Emergency fastboot recovery commands and physical security partition inventory.

---

## Magisk Debloater Module (Requires Root)

The source code for the flashable debloater module is available in [`magisk-module/`](magisk-module/):

* **Prerequisite:** Requires an active Magisk Root environment (completed in Step 4).
* **Systemless Overlays:** Replaces carrier package folders (`PAKSFinance`, `PayJoyAccess`, etc.) with empty directories on boot without tripping `dm-verity`.
* **Boot Service:** Automatically disables background telemetry packages and tunes kernel ZRAM memory parameters.
* **Pre-built Download:** [`moto_g55_carrier_debloater_v2.0.zip`](moto_g55_carrier_debloater_v2.0.zip) (or via [Releases](https://github.com/JoshRob297/moto-g55-taipei-guide/releases))

---

## Automated Scripts

Ready-to-use flashing and backup utilities in [`scripts/`](scripts/):

* `scripts/backup_critical_partitions.sh` - Automated raw partition dumper via ADB root.
* `scripts/flash_all.sh` - Automated bash flasher for Linux / macOS.
* `scripts/flash_all.bat` - Automated batch flasher for Windows.
* `scripts/build_module.sh` - Builds the Magisk module flashable ZIP.

---

## Disclaimer & License

This documentation is published for research, educational, device recovery, and unbricking purposes only.  
Distributed under the **MIT License**. See [LICENSE](LICENSE) for details.
