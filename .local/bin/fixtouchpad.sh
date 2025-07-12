#!/bin/bash
MODULE="i2c_hid_acpi"
if lsmod | grep -q "$MODULE"; then # Load/Unload the i2c_hid_acpi touchpad kernel module to fix touchpad if broken or simply enable/disable
  sudo modprobe -r "$MODULE"    
else
  sudo modprobe "$MODULE"    
fi