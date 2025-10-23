# rclone-backup-suite

A comprehensive automated backup solution for Linux/macOS that uses `rclone` to securely back up your files to cloud storage with email notifications and intelligent log management.

## Documentation

- **[Step-by-Step Setup Guide](SETUP_GUIDE.md)** - Complete walkthrough for first-time setup
- **[Quick Reference Card](QUICK_REFERENCE.md)** - Essential commands and troubleshooting tips
- **[Main Documentation](#overview)** - Feature overview and configuration (below)

## Overview

This script automates daily backups for multiple folders, supports cloud storage (Google Drive, Dropbox, OneDrive), and provides email notifications on success or failure. It includes error handling, logging, and optional encryption.

## Features

- **Multi-folder Backup** – Backup multiple directories in one go
- ☁ **Cloud Storage Support** – Works with Google Drive, Dropbox, OneDrive via `rclone`
- **Encryption Support** – Optional encryption using `rclone crypt`
- **Email Notifications** – Get notified about backup status via email
- **Logging & Error Handling** – Saves logs for each backup attempt
- **Automated Scheduling** – Configurable daily backups using `cron`
- **Incremental Backup** – Syncs only changed files to save space

## Enhanced Features

### **Smart Error Handling**

- Validates configuration files and required settings before running
- Checks if rclone remotes exist and are accessible
- Verifies source directories exist before attempting backup
- Provides clear error messages for troubleshooting

### **Safety Features**

- Confirmation prompts for potentially destructive operations (restore)
- Comprehensive logging with timestamps for audit trails
- Backup mode selection (sync vs copy) based on your needs
- Remote path validation to prevent accidental overwrites

### **Flexible Configuration**

- Automatic path detection and user-friendly setup
- Support for multiple backup modes (sync/copy)
- Configurable email notifications with customizable subject lines
- Automatic retention: old log files are cleaned up based on retention settings

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

### Quick Start

1. **Clone this repository**

   ```bash
   git clone https://github.com/itswijay/rclone-backup-suite.git
   cd rclone-backup-suite
   ```

2. **Run the setup script**

   ```bash
   ./scripts/setup.sh
   ```

   This will:

   - Install required dependencies (rclone, mailutils)
   - Make scripts executable
   - Create necessary directories
   - Configure rclone with your cloud storage
   - Update configuration files with your user paths

3. **Configure backup settings**
   Edit the `configs/backup.conf` file to customize your backup sources and destinations.

### Detailed Setup Guide

**New to this tool?** Check out our comprehensive **[Step-by-Step Setup Guide](SETUP_GUIDE.md)** that walks you through:

- Cloud storage configuration (Google Drive, Dropbox, OneDrive)
- Backup and email settings
- Testing and verification
- Automated scheduling with cron
- Troubleshooting common issues

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

# Retention settings (automatically delete log files older than 7 days)
RETENTION_DAYS=7
```

📌 **Explanation:**

- **`SOURCE_DIRS`** → List of local directories to back up
- **`REMOTE_NAME`** → Name of your cloud storage configured in `rclone config`
- **`REMOTE_PATH`** → Remote directory to store backups
- **`BACKUP_MODE`** → `"sync"` (mirror files) or `"copy"` (only add changes)
- **`RETENTION_DAYS`** → Automatically delete log files older than specified days (keeps backup history clean)

### **Example `email.conf` (Email Notifications)**

```ini
# Basic email recipient
EMAIL_RECIPIENT="your-email@example.com"

# Email subject templates
EMAIL_SUBJECT_SUCCESS="Backup Success"
EMAIL_SUBJECT_FAILURE="Backup Failure"

# SMTP Configuration (NOT CURRENTLY IMPLEMENTED - Placeholders for future use)
# Currently, the backup script uses the system's default 'mail' command.
# To use email notifications, ensure 'mailutils' or 'mailx' is installed.
# Advanced SMTP support may be added in future versions.
SMTP_SERVER=""
SMTP_PORT="587"
SMTP_USER=""
SMTP_PASS=""
```

📌 **Explanation:**

- **`EMAIL_RECIPIENT`** → Where to send backup notifications
- **`EMAIL_SUBJECT_SUCCESS`** → Custom subject line for successful backups
- **`EMAIL_SUBJECT_FAILURE`** → Custom subject line for failed backups
- **`SMTP_*`** → Placeholders for future SMTP implementation (currently not used)

**Note:** The script currently uses the system's built-in `mail` command. Make sure `mailutils` (Debian/Ubuntu) or `mailx` (CentOS/RHEL) is installed.

3. **Configure your settings**
   After running setup, customize your configuration:
   - Edit `configs/backup.conf` to set your source directories and remote settings
   - Edit `configs/email.conf` to set your email address for notifications
   - Test your setup with `./scripts/test_backup.sh`

## Usage

### **Test Backup (Recommended First)**

```bash
./scripts/test_backup.sh
```

This will run a test backup with confirmation prompts.

### **Run Backup Manually**

```bash
./scripts/backup.sh
```

### **Restore Backup**

```bash
./scripts/restore.sh
```

⚠️ **Warning**: This will overwrite local files. Use with caution!

### **Automate Daily Backup (Crontab)**

```bash
crontab -e
```

Add this line to run backup daily at 11:30 PM (replace with your actual path):

```
30 23 * * * /full/path/to/rclone-backup-suite/scripts/backup.sh
```

## Email Notifications

Email notifications are sent automatically after each backup attempt with customizable subject lines.

To enable email alerts:

1. Configure `configs/email.conf` with your email address
2. Customize the email subject lines if desired (`EMAIL_SUBJECT_SUCCESS` and `EMAIL_SUBJECT_FAILURE`)
3. Ensure the system mail command is configured (uses `mailutils` or `mailx`)

**Note:** The script currently uses the system's default `mail` command. Advanced SMTP configuration is not yet implemented but is planned for future versions.

Test email setup:

```bash
echo "Test email" | mail -s "Backup Test" your-email@example.com
```

## Logs & Troubleshooting

- Logs are stored in the `logs/` folder with timestamps (e.g., `logs/backup_2024-07-04_14-30-25.log`)
- Each backup and restore operation creates a separate log file
- To check the most recent log:
  ```bash
  ls -t logs/ | head -1 | xargs -I {} tail -f logs/{}
  ```
- Common issues:
  - **"Remote not found"**: Run `rclone config` to set up your cloud storage
  - **"Source directory not found"**: Check paths in `configs/backup.conf`
  - **"Permission denied"**: Ensure scripts are executable with `chmod +x scripts/*.sh`

**For more troubleshooting tips and commands**, see the **[Quick Reference Card](QUICK_REFERENCE.md)**.

## Additional Resources

- **[Detailed Setup Guide](SETUP_GUIDE.md)** - Step-by-step instructions for beginners
- **[Quick Reference](QUICK_REFERENCE.md)** - Command cheat sheet and troubleshooting
- **[Rclone Documentation](https://rclone.org/docs/)** - Official rclone docs

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
