#!/bin/bash

BACKUP_DIR="/mnt/usbssd/system-backup"
DATE=$(date +%F_%H-%M)

EXCLUDES=(
  --exclude="/proc/*"
  --exclude="/sys/*"
  --exclude="/dev/*"
  --exclude="/run/*"
  --exclude="/mnt/*"
  --exclude="/media/*"
  --exclude="/lost+found"
  --exclude="/tmp/*"
  --exclude="/var/tmp/*"
  --exclude="/var/cache/*"
)

mkdir -p "$BACKUP_DIR/$DATE"

rsync -aAXv / "${EXCLUDES[@]}" "$BACKUP_DIR/$DATE" | tee "$BACKUP_DIR/backup-$DATE.log"

# (Опционально) удалить бэкапы старше 7 дней
find "$BACKUP_DIR" -maxdepth 1 -type d -mtime +7 -exec rm -rf {} +
