#!/bin/bash
# backup.sh - Automated Rclone Backup Script

# Load Configuration
source "$(dirname "$0")/../configs/backup.conf"
source "$(dirname "$0")/../configs/email.conf"

# Timestamp
TIMESTAMP=$(date "+%Y-%m-%d_%H-%M-%S")
LOG_FILE="$(dirname "$0")/../logs/backup_$TIMESTAMP.log"

# Function to Send Email Notification
send_email() {
    echo -e "$1" | mail -s "$2" "$EMAIL_RECIPIENT"
}

# Perform Backup
{
    echo "[INFO] Starting backup at $TIMESTAMP"
    for DIR in "${BACKUP_DIRS[@]}"; do
        echo "[INFO] Backing up $DIR"
        rclone sync "$DIR" "$REMOTE:$DIR" --progress --log-file="$LOG_FILE"
    done
    echo "[SUCCESS] Backup completed."
    send_email "Backup completed successfully at $TIMESTAMP" "Backup Success"
} || {
    echo "[ERROR] Backup failed. Check log: $LOG_FILE"
    send_email "Backup failed at $TIMESTAMP. Check logs." "Backup Failure"
}
