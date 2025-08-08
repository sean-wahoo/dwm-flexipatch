#!/usr/bin/bash
# dash ~/.config/dwm/scripts/bar.sh &
while true; do
  killall bar.sh -s 9
  ~/.config/dwm/scripts/bar.sh 2> ~/.config/dwm/bar.log &
  ~/.local/bin/dwm 2> ~/.config/dwm/dwm.log 
done
