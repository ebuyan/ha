#!/bin/bash

BACKUP_DIR="/mnt/usbssd/system-backup"
DATE=$(date +%F_%H-%M)

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

mkdir -p "$BACKUP_DIR/$DATE"

rsync -aAXv / "${EXCLUDES[@]}" "$BACKUP_DIR/$DATE" | tee "$BACKUP_DIR/backup-$DATE.log"

# (Опционально) удалить бэкапы старше 3 дней
find "$BACKUP_DIR" -maxdepth 1 -type d -mtime +3 -exec rm -rf {} +
