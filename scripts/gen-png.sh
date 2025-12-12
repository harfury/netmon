#!/bin/bash
# netmon/scripts/gen-png.sh

IFACE="${IFACE:-eth0}"
OUT_DIR="/opt/netmon/png"
mkdir -p "$OUT_DIR"

# Графики
vnstati -i "$IFACE" -h -o "$OUT_DIR/hourly.png"
vnstati -i "$IFACE" -d -o "$OUT_DIR/daily.png"
vnstati -i "$IFACE" -m -o "$OUT_DIR/monthly.png"
vnstati -i "$IFACE" -s -o "$OUT_DIR/summary.png"

# Обновляем healthcheck
echo "OK $(date) | PNG updated" > /var/www/html/health.txt
