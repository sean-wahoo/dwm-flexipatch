#!/usr/bin/bash
# dash ~/.config/dwm/scripts/bar.sh &
while true; do
  killall bar.sh -s 9
  ~/.config/dwm/scripts/bar.sh > /dev/null 2>&1 &
  ~/.local/bin/dwm > /dev/null 2>&1
done
