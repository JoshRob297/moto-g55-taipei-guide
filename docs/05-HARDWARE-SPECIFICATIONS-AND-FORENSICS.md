# Hardware Architecture, Partition Maps & Carrier Services Analysis

## 1. Hardware & Firmware Specifications

| Component | Technical Details |
|---|---|
| **Device Model** | Motorola Moto G55 5G (`XT2435-1` / `XT2435-x`) |
| **Internal Codename** | `taipei` / `taipei_g_sysn` |
| **SoC / Chipset** | MediaTek Dimensity 7025 (`MT6855`, 6nm Octa-Core) |
| **RAM** | 8 GB LPDDR4X (Samsung) |
| **Storage (UFS)** | 256 GB UFS Flash (Samsung `KM8F9001JM-B813`) |
| **Display** | 6.5" FHD+ (1080 x 2400) IPS LCD @ 120 Hz |
| **Battery** | 5,000 mAh Li-Po |
| **Target OS / Build** | Android 14 / Android 15 (Hello UI) — e.g., `W1UTS36.51-39-1` |
| **Carrier Region ID (CID)** | `0x0032` (CID50 / Retail LATAM) |
| **Security Architecture** | MediaTek DAA (Device Attestation) + SBC (Secure Boot) |

---

## 2. Carrier Services Architecture Analysis (`com.motorola.paks`)

The background carrier management stack on Latin America / EMEA units operates through several interrelated packages:

* **Primary Binary:** `/system_ext/priv-app/PAKSFinance/PAKSFinance.apk`
* **Associated Packages:** `PaksFinanceNotification.apk`, `3c_devicemanagement-binary.apk`, `PayJoyAccess.apk`
* **Central Host:** `https://motpaks.com/v3/api/paks/`
* **Validation Endpoints Identified:**
  * `GET finance/enrollment` — Device provisioning and enrollment status query by IMEI.
  * `GET blocklist/status` — Status polling and policy updates.
  * `POST fcmtoken` — Registers Google FCM push notification hooks for background sync.
  * `POST authenticate` and `GET nonce` — Cryptographic challenge handshake.
* **Cryptographic Attestation:** Requests utilize a JSON Web Signature (`x-jws-signature`) signed with the processor's hardware-backed private key (`paks-key`).
* **Dynamic Ingestion Service:** The background service `FinancedApkDownloadService` dynamically downloads supplementary policy and management packages when active.

---

## 3. Physical Partition Inventory (11 Critical Security Blocks)

The device's low-level security and modem calibration reside in physical blocks mapped to `/dev/block/by-name/`:

1. **`nvram.img`** (64 MB) — Radio calibration, band frequencies, and factory IMEI.
2. **`nvdata.img`** (64 MB) — Mobile network runtime database and carrier parameters.
3. **`nvcfg.img`** (32 MB) — MediaTek modem configuration files.
4. **`persist.img`** (48 MB) & **`prodpersist.img`** (8 MB) — Factory persistent partition (sensors, calibration).
5. **`protect1.img`** & **`protect2.img`** (8 MB each) — Factory DRM and trustlet storage.
6. **`seccfg.img`** (8 MB) — Dimensity processor secure boot configuration flag.
7. **`boot_a.img`** / **`vendor_boot_a.img`** (64 MB each) — Clean factory Linux kernel and ramdisk.
8. **`frp.img`** (1 MB) — Factory Reset Protection configuration block.

---

## 4. Kernel Memory Tuning: Physical ZRAM vs. Storage Longevity

Motorola's default "RAM Boost" feature uses flash-based virtual swap, causing continuous write wear on the Samsung UFS chip and random micro-stutters during heavy I/O.

* **Recommendation:** Turn off "RAM Boost" in system settings.
* **Kernel ZRAM Optimization:** Setting `vm.swappiness = 60` instructs the Linux kernel to compress inactive memory pages into fast physical LPDDR4X RAM instead of hitting physical storage.
