#!/bin/bash

# This script will run each type of notification with the notify-send command

systemctl restart --user dunst

for urgency in low normal critical; do
  notify-send -a "$urgency" -u $urgency "New $urgency Message" "This is a $urgency notification with a long message"
done
