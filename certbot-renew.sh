#!/bin/bash

set -e
cd "$(dirname "$0")"
docker compose run --rm certbot renew --webroot --webroot-path=/var/www/certbot
docker compose exec nginx nginx -s reload

