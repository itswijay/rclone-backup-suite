# rclone-backup-suite

## Overview
This script automates daily backups for multiple folders, supports cloud storage (Google Drive, Dropbox, OneDrive), and provides email notifications on success or failure. It includes error handling, logging, and optional encryption.

## Features
- 📁 **Multi-folder Backup** – Backup multiple directories in one go
- ☁ **Cloud Storage Support** – Works with Google Drive, Dropbox, OneDrive via `rclone`
- 🔒 **Encryption Support** – Optional encryption using `rclone crypt`
- 📧 **Email Notifications** – Get notified about backup status via email
- 📝 **Logging & Error Handling** – Saves logs for each backup attempt
- 🕒 **Automated Scheduling** – Configurable daily backups using `cron`
- 🗂 **Incremental Backup** – Syncs only changed files to save space

## Prerequisites
1. **Install `rclone`**
   ```bash
   curl https://rclone.org/install.sh | sudo bash
   ```
2. **Set Up Cloud Storage**
   ```bash
   rclone config
   ```
   Follow the on-screen instructions to add Google Drive, Dropbox, or OneDrive.
3. **Install `mailutils` for Email Notifications** (Optional)
   ```bash
   sudo apt install mailutils -y  # Debian/Ubuntu
   sudo yum install mailx -y      # CentOS/RHEL
   ```

## Installation
1. **Clone this repository**
   ```bash
   git clone https://github.com/thewijay/rclone-backup-suite.git
   cd rclone-backup-suite
   ```

2. **Configure backup settings**
   Edit the `configs/backup.conf` file to set backup paths and destinations.

   ## Configuring Backup Settings
Before running the backup, configure your settings in `configs/backup.conf`.

### **Example `backup.conf` (Backup Folders & Cloud Storage)**
```ini
# Backup source directories (local paths)
SOURCE_DIRS=(
  "/home/user/Documents"
  "/home/user/Pictures"
  "/home/user/Projects"
)

# Remote storage location (configured via rclone)
REMOTE_NAME="mygdrive"  # Name of rclone remote
REMOTE_PATH="Backups/rclone-backup-suite"

# Backup mode: "sync" (mirror) or "copy" (incremental)
BACKUP_MODE="sync"

# Retention settings (Keep last 7 backups)
RETENTION_DAYS=7
```
📌 **Explanation:**  
- **`SOURCE_DIRS`** → List of local directories to back up  
- **`REMOTE_NAME`** → Name of your cloud storage configured in `rclone config`  
- **`REMOTE_PATH`** → Remote directory to store backups  
- **`BACKUP_MODE`** → `"sync"` (mirror files) or `"copy"` (only add changes)  
- **`RETENTION_DAYS`** → Automatically delete backups older than 7 days  

### **Example `email.conf` (Email Notifications)**
```ini
# Email settings for backup notifications
SMTP_SERVER="smtp.gmail.com"
SMTP_PORT=587
SMTP_USER="your-email@gmail.com"
SMTP_PASS="your-app-password"

# Recipient email address
EMAIL_TO="your-email@gmail.com"

# Email subject formats
EMAIL_SUBJECT_SUCCESS="Backup Success"
EMAIL_SUBJECT_FAILURE="Backup Failure"
```
📌 **Explanation:**  
- **`SMTP_SERVER`** → SMTP server of your email provider  
- **`SMTP_PORT`** → Usually `587` for TLS (secure)  
- **`SMTP_USER`** → Your email address  
- **`SMTP_PASS`** → Use an **app password** (not your actual password)  
- **`EMAIL_TO`** → Where to send notifications

3. **Make scripts executable**
   ```bash
   chmod +x scripts/*.sh
   ```


## Usage
### **Run Backup Manually**
```bash
./scripts/backup.sh
```

### **Restore Backup**
```bash
./scripts/restore.sh
```

### **Automate Daily Backup (Crontab)**
```bash
crontab -e
```
Add this line at the bottom to run the backup daily at 11:30 PM:
```
30 23 * * * /path/to/backup.sh
```

## Email Notifications
To enable email alerts, configure `configs/email.conf` with your SMTP settings.
Test email setup:
```bash
echo "Test email" | mail -s "Backup Test" your-email@example.com
```

## Logs & Troubleshooting
- Logs are stored in the `logs/` folder.
- To check recent logs:
  ```bash
  tail -f logs/backup.log
  ```

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
