# test_backup.sh - Test Backup Script
#!/bin/bash
echo "[INFO] Running test backup..."
bash "$(dirname "$0")/backup.sh"
echo "[INFO] Test completed. Check logs."