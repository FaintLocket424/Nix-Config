#!/usr/bin/env bash

BATTERY_PATH="/sys/class/power_supply/BAT1"

if [ ! -d "$BATTERY_PATH" ]; then
  echo "Battery: N/A"
  echo "Status: Battery not found at $BATTERY_PATH"
  exit 1
fi

if [ -f "$BATTERY_PATH/capacity" ]; then
  PERCENTAGE=$(cat "$BATTERY_PATH/capacity")
else
  PERCENTAGE="N/A"
fi

# Read battery status
if [ -f "$BATTERY_PATH/status" ]; then
  STATUS=$(cat "$BATTERY_PATH/status")
else
  STATUS="Unknown"
fi

echo "Battery: ${PERCENTAGE}%"
echo "Status: ${STATUS}"

exit 0