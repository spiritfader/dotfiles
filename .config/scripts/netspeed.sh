#!/bin/bash
# Measure Network Bandwidth on an Interface
# Refactored from code written by Joe Miller (https://github.com/joemiller)
# The following script periodically prints out the RX/TX bandwidth (KB/s) for a given network interface (to be provided as an argument to the script).
INTERVAL="1"  # update interval in seconds

if [ -z "$1" ]; then
        echo
        echo usage: "$0" network-interface
        echo
        echo e.g. "$0" eth0
        echo
        exit
fi

while true
do
        R1=$(cat /sys/class/net/"$1"/statistics/rx_bytes)
        T1=$(cat /sys/class/net/"$1"/statistics/tx_bytes)
        sleep $INTERVAL
        R2=$(cat /sys/class/net/"$1"/statistics/rx_bytes)
        T2=$(cat /sys/class/net/"$1"/statistics/tx_bytes)
        TBPS=$((T2 - T1))
        RBPS=$((R2 - R1))
        TKBPS=$((TBPS / 1024))
        RKBPS=$((RBPS / 1024))
        echo "TX $1: $TKBPS kB/s RX $1: $RKBPS kB/s"
done