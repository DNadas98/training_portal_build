#!/bin/bash

# certbot-renew.sh
set -e

cd "$(dirname "$0")"

echo "[+] Starting Certbot renewal with webroot..."

docker compose run --rm certbot renew \
  --webroot --webroot-path=/var/www/certbot

echo "[+] Reloading Nginx to apply renewed certs..."
docker compose exec nginx nginx -s reload

echo "[+] Done."

