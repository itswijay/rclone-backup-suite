#!/bin/bash
# restore.sh - Restore Script

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# Load Configuration
CONFIG_FILE="$PROJECT_DIR/configs/backup.conf"

# Check if configuration file exists
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "[ERROR] Configuration file not found: $CONFIG_FILE"
    exit 1
fi

source "$CONFIG_FILE"

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
LOG_FILE="$PROJECT_DIR/logs/restore_$TIMESTAMP.log"

# Check if rclone remote exists
if ! rclone listremotes | grep -q "^$REMOTE_NAME:$"; then
    echo "[ERROR] Rclone remote '$REMOTE_NAME' not found. Please configure it with 'rclone config'"
    exit 1
fi

# Warning prompt
echo "WARNING: This will restore files from backup and may overwrite existing files."
echo "Remote: $REMOTE_NAME:$REMOTE_PATH"
echo "Local directories: ${SOURCE_DIRS[*]}"
echo ""
read -p "Are you sure you want to continue? (y/N): " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "[INFO] Restore cancelled by user."
    exit 0
fi

# Perform restore
echo "[INFO] Starting restore at $TIMESTAMP" | tee -a "$LOG_FILE"
success=true

for DIR in "${SOURCE_DIRS[@]}"; do
    dir_name=$(basename "$DIR")
    remote_path="$REMOTE_NAME:$REMOTE_PATH/$dir_name"
    
    echo "[INFO] Restoring $remote_path to $DIR" | tee -a "$LOG_FILE"
    
    # Create local directory if it doesn't exist
    mkdir -p "$DIR"
    
    rclone copy "$remote_path" "$DIR" --progress --log-file="$LOG_FILE" --log-level INFO
    
    if [[ $? -ne 0 ]]; then
        echo "[ERROR] Failed to restore $remote_path to $DIR" | tee -a "$LOG_FILE"
        success=false
    else
        echo "[SUCCESS] Successfully restored $remote_path to $DIR" | tee -a "$LOG_FILE"
    fi
done

if [[ "$success" == true ]]; then
    echo "[SUCCESS] Restore completed successfully." | tee -a "$LOG_FILE"
    exit 0
else
    echo "[ERROR] Restore completed with errors. Check log: $LOG_FILE" | tee -a "$LOG_FILE"
    exit 1
fi