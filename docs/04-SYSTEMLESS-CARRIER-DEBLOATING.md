# Systemless Carrier Debloating and Google Play Integrity Restoration

> **Prerequisite:** This procedure requires an active **Magisk Root environment** (completed in [Step 3: Rooting with Magisk](03-ROOT-MAGISK-WITHOUT-TWRP.md)) and that you have created your [Critical Partitions Backup](06-CRITICAL-BACKUP-AND-DISASTER-RECOVERY.md).

## 1. OEM Background Services on Modern Android

Modern carrier and OEM system distributions bundle background services, diagnostic tools, and policy management packages inside protected system partitions:
* `/system_ext/priv-app/PAKSFinance`
* `/system_ext/priv-app/PaksFinanceNotification`
* `/system_ext/priv-app/3c_devicemanagement-binary`
* `/product/priv-app/PayJoyAccess`

Deleting these files directly from read-only system partitions triggers Android `dm-verity` verification failure, rendering the device unbootable.

---

## 2. Systemless Overlay Neutralization via Magisk

With root access, Magisk allows **systemless overlay mounting**—making specific package directories appear completely empty to the Android OS upon boot without altering physical disk blocks:

```text
magisk-module/
├── module.prop
├── service.sh
└── system
    ├── product
    │   └── priv-app
    │       └── PayJoyAccess
    │           └── .replace
    └── system_ext
        └── priv-app
            ├── 3c_devicemanagement-binary
            │   └── .replace
            ├── PAKSFinance
            │   └── .replace
            └── PaksFinanceNotification
                └── .replace
```

When Android initializes, the `.replace` marker instructs the kernel to mount an empty directory over the OEM/carrier binaries. The background services never execute.

### Background Service Package Inactivation (`service.sh`)
The boot script further disables associated background telemetry components:
```bash
pm disable-user --user 0 com.motorola.paks
pm disable-user --user 0 com.motorola.paks.notification
pm disable-user --user 0 com.motorola.ccc.devicemanagement
pm disable-user --user 0 com.motorola.motocare
pm disable-user --user 0 com.motorola.omadm.service
pm disable-user --user 0 com.motorola.bug2go
pm disable-user --user 0 com.motorola.demo
pm disable-user --user 0 com.android.managedprovisioning
```

---

## 3. Restoring Google Play Integrity (Passing SafetyNet / Banking Apps)

Unlocking the bootloader breaks Hardware-Backed Keystore attestation. To restore Google Play Store certification and use banking/streaming apps:

### Step 1: Enable Zygisk in Magisk
1. Open **Magisk app**.
2. Tap the **Settings (Gear icon)** in the top right corner.
3. Under the **Magisk** section:
   * Turn **ON** `Zygisk`.
   * Turn **ON** `Enforce DenyList`.
4. Tap **Configure DenyList** -> Tap the 3 dots (top right) -> Check **Show system apps**.
5. Add Google Play Services (`com.google.android.gms`) and any sensitive banking applications.

### Step 2: Install Play Integrity Fix (PIF) Module
1. Download the latest **Play Integrity Fix** (PIF) zip module.
2. In Magisk -> Go to the **Modules** tab -> **Install from storage**.
3. Select the PIF zip file.
4. Reboot the device.

### Step 3: Verify Integrity
Install **Play Integrity API Checker** from Google Play.
You will see:
* `MEETS_BASIC_INTEGRITY`: **PASS**
* `MEETS_DEVICE_INTEGRITY`: **PASS**
* Google Play Store settings will display: **"Device is certified"**.
