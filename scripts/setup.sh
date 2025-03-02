# setup.sh - Install Dependencies
#!/bin/bash
echo "[INFO] Installing dependencies..."
sudo apt update && sudo apt install -y rclone mailutils

echo "[INFO] Configuring Rclone..."
rclone config

echo "[INFO] Setup complete."