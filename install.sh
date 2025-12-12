
---

## 📜 `install.sh` — установка без Docker (для Pi)

```bash
#!/bin/bash
# netmon/install.sh

set -e

echo "📦 Установка зависимостей..."
sudo apt update
sudo apt install -y vnstat vnstati iproute2 curl jq zip nginx-light

echo "⚙️ Настройка vnstat..."
IFACE=$(ip -br link show up | grep -v lo | head -1 | awk '{print $1}')
sudo vnstat -i "$IFACE" --create
sudo systemctl enable vnstat

echo "📁 Копирование скриптов..."
sudo mkdir -p /opt/netmon/{bin,log,png}
sudo cp -r scripts/* /opt/netmon/bin/
sudo chmod +x /opt/netmon/bin/*.sh

echo "🔁 Добавление в cron..."
(crontab -l 2>/dev/null; cat <<'CRON'
0 * * * * /opt/netmon/bin/gen-png.sh
0 8 * * * /opt/netmon/bin/daily-report.sh
*/5 * * * * /opt/netmon/bin/check-alerts.sh
0 * * * * /usr/bin/ip -s link show $(ip -br link show up | grep -v lo | head -1 | awk '{print $1}') >> /opt/netmon/log/netstat.log
CRON
) | crontab -

echo "✅ Готово! Отредактируйте /opt/netmon/etc/config.env и запустите:"
echo "   sudo /opt/netmon/bin/daily-report.sh"
