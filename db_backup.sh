#!/bin/bash

set -euo pipefail

required_vars=("CONTAINER_NAME" "DB_USERNAME" "DB_NAME" "BACKUP_DIR" "REMOTE_USER" "REMOTE_HOST" "REMOTE_DIR")
today=$(date +'%Y-%m-%d')
timestamp=$(date +"%Y-%m-%d-%H-%M-%S")

if [[ ! -f ./.env.backup ]]; then
  echo "[$timestamp] Missing .env.backup file."
  exit 1
fi

source ./.env.backup

for var in "${required_vars[@]}"; do
  if [[ -z "${!var:-}" ]]; then
    echo "[$timestamp] Required variable $var is not set or empty."
    exit 1
  fi
done

if [[ ! -d "$BACKUP_DIR" ]]; then
  echo "[$timestamp] Missing backup directory: $BACKUP_DIR"
fi


find "$BACKUP_DIR" -type f | grep -E '[0-9]{4}-[0-9]{2}-[0-9]{2}' | while read -r file; do
  file_date=$(echo "$file" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}')
  if [[ "$file_date" < "$today" ]]; then
    rm -f "$file"
    #echo "Deleted old backup: $file"
  fi
done

backup_file="$BACKUP_DIR/tesztsor_backup_$timestamp.sql"

if ! /usr/bin/docker exec -i "$CONTAINER_NAME" /usr/bin/pg_dump -U "$DB_USERNAME" "$DB_NAME" > "$backup_file"; then
  echo "[$timestamp] SQL dump process failed."
  exit 1
fi

if id -nG | grep -qw backup_users; then
  chgrp backup_users "$backup_file"
fi

chmod 660 "$backup_file"

scp "$backup_file" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR" || echo "Remote backup transfer failed."
