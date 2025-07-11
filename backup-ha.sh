#!/bin/bash

HA_CONFIG="/opt/ha/homeassistant"
BACKUP_DIR="/mnt/usbssd/home-assistant-backups"
NOW=$(date +"%Y-%m-%d_%H-%M")
ARCHIVE_NAME="ha_backup_$NOW.tar.gz"

# Создание архива
tar -czf "$BACKUP_DIR/$ARCHIVE_NAME" -C "$HA_CONFIG" .

# Удаление старых архивов (старше 14 дней)
find "$BACKUP_DIR" -name "*.tar.gz" -type f -mtime +14 -delete
