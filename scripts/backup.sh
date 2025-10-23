#!/bin/bash
# backup.sh - Automated Rclone Backup Script

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# Load Configuration
CONFIG_FILE="$PROJECT_DIR/configs/backup.conf"
EMAIL_CONFIG_FILE="$PROJECT_DIR/configs/email.conf"

# Check if configuration files exist
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "[ERROR] Configuration file not found: $CONFIG_FILE"
    exit 1
fi

if [[ ! -f "$EMAIL_CONFIG_FILE" ]]; then
    echo "[ERROR] Email configuration file not found: $EMAIL_CONFIG_FILE"
    exit 1
fi

# Load configurations
source "$CONFIG_FILE"
source "$EMAIL_CONFIG_FILE"

# Validate required variables
if [[ -z "${SOURCE_DIRS[*]}" ]]; then
    echo "[ERROR] SOURCE_DIRS not defined in configuration"
    exit 1
fi

if [[ -z "$REMOTE_NAME" ]]; then
    echo "[ERROR] REMOTE_NAME not defined in configuration"
    exit 1
fi

if [[ -z "$REMOTE_PATH" ]]; then
    echo "[ERROR] REMOTE_PATH not defined in configuration"
    exit 1
fi

# Create logs directory if it doesn't exist
mkdir -p "$PROJECT_DIR/logs"

# Timestamp
TIMESTAMP=$(date "+%Y-%m-%d_%H-%M-%S")
LOG_FILE="$PROJECT_DIR/logs/backup_$TIMESTAMP.log"

# Clean up old log files based on RETENTION_DAYS
if [[ -n "$RETENTION_DAYS" ]] && [[ "$RETENTION_DAYS" =~ ^[0-9]+$ ]]; then
    echo "[INFO] Cleaning up log files older than $RETENTION_DAYS days..."
    find "$PROJECT_DIR/logs" -name "backup_*.log" -type f -mtime +"$RETENTION_DAYS" -delete 2>/dev/null
fi

# Check if rclone remote exists
if ! rclone listremotes | grep -q "^$REMOTE_NAME:$"; then
    echo "[ERROR] Rclone remote '$REMOTE_NAME' not found. Please configure it with 'rclone config'"
    exit 1
fi

# Function to Send Email Notification
send_email() {
    if [[ "$ENABLE_EMAIL_NOTIFICATIONS" == "yes" && -n "$EMAIL_RECIPIENT" ]]; then
        local subject="${3:-Backup Notification}"
        echo -e "$1" | mail -s "$subject" "$EMAIL_RECIPIENT"
    fi
}

# Function to perform backup
perform_backup() {
    local success=true
    
    echo "[INFO] Starting backup at $TIMESTAMP" | tee -a "$LOG_FILE"
    echo "[INFO] Backup mode: $BACKUP_MODE" | tee -a "$LOG_FILE"
    
    # Check source directories
    for DIR in "${SOURCE_DIRS[@]}"; do
        if [[ ! -d "$DIR" ]]; then
            echo "[ERROR] Source directory does not exist: $DIR" | tee -a "$LOG_FILE"
            success=false
        fi
    done
    
    if [[ "$success" == false ]]; then
        echo "[ERROR] One or more source directories are missing. Aborting backup." | tee -a "$LOG_FILE"
        return 1
    fi
    
    # Perform backup for each directory
    for DIR in "${SOURCE_DIRS[@]}"; do
        local dir_name=$(basename "$DIR")
        local remote_path="$REMOTE_NAME:$REMOTE_PATH/$dir_name"
        
        echo "[INFO] Backing up $DIR to $remote_path" | tee -a "$LOG_FILE"
        
        # Choose backup mode
        if [[ "$BACKUP_MODE" == "sync" ]]; then
            rclone sync "$DIR" "$remote_path" --progress --log-file="$LOG_FILE" --log-level INFO
        else
            rclone copy "$DIR" "$remote_path" --progress --log-file="$LOG_FILE" --log-level INFO
        fi
        
        if [[ $? -ne 0 ]]; then
            echo "[ERROR] Failed to backup $DIR" | tee -a "$LOG_FILE"
            success=false
        else
            echo "[SUCCESS] Successfully backed up $DIR" | tee -a "$LOG_FILE"
        fi
    done
    
    if [[ "$success" == true ]]; then
        echo "[SUCCESS] Backup completed successfully." | tee -a "$LOG_FILE"
        send_email "Backup completed successfully at $TIMESTAMP\n\nBackup Details:\n- Mode: $BACKUP_MODE\n- Directories: ${SOURCE_DIRS[*]}\n- Remote: $REMOTE_NAME:$REMOTE_PATH\n\nLog file: $LOG_FILE" "body" "${EMAIL_SUBJECT_SUCCESS:-Backup Success}"
        return 0
    else
        echo "[ERROR] Backup completed with errors. Check log: $LOG_FILE" | tee -a "$LOG_FILE"
        send_email "Backup failed at $TIMESTAMP\n\nPlease check the log file: $LOG_FILE" "body" "${EMAIL_SUBJECT_FAILURE:-Backup Failure}"
        return 1
    fi
}

# Main execution
if perform_backup; then
    exit 0
else
    exit 1
fi
