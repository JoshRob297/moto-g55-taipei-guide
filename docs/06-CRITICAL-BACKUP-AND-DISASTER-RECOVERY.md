# Critical Partitions Backup & Disaster Recovery (Moto G55 5G)

Complete insurance policy and emergency procedures for dumping, preserving, and restoring the unique hardware, radio, and calibration partitions of the **Motorola Moto G55 5G** (`XT2435-1` / `taipei`).

---

## 1. Why Back Up Critical Partitions?

Unlike generic system partitions (`system`, `vendor`, `product`) which can always be re-flashed from stock firmware, the baseband, calibration, and hardware security blocks are **device-unique**. If these partitions become corrupted during experimentation:
* Loss of Cellular Signal & IMEI (00000000000000 / NULL baseband).
* Loss of Wi-Fi / Bluetooth MAC address calibration.
* Broken hardware sensor fusion (accelerometer, gyroscope, light sensor).

Creating a 1:1 bit-by-bit raw dump (`dd`) of these partitions is the ultimate safety net.

---

## 2. Automated Partition Backup (ADB Root)

With the device rooted (via Magisk), execute the automated backup script from your computer:

```bash
# Run automated backup script
./scripts/backup_critical_partitions.sh
```

### Manual Backup Commands
Alternatively, execute the dump manually via ADB shell with root:

```bash
adb shell su

# Dump all 11 critical hardware blocks
dd if=/dev/block/by-name/nvram of=/sdcard/nvram.img bs=4096
dd if=/dev/block/by-name/nvdata of=/sdcard/nvdata.img bs=4096
dd if=/dev/block/by-name/nvcfg of=/sdcard/nvcfg.img bs=4096
dd if=/dev/block/by-name/persist of=/sdcard/persist.img bs=4096
dd if=/dev/block/by-name/prodpersist of=/sdcard/prodpersist.img bs=4096
dd if=/dev/block/by-name/protect1 of=/sdcard/protect1.img bs=4096
dd if=/dev/block/by-name/protect2 of=/sdcard/protect2.img bs=4096
dd if=/dev/block/by-name/seccfg of=/sdcard/seccfg.img bs=4096
dd if=/dev/block/by-name/boot_a of=/sdcard/boot_a.img bs=4096
dd if=/dev/block/by-name/vendor_boot_a of=/sdcard/vendor_boot_a.img bs=4096
dd if=/dev/block/by-name/frp of=/sdcard/frp.img bs=4096
exit

# Pull files to your PC
adb pull /sdcard/nvram.img ./
adb pull /sdcard/nvdata.img ./
adb pull /sdcard/nvcfg.img ./
adb pull /sdcard/persist.img ./
adb pull /sdcard/prodpersist.img ./
adb pull /sdcard/protect1.img ./
adb pull /sdcard/protect2.img ./
adb pull /sdcard/seccfg.img ./
adb pull /sdcard/boot_a.img ./
adb pull /sdcard/vendor_boot_a.img ./
adb pull /sdcard/frp.img ./
```

---

## 3. Partition Inventory & Purpose

| Partition Block | Size | Description |
|---|---|---|
| `nvram.img` | 64 MB | Hardware radio calibration, RF tuning, and unique factory IMEI |
| `nvdata.img` | 64 MB | Modem operational parameters, network bands, and SIM lock database |
| `nvcfg.img` | 32 MB | MediaTek baseband configurations |
| `persist.img` | 48 MB | Manufacturer factory calibration and sensor data (camera/compass) |
| `prodpersist.img` | 8 MB | Production persistent hardware identifiers |
| `protect1.img` / `protect2.img` | 8 MB ea | Hardware DRM, Keymaster trustlets, security flags |
| `seccfg.img` | 8 MB | Dimensity processor secure boot configuration block |
| `boot_a.img` / `vendor_boot_a.img` | 64 MB ea | Clean stock factory kernel and ramdisk |
| `frp.img` | 1 MB | Factory Reset Protection configuration block |

---

## 4. Emergency Disaster Recovery (Fastboot)

If the device encounters a bootloop or baseband malfunction:

```bash
# 1. Restore clean stock boot and vendor boot
fastboot flash boot_a boot_a.img
fastboot flash boot_b boot_a.img
fastboot flash vendor_boot_a vendor_boot_a.img
fastboot flash vendor_boot_b vendor_boot_a.img

# 2. Restore radio & modem calibration
fastboot flash nvram nvram.img
fastboot flash nvdata nvdata.img
fastboot flash nvcfg nvcfg.img

# 3. Restore hardware sensors & persistent calibration
fastboot flash persist persist.img
fastboot flash prodpersist prodpersist.img

# 4. Clean wipe and reboot
fastboot erase userdata
fastboot erase metadata
fastboot erase cache
fastboot reboot
```
