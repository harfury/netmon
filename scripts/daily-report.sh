#!/bin/bash
source /config/env

IFACE="${IFACE:-eth0}"
HOST=$(hostname)
DATE=$(date '+%Y-%m-%d %H:%M')

# Генерируем PNG
/opt/netmon/bin/gen-png.sh

# Отправляем текст
MSG="📊 <b>Ежедневный отчёт: $HOST</b>
📆 $DATE
🔌 <code>$IFACE</code>"

/opt/netmon/bin/tg-notify.sh "$MSG"

# Отправляем PNG
for f in summary daily hourly; do
  [ -f "/opt/netmon/png/${f}.png" ] && \
    curl -s -X POST "https://api.telegram.org/bot$TG_BOT_TOKEN/sendPhoto" \
      -F "chat_id=$TG_CHAT_ID" \
      -F "photo=@/opt/netmon/png/${f}.png" \
      -F "caption=📈 $f график" >/dev/null
done
