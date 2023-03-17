#!/bin/bash

# This script will run each type of notification with the notify-send command

for urgency in low normal critical; do
  for icon in info warning error; do
    notify-send -a "$urgency" -u $urgency -i $icon "New $urgency Message" "This is a $urgency $icon notification with a long message"
  done
done
