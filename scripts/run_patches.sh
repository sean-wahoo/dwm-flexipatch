#!/bin/bash


patches=$(find "$HOME/.config/dwm/patches")

cmd_string="patch "
index=0

for patch in $patches; do
  if [[ $index -eq 0 ]]; then
    ((index++))
    continue
  fi
  pnum=$((index++))
  cmd_string+="< $patch "
done

echo "$cmd_string"
