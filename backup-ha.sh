#!/bin/bash

echo "[$(date)] Бэкап запущен" >> /var/log/ha_backup.log

HA_CONFIG="/opt/ha/homeassistant"
BACKUP_DIR="/mnt/usbssd1/home-assistant-backups"
NOW=$(date +"%Y-%m-%d_%H-%M")
ARCHIVE_NAME="ha_backup_$NOW.tar.gz"

# Создание архива
tar -czf "$BACKUP_DIR/$ARCHIVE_NAME" -C "$HA_CONFIG" .

# Удаление старых архивов (старше 14 дней)
find "$BACKUP_DIR" -name "*.tar.gz" -type f -mtime +14 -delete
