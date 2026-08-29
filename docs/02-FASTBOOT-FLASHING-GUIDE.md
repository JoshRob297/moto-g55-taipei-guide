# Clean Fastboot Flashing Guide (Moto G55 5G / `taipei`)

## 1. Stock Firmware Acquisition

Before flashing, download the official factory firmware package for your model directly from Motorola's AWS S3 servers using the official [`moto-firmware-downloader`](https://github.com/JoshRob297/moto-firmware-downloader) tool:

```bash
# 1. Authenticate with Motorola OAuth
npx moto-firmware-downloader login

# 2. Query and download the full official factory ROM package
npx moto-firmware-downloader imei XT2435-1 <YOUR_IMEI> --download
```
Extract the downloaded ZIP package on your computer.

---

## 2. Partition Structure

The Moto G55 5G (`XT2435-1` / `MT6855`) uses standard A/B dynamic partitions under Android 14 / 15.
The dynamic logical partitions (`system`, `vendor`, `product`, `system_ext`) are packaged inside a 4.5+ GB `super.img` divided into 27 sparse chunks (`super.img_sparsechunk.0` to `super.img_sparsechunk.26`).

---

## 3. Fastboot Flash Sequence

Run the commands in exact order while the device is in **Fastboot Mode**:

```bash
# 1. Baseband & Radio
fastboot flash radio_a radio.img
fastboot flash radio_b radio.img

# 2. Bootloaders & Firmware
fastboot flash preloader_a preloader_raw.img
fastboot flash preloader_b preloader_raw.img
fastboot flash lk_a lk.img
fastboot flash lk_b lk.img
fastboot flash dpm_a dpm.img
fastboot flash dpm_b dpm.img
fastboot flash mcupm_a mcupm.img
fastboot flash mcupm_b mcupm.img
fastboot flash spm_a spm.img
fastboot flash spm_b spm.img
fastboot flash sspm_a sspm.img
fastboot flash sspm_b sspm.img
fastboot flash tee_a tee.img
fastboot flash tee_b tee.img
fastboot flash scp_a scp.img
fastboot flash scp_b scp.img
fastboot flash gz_a gz.img
fastboot flash gz_b gz.img
fastboot flash ccm_a ccm.img
fastboot flash ccm_b ccm.img
fastboot flash vcp_a vcp.img
fastboot flash vcp_b vcp.img
fastboot flash logo_a logo.bin
fastboot flash logo_b logo.bin

# 3. Kernel, Recovery & AVB Verification
fastboot flash boot_a boot.img
fastboot flash boot_b boot.img
fastboot flash vendor_boot_a vendor_boot.img
fastboot flash vendor_boot_b vendor_boot.img
fastboot flash dtbo_a dtbo.img
fastboot flash dtbo_b dtbo.img
fastboot flash vbmeta_a vbmeta.img
fastboot flash vbmeta_b vbmeta.img
fastboot flash vbmeta_system_a vbmeta_system.img
fastboot flash vbmeta_system_b vbmeta_system.img
fastboot flash vbmeta_vendor_a vbmeta_vendor.img
fastboot flash vbmeta_vendor_b vbmeta_vendor.img

# 4. Super Dynamic Partitions (27 Sparsechunks)
for i in $(seq 0 26); do
    fastboot flash super super.img_sparsechunk.$i
done

# 5. Wipe Userdata & Metadata (Factory Reset)
fastboot erase userdata
fastboot erase metadata
fastboot erase cache

# 6. Reboot
fastboot reboot
```
