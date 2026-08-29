#!/system/bin/sh
# Wait for Android OS to complete initialization
while [ "$(getprop sys.boot_completed)" != "1" ]; do
    sleep 2
done

# 1. Disable carrier bloatware and background telemetry packages
for pkg in \
    com.motorola.paks \
    com.motorola.paks.notification \
    com.motorola.ccc.ota \
    com.motorola.ccc.devicemanagement \
    com.motorola.omadm.service \
    com.motorola.motocare \
    com.motorola.bug2go \
    com.motorola.demo \
    com.android.managedprovisioning
do
    pm disable-user --user 0 $pkg 2>/dev/null || true
    pm hide --user 0 $pkg 2>/dev/null || true
done

# 2. Remove active Device Admin receivers if any were registered
dpm remove-active-admin com.motorola.paks/.PaksDeviceAdminReceiver 2>/dev/null || true
dpm remove-active-admin com.motorola.ccc.devicemanagement/.DeviceManagementReceiver 2>/dev/null || true

# 3. Kernel memory tuning (favor fast physical LPDDR4X ZRAM over flash writes)
if [ -f /proc/sys/vm/swappiness ]; then
    echo 60 > /proc/sys/vm/swappiness
fi
