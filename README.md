# 📡 netmon — лёгкий сетевой мониторинг для Raspberry Pi

Автоматически собирает:
- 📉 Потери пакетов  
- 📥 Ошибки/дропы интерфейса  
- 📊 Трафик (vnstat + PNG-графики)  
- 🚨 Алерты при >5% loss  

Доставка: **Telegram** (основное), Email (fallback).

---

## 🚀 Быстрый старт (на Pi)

```bash
git clone https://github.com/harfury/netmon.git
cd netmon
cp config/.env.example config/.env
nano config/env  # ← введите TG_BOT_TOKEN и TG_CHAT_ID
./install.sh
