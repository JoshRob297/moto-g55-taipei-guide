# Magisk Module: Motorola Carrier & Telemetry Debloater

This folder contains the complete, uncompressed source code for the Magisk module.

## What it does:
1. **Systemless Overlays (`.replace`):** Mounts empty folders over the following system package locations:
   * `/system_ext/priv-app/PAKSFinance/`
   * `/system_ext/priv-app/PaksFinanceNotification/`
   * `/system_ext/priv-app/3c_devicemanagement-binary/`
   * `/product/priv-app/PayJoyAccess/`
2. **Boot Service (`service.sh`):**
   * Disables and hides carrier background telemetry packages (`pm disable-user`, `pm hide`).
   * Strips any registered Device Admin receivers.
   * Optimizes `vm.swappiness = 60` for hardware ZRAM.

## How to Build the Flashable ZIP:
From the root of this repository:
```bash
./scripts/build_module.sh
```
Then copy `moto_g55_carrier_debloater_v2.0.zip` to the device and flash it in **Magisk app -> Modules -> Install from storage**.
