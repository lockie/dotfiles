#!/usr/bin/env sh

# Authors:
# - Andrew Kravchuk <awkravchuk@gmail.com> (2017)
# - Moritz Warning <moritzwarning@web.de> (2016)
# - Zhong Jianxin <azuwis@gmail.com> (2014)

# Single interface:
# ifaces="eth0"
#
# Multiple interfaces:
# ifaces="eth0 wlan0"
#

# Auto detect interfaces
#ifaces=$(ls /sys/class/net | grep -E '^(eth|wlan|enp|wlp)')

ifaces="usb0"

last_time=0
last_rx=0
last_tx=0
rate=""

readable() {
  bytes=$1
  kib=$(( bytes >> 10 ))
  if [ $kib -lt 0 ]; then
    echo "? K"
  elif [ $kib -gt 1024 ]; then
    mib_int=$(( kib >> 10 ))
    mib_dec=$(( kib % 1024 * 976 / 10000 ))
    if [ "$mib_dec" -lt 10 ]; then
      mib_dec="0${mib_dec}"
    fi
    echo "${mib_int}.${mib_dec} MB/s"
  else
    echo "${kib} KB/s"
  fi
}

update_rate() {
  time=$(date +%s)
  rx=0 tx=0 tmp_rx="" tmp_tx=""

  for iface in $ifaces; do
    read -r tmp_rx < "/sys/class/net/${iface}/statistics/rx_bytes"
    read -r tmp_tx < "/sys/class/net/${iface}/statistics/tx_bytes"
    rx=$(( rx + tmp_rx ))
    tx=$(( tx + tmp_tx ))
  done

  interval=$(( time - last_time ))
  if [ $interval -gt 0 ]; then
    rate="%{F#9fafaf}↓%{F-}$(readable $(( (rx - last_rx) / interval ))) %{F#9fafaf}↑%{F-}$(readable $(( (tx - last_tx) / interval )))"
  else
    rate=""
  fi

  last_time=$time
  last_rx=$rx
  last_tx=$tx
}

while :
do
  update_rate
  echo "${rate}" || exit 1
  sleep 2
done
