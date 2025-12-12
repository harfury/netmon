#!/bin/bash
# netmon/scripts/start.sh

source /config/env

# Определяем интерфейс
IFACE="${IFACE:-auto}"
[ "$IFACE" = "auto" ] && IFACE=$(ip -br link show up | grep -v lo | head -1 | awk '{print $1}')

# Инициализируем vnstat
if ! vnstat --iflist | grep -q "$IFACE" 2>/dev/null; then
  vnstat -i "$IFACE" --create
fi

# Healthcheck файл
echo "OK $(date)" > /var/www/html/health.txt

# Симлинки для nginx
ln -sf /opt/netmon/log /var/www/html/log
ln -sf /opt/netmon/png  /var/www/html/png

# Запускаем всё через s6
exec /init
