#!/bin/bash
docker compose down

EMAIL=$1
DOMAIN=$2

docker run --rm -it \
  -p 0.0.0.0:80:80 \
  -v "$(pwd)/certbot/conf:/etc/letsencrypt" \
  -v "$(pwd)/certbot/www:/var/www/certbot" \
  certbot/certbot certonly \
  --standalone \
  --preferred-challenges http \
  --email "$EMAIL" \
  --agree-tos \
  --no-eff-email \
  -d "$DOMAIN"

docker compose up --build -d
