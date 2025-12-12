# netmon/Dockerfile
FROM alpine:3.20

# Установка s6-overlay (для supervision и healthcheck)
ENV S6_VERSION=v3.2.1.0
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-noarch.tar.xz /tmp/
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-x86_64.tar.xz /tmp/  # для x86
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-aarch64.tar.xz /tmp/
# Для Raspberry Pi (arm64) — раскомментируйте:
# ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-aarch64.tar.xz /tmp/

RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz && \
    tar -C / -Jxpf /tmp/s6-overlay-*.tar.xz && \
    rm -rf /tmp/*.tar.xz

# Зависимости
RUN apk add --no-cache \
    iproute2 curl jq zip bash coreutils libcap procps \
    nginx vnstat vnstati font-noto-cjk

# Права для ip
RUN setcap cap_net_admin+ep /usr/bin/ip

# Создаём структуру
RUN mkdir -p /opt/netmon/{bin,log,png} /var/www/html

# Копируем скрипты и конфиги
COPY scripts/ /opt/netmon/bin/
COPY scripts/services/ /etc/services.d/
COPY public/ /var/www/html/
RUN chmod +x /opt/netmon/bin/*.sh /etc/services.d/*/*.sh

# Nginx: простой доступ к логам и PNG
RUN echo "server { listen 8080; location / { root /var/www/html; autoindex on; } }" > /etc/nginx/http.d/default.conf

# Healthcheck
HEALTHCHECK --interval=5m --timeout=3s --start-period=30s --retries=3 \
  CMD curl -f http://localhost:8080/health.txt || exit 1

ENTRYPOINT ["/init"]
