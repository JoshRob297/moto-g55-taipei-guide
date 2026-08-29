@echo off
REM ==============================================================================
REM Moto G55 5G (XT2435-1 / taipei) Clean Fastboot Flash Script (Windows)
REM Author: JoshRob
REM ==============================================================================

echo ========================================================
echo Moto G55 5G (taipei) - Full Firmware Flasher
echo ========================================================

fastboot getvar max-sparse-size

echo Flashing Radio & Modem...
fastboot flash radio_a radio.img
fastboot flash radio_b radio.img

echo Flashing Low-Level Bootloaders...
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

echo Flashing Kernel, Recovery & AVB Verifications...
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

echo Flashing Super Dynamic Sparsechunks...
for %%i in (super.img_sparsechunk.*) do (
    echo Flashing %%i...
    fastboot flash super "%%i"
)

echo Wiping Userdata & Cache...
fastboot erase userdata
fastboot erase metadata
fastboot erase cache

echo ========================================================
echo Flashing complete! Rebooting device...
echo ========================================================
fastboot reboot
pause
