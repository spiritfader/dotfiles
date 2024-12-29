#!/bin/bash
# Measure Packets per Second on an Interface
# Refactored from code written by Joe Miller (https://github.com/joemiller)
# The following script periodically prints out the number of RX/TX packets for a given network interface (to be provided as an argument to the script).
INTERVAL="1"  # update interval in seconds

if [ -z "$1" ]; then
        echo
        echo usage: "$0" network-interface
        echo
        echo e.g. "$0" eth0
        echo
        echo shows packets-per-second
        exit
fi

while true
do
        R1=$(cat /sys/class/net/"$1"/statistics/rx_packets)
        T1=$(cat /sys/class/net/"$1"/statistics/tx_packets)
        sleep $INTERVAL
        R2=$(cat /sys/class/net/"$1"/statistics/rx_packets)
        T2=$(cat /sys/class/net/"$1"/statistics/tx_packets)
        TXPPS=$((T2 - T1))
        RXPPS=$((R2 - R1))
        echo "TX $1: $TXPPS pkts/s RX $1: $RXPPS pkts/s"
done
