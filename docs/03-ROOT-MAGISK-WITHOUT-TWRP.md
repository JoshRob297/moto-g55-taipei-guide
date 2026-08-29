# Rooting Moto G55 5G with Magisk (Without Custom Recovery / TWRP)

## 1. Why No TWRP?

As of 2026, no official or stable community TWRP recovery exists for the Moto G55 5G (`XT2435-x` / `taipei`) due to MediaTek MT6855 partition security and kernel driver complexities.
Root is achieved safely by patching the official kernel (`boot.img`) via Magisk.

## 2. Step-by-Step Rooting Procedure

### Step 1: Obtain the Clean `boot.img`
Download the official firmware ZIP for your device using `moto-firmware-downloader` and extract `boot.img`.

### Step 2: Transfer to Phone
Copy `boot.img` to the phone's Internal Storage (`/sdcard/Download/boot.img`).

### Step 3: Install Magisk
1. Download and install the latest **Magisk APK** (v28.1 or higher) on the phone.
2. Open Magisk -> tap **Install** (in the Magisk card).
3. Select **"Select and Patch a File"**.
4. Browse to `/sdcard/Download/boot.img`.
5. Tap **LET'S GO**.
6. Magisk will patch the ramdisk and kernel, outputting:
   `/sdcard/Download/magisk_patched_XXXXX.img`.

### Step 4: Transfer Patched Boot to PC
Copy `magisk_patched_XXXXX.img` back to your computer (rename it to `new-boot.img` for convenience).

### Step 5: Flash Patched Kernel
1. Reboot the phone into **Fastboot Mode**:
   ```bash
   adb reboot bootloader
   ```
2. Flash the patched kernel to both A and B partitions:
   ```bash
   fastboot flash boot_a new-boot.img
   fastboot flash boot_b new-boot.img
   ```
3. Reboot to Android:
   ```bash
   fastboot reboot
   ```

### Step 6: Verify Root
Open the Magisk app. You will see:
* **Installed:** `28.1 (28100)`
* Superuser access enabled.
