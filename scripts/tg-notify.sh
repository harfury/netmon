#!/bin/bash
# /opt/netmon/bin/tg-notify.sh
source /opt/netmon/etc/config.env 2>/dev/null || true

TG_TOKEN="${TG_BOT_TOKEN:-}"
CHAT_ID="${TG_CHAT_ID:-}"

if [ -z "$TG_TOKEN" ] || [ -z "$CHAT_ID" ]; then
  # Fallback на email, если Telegram не настроен
  [ -n "$EMAIL" ] && echo "$1" | mail -s "netmon" "$EMAIL"
  exit 1
fi

# Поддержка stdin или аргумента
TEXT="${1:-$(cat)}"

# Экранирование для HTML (безопасно для русского)
ESC=$(printf '%s' "$TEXT" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g')

curl -s -X POST "https://api.telegram.org/bot${TG_TOKEN}/sendMessage" \
  -d "chat_id=${CHAT_ID}" \
  -d "text=${ESC}" \
  -d "parse_mode=HTML" \
  -d "disable_web_page_preview=true" >/dev/null
