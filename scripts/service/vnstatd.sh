#!/bin/bash
# /opt/netmon/bin/vnstatd.sh
source /opt/netmon/etc/config.env 2>/dev/null || true

IFACE="${IFACE:-eth0}"

# Инициализация при первом запуске
if ! vnstat --iflist | grep -q "$IFACE" 2>/dev/null; then
  mkdir -p /var/lib/vnstat
  vnstat -i "$IFACE" --create
fi

# Запуск демона
exec vnstatd -d
