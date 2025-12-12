#!/bin/bash
# /opt/netmon/bin/check-alerts.sh
source /opt/netmon/etc/config.env 2>/dev/null || true

IFACE="${IFACE:-$(ip -br link show up | grep -v lo | head -1 | awk '{print $1}')}"
LOG="/opt/netmon/log/ping-loss.log"

[ ! -f "$LOG" ] && exit 0

# Берём последние 10 строк, извлекаем %, считаем среднее
LOSSES=$(tail -n 10 "$LOG" | grep -o '[0-9]*%' | sed 's/%//g')
[ -z "$LOSSES" ] && exit 0

AVG=$(echo "$LOSSES" | awk '{sum+=$1} END {print int(sum/NR)}')
[ "$AVG" -lt 5 ] && exit 0

LAST=$(tail -n 1 "$LOG")
MSG="🚨 <b>Алерт!</b> Потери на <code>$(hostname)</code>
📊 Среднее за 10 мин: <code>${AVG}%</code>
📡 Последнее: <code>$LAST</code>
🔌 Интерфейс: <code>$IFACE</code>"

/opt/netmon/bin/tg-notify.sh "$MSG"
