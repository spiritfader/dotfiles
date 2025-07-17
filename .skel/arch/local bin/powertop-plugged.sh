#!/bin/bash

# set scaling governor: default is "powersave"
echo "powersave" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

# set scaling epp: default is "performance"
#echo "performance" | tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference
echo "balance_performance" | tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference

# set powertop generated tunables
echo '500' > '/proc/sys/vm/dirty_writeback_centisecs'
#echo '10' > '/sys/module/snd_hda_intel/parameters/power_save'
#echo 'on' > '/sys/bus/i2c/devices/i2c-5/device/power/control'
#echo 'on' > '/sys/bus/i2c/devices/i2c-9/device/power/control'
#echo 'on' > '/sys/bus/i2c/devices/i2c-11/device/power/control'
#echo 'on' > '/sys/bus/i2c/devices/i2c-2/device/power/control'
#echo 'on' > '/sys/bus/i2c/devices/i2c-4/device/power/control'
#echo 'on' > '/sys/bus/i2c/devices/i2dec-10/device/power/control'
#echo 'on' > '/sys/bus/i2c/devices/i2c-3/device/power/control'
echo 'on' > '/sys/bus/pci/devices/0000:06:00.1/ata2/power/control'
echo 'on' > '/sys/bus/pci/devices/0000:00:00.2/power/control'
echo 'on' > '/sys/bus/pci/devices/0000:00:18.5/power/control'
echo 'on' > '/sys/bus/pci/devices/0000:06:00.1/power/control'
echo 'on' > '/sys/bus/pci/devices/0000:00:14.3/power/control'
echo 'on' > '/sys/bus/pci/devices/0000:06:00.0/ata1/power/control'
echo 'on' > '/sys/bus/pci/devices/0000:00:18.6/power/control'
echo 'on' > '/sys/bus/pci/devices/0000:00:01.0/power/control'
echo 'on' > '/sys/bus/pci/devices/0000:00:18.1/power/control'
echo 'on' > '/sys/bus/pci/devices/0000:00:18.3/power/control'
echo 'on' > '/sys/bus/pci/devices/0000:05:00.3/power/control'
echo 'on' > '/sys/bus/pci/devices/0000:00:08.0/power/control'
echo 'on' > '/sys/bus/pci/devices/0000:03:00.0/power/control'
echo 'on' > '/sys/bus/pci/devices/0000:00:14.0/power/control'
echo 'on' > '/sys/bus/pci/devices/0000:00:00.0/power/control'
echo 'on' > '/sys/bus/pci/devices/0000:05:00.5/power/control'
echo 'on' > '/sys/bus/pci/devices/0000:04:00.0/power/control'
echo 'on' > '/sys/bus/pci/devices/0000:00:18.0/power/control'
echo 'on' > '/sys/bus/pci/devices/0000:05:00.0/power/control'
echo 'on' > '/sys/bus/pci/devices/0000:00:02.0/power/control'
echo 'on' > '/sys/bus/pci/devices/0000:00:18.2/power/control'
echo 'on' > '/sys/bus/pci/devices/0000:05:00.2/power/control'
echo 'on' > '/sys/bus/pci/devices/0000:06:00.0/power/control'
echo 'on' > '/sys/bus/pci/devices/0000:00:18.7/power/control'
echo 'on' > '/sys/bus/pci/devices/0000:00:18.4/power/control'
echo 'on' > '/sys/bus/pci/devices/0000:05:00.4/power/control'
