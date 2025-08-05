#!/usr/bin/dash

interval=1

. ~/.config/dwm/themes/everforest

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
  is_charging=$(cat /sys/class/power_supply/ACAD/online)

  icon=""
  color=$yellow

  if [ $is_charging -eq 1 ]; then
    icon="󱐋"
  else
    if [ $capacity -lt 20 ]; then
      icon="󰁻"
      color=$red
    elif [ $capacity -lt 40 ]; then
      icon="󰁽"
    elif [ $capacity -lt 60 ]; then
      icon="󰁿"
    elif [ $capacity -lt 80 ]; then
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

wlan() {
  interface="wlan0"
  ip=$(ip -br addr show "$interface" | awk '{print $3}')
  ssid=$(iw dev "$interface" info | grep -Po '(?<=ssid).*')
  case "$(cat "/sys/class/net/$interface/operstate" 2>/dev/null)" in
    up) printf "^c$greenblue^%s - %s" "$ssid" "^c$fg^$ip" ;;
    down) printf "^c$greenblue^no network" ;;
  esac
}

volume() {
  percentage=$(amixer sget Master | awk -F"[][]" '/[Mono|Left|Right]:/ { print $2 }')
  # output_type=$()
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
  # [ $interval = 0 ] || [ $(($interval % 3600)) = 0 ]
  interval=$((interval + 1))
  sleep 1 && xsetroot -name "$(mem) $(cpu)  $(bluetooth) $(wlan)  $(volume) $(clock)  $(battery)"
done
