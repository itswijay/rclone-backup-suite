#!/bin/bash
source "$(dirname "$0")/../configs/backup.conf"
TIMESTAMP=$(date "+%Y-%m-%d_%H-%M-%S")
LOG_FILE="$(dirname "$0")/../logs/restore_$TIMESTAMP.log"

echo "[INFO] Starting restore at $TIMESTAMP"
for DIR in "${BACKUP_DIRS[@]}"; do
    echo "[INFO] Restoring $DIR"
    rclone copy "$REMOTE:$DIR" "$DIR" --progress --log-file="$LOG_FILE"
done
echo "[SUCCESS] Restore completed."