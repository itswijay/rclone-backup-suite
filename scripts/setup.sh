#!/bin/bash
# setup.sh - Install Dependencies and Configure Project

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "[INFO] Setting up rclone-backup-suite..."
echo "[INFO] Project directory: $PROJECT_DIR"

# Install dependencies
echo "[INFO] Installing dependencies..."
if command -v apt >/dev/null 2>&1; then
    sudo apt update && sudo apt install -y rclone mailutils
elif command -v yum >/dev/null 2>&1; then
    sudo yum install -y rclone mailx
elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y rclone mailx
else
    echo "[WARNING] Could not detect package manager. Please install rclone and mailutils manually."
fi

# Make scripts executable
echo "[INFO] Making scripts executable..."
chmod +x "$PROJECT_DIR"/scripts/*.sh

# Create logs directory
echo "[INFO] Creating logs directory..."
mkdir -p "$PROJECT_DIR/logs"

# Configure example paths in backup.conf
echo "[INFO] Updating configuration with current user paths..."
USER_HOME="$HOME"
# Use portable sed syntax that works on both Linux and macOS
if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "s|/home/user|$USER_HOME|g" "$PROJECT_DIR/configs/backup.conf"
else
    sed -i "s|/home/user|$USER_HOME|g" "$PROJECT_DIR/configs/backup.conf"
fi

echo "[INFO] Configuring Rclone..."
echo "Please configure your cloud storage remote."
echo "Choose a name for your remote (e.g., 'mygdrive', 'mydropbox')"
echo "Then update the REMOTE_NAME in configs/backup.conf"
echo ""
read -p "Press Enter to continue to rclone config..."
rclone config

echo ""
echo "[SUCCESS] Setup completed!"
echo ""
echo "Next steps:"
echo "1. Edit configs/backup.conf to set your source directories and remote settings"
echo "2. Edit configs/email.conf to set your email address"
echo "3. Test the backup with: ./scripts/test_backup.sh"
echo "4. Run manual backup with: ./scripts/backup.sh"
echo ""