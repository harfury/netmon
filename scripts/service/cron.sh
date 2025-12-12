#!/bin/bash
# netmon/scripts/services/cron.sh

crond -f &

# logrotate (каждый день)
while true; do
  sleep 86400  # 24h
  logrotate -f <<EOF
/opt/netmon/log/*.log {
  daily
  rotate 7
  compress
  missingok
  notifempty
}
EOF
done
