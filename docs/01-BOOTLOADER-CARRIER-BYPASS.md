# Bootloader Unlock: Carrier Eligibility Bypass (MediaTek UTAG Hack)

## 1. The Carrier Restriction Problem

When requesting an official bootloader unlock key from Motorola's Unlock Portal, carrier-branded or subsidized devices are rejected with:
> *"Your device does not qualify for bootloader unlocking."*

Motorola's web portal verifies the device's eligibility using the `CID` and `carrier` fields embedded inside the `get_unlock_data` payload.

## 2. Hardware Vulnerability: Unprotected `oem config` on MediaTek

Unlike Qualcomm Snapdragon platforms where `oem config` requires an already-unlocked bootloader, recent MediaTek Dimensity devices (including Dimensity 7025 / `taipei`) leave the OEM configuration handler open in Fastboot mode.

### Procedure

1. Boot the phone into **Fastboot Mode**:
   * Turn off the phone.
   * Hold **Volume Down + Power** until the fastboot menu appears.
   * Connect to PC via USB.

2. Verify fastboot connection:
   ```bash
   fastboot devices
   ```

3. Override the hardware carrier UTAG from the carrier channel to unbranded Retail Latin America (`retla`):
   ```bash
   fastboot oem config carrier retla
   ```

4. Retrieve the modified unlock string:
   ```bash
   fastboot oem get_unlock_data
   ```

   Output format:
   ```text
   (bootloader) Unlock data:
   (bootloader) 3A91280394029384#00000000000000
   (bootloader) 000000004D543638#55000000000000
   (bootloader) 0000000000000000#00000000000000
   (bootloader) 0000000000000000#00000000000000
   (bootloader) 0000000000000000
   ```

5. Combine the 5 lines into a single continuous alphanumeric string (remove `(bootloader)` prefixes and spaces).

6. Submit the continuous string to the [Official Motorola Bootloader Unlock Portal](https://motorola-global-portal.custhelp.com/app/standalone/bootloader/unlock-your-device-b).

7. Because the carrier tag now reports `retla`, the automated backend approves the request and emails your 20-character Unlock Key:
   ```text
   <YOUR_20_CHARACTER_KEY>
   ```

8. Execute the unlock command:
   ```bash
   fastboot oem unlock <YOUR_20_CHARACTER_KEY>
   ```

9. The bootloader state transitions to:
   ```text
   securestate: flashing_unlocked
   iswarrantyvoid: yes
   ```
