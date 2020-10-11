#!/bin/sh
threshold_extremely_low=5
threshold_very_low=10
threshold_low=20

[ "$(< /sys/class/power_supply/BAT0/capacity)" -lt "$threshold_extremely_low" ] && \
notify-send -i dialog-warning-symbolic "BATTERY EXTREMELY LOW" "CONNECT THE DEVICE TO A POWER OUTLET NOW" && \
exit

[ "$(< /sys/class/power_supply/BAT0/capacity)" -lt "$threshold_very_low" ] && \
notify-send -i battery-caution-symbolic "Battery very low" "Please connect the device to a power outlet asap" && \
exit

[ "$(< /sys/class/power_supply/BAT0/capacity)" -lt "$threshold_low" ] && \
notify-send -i battery-low-symbolic "Battery low" "Please connect the device to a power outlet"

exit 0
