#!/bin/bash
# netmon/scripts/services/ping-loss.sh

IFACE="${IFACE:-eth0}"
GATEWAY=$(ip route | awk '/default/ {print $3}' | head -1)
LOG="/opt/netmon/log/ping-loss.log"

mkdir -p /opt/netmon/log
exec ping -I "$IFACE" -c 5 -W 1 -q "$GATEWAY" 2>/dev/null | \
  awk -v d="$(date '+%Y-%m-%d %H:%M:%S')" '/transmitted/ {print "["d"] " $0}' >> "$LOG"
