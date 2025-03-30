#!/bin/bash

set -euo pipefail

required_vars=("CONTAINER_NAME" "DB_USERNAME" "DB_NAME" "REMOTE_USER" "REMOTE_HOST" "REMOTE_DIR" "LOCAL_TMP_DIR")

if [[ ! -f ./.env.backup ]]; then
  echo "Missing .env.backup file."
  exit 1
fi

source ./.env.backup

for var in "${required_vars[@]}"; do
  if [[ -z "${!var:-}" ]]; then
    echo "Required variable $var is not set or empty."
    exit 1
  fi
done

mkdir -p "$LOCAL_TMP_DIR"

latest_backup=$(ssh "$REMOTE_USER@$REMOTE_HOST" "ls -t $REMOTE_DIR/tesztsor_backup_*.sql 2>/dev/null | head -n 1")

if [[ -z "$latest_backup" ]]; then
  echo "No backup file found on remote host."
  exit 1
fi

filename=$(basename "$latest_backup")
local_backup_path="$LOCAL_TMP_DIR/$filename"
scp "$REMOTE_USER@$REMOTE_HOST:$latest_backup" "$local_backup_path"

if [[ ! -f "$local_backup_path" ]]; then
  echo "Failed to copy backup file."
  exit 1
fi

read -rp "⚠️ This will overwrite the local database '$DB_NAME'. Continue? (y/N): " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
  echo "Aborted."
  rm -f "$local_backup_path"
  exit 0
fi

cat "$local_backup_path" | docker exec -i "$CONTAINER_NAME" psql -U "$DB_USERNAME" "$DB_NAME"

rm -f "$local_backup_path"
