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

