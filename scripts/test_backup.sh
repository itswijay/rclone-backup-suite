#!/bin/bash
# test_backup.sh - Test Backup Script

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "[INFO] Running test backup..."
echo "[INFO] This will perform a real backup operation."
echo ""
read -p "Continue? (y/N): " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "[INFO] Test cancelled by user."
    exit 0
fi

bash "$SCRIPT_DIR/backup.sh"
exit_code=$?

if [[ $exit_code -eq 0 ]]; then
    echo "[SUCCESS] Test backup completed successfully!"
else
    echo "[ERROR] Test backup failed. Check logs in logs/ directory."
fi

exit $exit_code