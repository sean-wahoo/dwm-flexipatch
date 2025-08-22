#!/bin/bash

interval=1

. ~/.config/dwm/themes/everforest

IS_WORKTOP=0

if [[ $(hostnamectl hostname) -eq "worktop" ]]; then
  echo "yuh"
  IS_WORKTOP=1
fi

cpu() {
  cpu_val=$(grep -o "^[^ ]*" /proc/loadavg | awk 'NR==1')
  color=$green

  if [[ $cpu_val -gt 40 ]]; then
    color=$yellow
  elif [[ $cpu_val -gt 80 ]]; then
    color=$red
  fi

  printf "^c$green^CPU %s%%" "^c$fg^$cpu_val"
}

battery() {
  capacity="$(cat /sys/class/power_supply/BAT1/capacity)"

  charge_dev=""

  [[ "$IS_WORKTOP" -eq 1 ]] && charge_dev="ADP1" || charge_dev="ACAD"

  is_charging=$(cat "/sys/class/power_supply/$charge_dev/online")

  icon=""
  color=$yellow

  if [ "$is_charging" -eq 1 ]; then
    icon="󱐋"
  else
    if [ "$capacity" -lt 20 ]; then
      icon="󰁻"
      color=$red
    elif [ "$capacity" -lt 40 ]; then
      icon="󰁽"
    elif [ "$capacity" -lt 60 ]; then
      icon="󰁿"
    elif [ "$capacity" -lt 80 ]; then
      icon="󰂁"
    else
      icon="󰁹"
    fi
  fi

  printf "^c$color^%s %s" "$icon" "^c$fg^$capacity"
}

mem() {
  value=$(free -h | awk '/^Mem/ { print $3 }' | sed 's/i//g')
  printf "^c$red^ MEM %s" "^c$fg^$value"
}

internet() {
  output=""

  wireless=($(ip -br addr show | awk '/^wlan/{print $1, $3}'))
  wired=($(ip -br addr show | awk '/^(enp|eth)/{print $1, $3}'))


  if [ "$IS_WORKTOP" -eq "1" ]; then
    vpn_status=$(ip -br addr show "p81" | awk '{print $1}')
    if [[ $vpn_status == "p81" ]]; then
      output="^c$pink^VPN + "
    fi
  fi

  interface=""
  ip=""
  ssid=""

  if (( ${#wireless[@]} != 0 )); then
    interface="${wireless[0]}"
    ip="${wireless[1]}"
    ssid=$(iw dev "$interface" info | grep -Po '(?<=ssid).*')
  fi

  if (( ${#wired[@]} != 0 )); then
    interface="${wired[0]}"
    ip="${wired[1]}"
    ssid=""
  fi

  case "$(cat "/sys/class/net/$interface/operstate" 2>/dev/null)" in
    up) 

      if [[ $ssid == "" ]]; then
        output+="^c$greenblue^%s - %s" 
        printf "$output" "$interface" "^c$fg^$ip" 
      else
        output+="^c$greenblue^%s - %s" 
        printf "$output" "$ssid" "^c$fg^$ip" 
      fi
      ;;
    down)
      message+="^c$greenblue^no network"
      printf "$output"
      ;;
  esac
}

volume() {
  percentage=$(amixer sget Master | awk -F"[][]" '/(Left|Right|Mono):/ { print $2; exit; }')
  printf "^c$orange^VOL - %s" "^c$fg^$percentage"
}

bluetooth() {
  num_clients=$(bluetoothctl show | awk -F'[)(]' '($1 ~ "ActiveInstances") { print $2 }')
  printf "^c$blue^BT - %s devices" "^c$fg^$num_clients"
}

clock() {
  printf "^c$pink^%s" "$(date '+%D - %r')"
}

while true; do
  interval=$((interval + 1))
  sleep 1 && xsetroot -name "$(mem) $(cpu)  $(bluetooth)  $(internet)  $(volume) $(clock)  $(battery)"
done
