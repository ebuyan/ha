#!/bin/bash

set -e

BACKUP_DIR="/mnt/usbssd/system-backup"
DATE=$(date +"%Y-%m-%d_%H-%M")
DEST="$BACKUP_DIR/$DATE"
LOG="$BACKUP_DIR/backup-$DATE.log"

# Определяем последний существующий бэкап (исключаем текущий)
LINK_DEST=$(find "$BACKUP_DIR" -mindepth 1 -maxdepth 1 -type d ! -name "$DATE" | sort | tail -n 1)

EXCLUDES=(
  --exclude="/lib/firmware/*"
  --exclude="/usr/lib/firmware/*"
  --exclude="/swapfile"
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
  --exclude="/var/lib/docker/*"
  --exclude="/var/lib/containerd/*"
  --exclude="/var/log/*"
  --exclude="/opt/zigbee2mqtt/*"

  # Домашние директории
  --exclude="/home/*/.cache/*"
  --exclude="/home/*/.npm/*"
  --exclude="/home/*/.cargo/registry"
  --exclude="/home/*/.cargo/git"
  --exclude="/home/*/.local/share/Trash/*"
  --exclude="/home/*/.thumbnails/*"
  --exclude="/home/*/.config/Code/Cache/*"
  --exclude="/home/*/.config/Code/CachedData/*"
  --exclude="/home/*/.config/google-chrome/Default/Cache/*"
  --exclude="/home/*/.config/google-chrome/Default/Code Cache/*"
  --exclude="/home/*/.config/google-chrome/Default/Media Cache/*"
  --exclude="/home/*/Downloads/*"
)

echo "==> Starting backup: $DATE" | tee "$LOG"

rsync -aAXv --delete \
  --link-dest="$LINK_DEST" \
  "${EXCLUDES[@]}" \
  / "$DEST" | tee -a "$LOG"

echo "==> Cleaning old backups..." | tee -a "$LOG"
find "$BACKUP_DIR" -mindepth 1 -maxdepth 1 -type d -mtime +90 -exec rm -rf {} \;

echo "==> Backup completed at $(date)" | tee -a "$LOG"
