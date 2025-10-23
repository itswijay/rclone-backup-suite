# Step-by-Step Setup Guide for rclone-backup-suite

This guide will walk you through the complete setup process for the rclone-backup-suite, from installation to your first automated backup.

---

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Initial Setup](#initial-setup)
3. [Configure Cloud Storage](#configure-cloud-storage)
4. [Configure Backup Settings](#configure-backup-settings)
5. [Configure Email Notifications](#configure-email-notifications)
6. [Test Your Setup](#test-your-setup)
7. [Automate with Cron](#automate-with-cron)
8. [Verification & Troubleshooting](#verification--troubleshooting)

---

## Prerequisites

Before starting, ensure you have:

- A Linux system (Ubuntu, Debian, CentOS, RHEL, Fedora, or macOS)
- Terminal/command line access
- `sudo` privileges (for installing dependencies)
- Internet connection
- Cloud storage account (Google Drive, Dropbox, OneDrive, etc.)

**Estimated Setup Time:** 15-20 minutes

---

## Step 1: Initial Setup

### 1.1 Clone the Repository

Open your terminal and run:

```bash
cd ~
git clone https://github.com/itswijay/rclone-backup-suite.git
cd rclone-backup-suite
```

**Expected Output:**

```
Cloning into 'rclone-backup-suite'...
remote: Enumerating objects: ...
```

### 1.2 Run the Setup Script

Execute the automated setup script:

```bash
./scripts/setup.sh
```

**What This Does:**

**Expected Prompts:**

- You may be asked for your `sudo` password

## Step 2: Configure Cloud Storage

### 2.1 Start Rclone Configuration

After the setup script completes, you'll be prompted to configure rclone. Press **Enter** to continue, or run manually:

```bash
rclone config
```

### 2.2 Choose Your Cloud Provider

Follow the interactive prompts:

#### For Google Drive:

1. Type `n` for **New remote**
2. Enter a name (e.g., `mygdrive`) — **Remember this name!**
3. Choose storage type: Find and select **Google Drive** (usually option `15` or `drive`)
4. Leave `client_id` blank (press Enter)
5. Leave `client_secret` blank (press Enter)
6. Scope: Choose `1` (Full access)
7. Leave `root_folder_id` blank (press Enter)
8. Leave `service_account_file` blank (press Enter)
9. Auto config: Type `y` if on desktop, `n` if on headless server
10. Follow browser authentication
11. Configure as Team Drive: Type `n`
12. Confirm: Type `y`
13. Quit: Type `q`

#### For Dropbox:

1. Type `n` for **New remote**
2. Enter a name (e.g., `mydropbox`)
3. Choose storage type: Find and select **Dropbox** (usually option `11` or `dropbox`)
4. Leave `client_id` blank (press Enter)
5. Leave `client_secret` blank (press Enter)
6. Auto config: Type `y`
7. Follow browser authentication
8. Confirm: Type `y`
9. Quit: Type `q`

#### For OneDrive:

1. Type `n` for **New remote**
2. Enter a name (e.g., `myonedrive`)
3. Choose storage type: Find and select **OneDrive** (usually option `26` or `onedrive`)
4. Leave `client_id` blank (press Enter)
5. Leave `client_secret` blank (press Enter)
6. Choose region (usually option `1` for OneDrive Personal)
7. Auto config: Type `y`
8. Follow browser authentication
9. Choose drive type (usually option `1` for Personal)
10. Confirm: Type `y`
11. Quit: Type `q`

### 2.3 Verify Rclone Setup

Test that your remote is configured correctly:

```bash
rclone listremotes
```

**Expected Output:**

```
mygdrive:
```

Test connectivity:

```bash
rclone lsd mygdrive:
```

This should list folders in your cloud storage without errors.

---

## Step 3: Configure Backup Settings

### 3.1 Edit the Backup Configuration

Open the backup configuration file:

```bash
nano configs/backup.conf
```

Or use your preferred editor (`vim`, `gedit`, etc.)

### 3.2 Set Your Source Directories

Update the `SOURCE_DIRS` array with the folders you want to back up:

```bash
SOURCE_DIRS=(
  "/home/yourusername/Documents"
  "/home/yourusername/Pictures"
  "/home/yourusername/Projects"
  "/home/yourusername/Videos"
)
```

**Tips:**

- Use absolute paths (starting with `/`)
- Add as many directories as needed
- Each path should be in quotes
- Paths are separated by newlines

### 3.3 Set Your Remote Name

Update the `REMOTE_NAME` to match what you configured in Step 2:

```bash
REMOTE_NAME="mygdrive"  # Change this to your remote name
```

### 3.4 Set Your Remote Path

Choose where to store backups on your cloud storage:

```bash
REMOTE_PATH="Backups/rclone-backup-suite"
```

**This will create:** `YourCloudStorage/Backups/rclone-backup-suite/`

### 3.5 Choose Backup Mode

```bash
BACKUP_MODE="sync"  # Options: "sync" or "copy"
```

**Options:**

- `sync` - **Mirror mode**: Keeps cloud storage identical to local (deletes files on cloud if deleted locally)
- `copy` - **Incremental mode**: Only uploads new/changed files (never deletes from cloud)

**Recommendation:** Use `"copy"` for safer backups if you're unsure.

### 3.6 Set Retention Period

```bash
RETENTION_DAYS=7  # Keep logs for 7 days
```

This automatically deletes old log files (not your backups) after the specified days.

### 3.7 Save and Exit

- **nano**: Press `Ctrl+X`, then `Y`, then `Enter`
- **vim**: Press `Esc`, type `:wq`, press `Enter`

---

## Step 4: Configure Email Notifications

### 4.1 Edit Email Configuration

Open the email configuration file:

```bash
nano configs/email.conf
```

### 4.2 Set Your Email Address

```bash
EMAIL_RECIPIENT="your-email@example.com"
```

Replace with your actual email address.

### 4.3 Customize Email Subjects (Optional)

```bash
EMAIL_SUBJECT_SUCCESS="Backup Successful"
EMAIL_SUBJECT_FAILURE="Backup Failed - Action Required"
```

### 4.4 Save and Exit

### 4.5 Install and Configure Mail Utility

#### On Ubuntu/Debian:

```bash
sudo apt update
sudo apt install mailutils -y
```

During installation, choose **"Local only"** when prompted.

#### On CentOS/RHEL/Fedora:

```bash
sudo yum install mailx -y
# or
sudo dnf install mailx -y
```

### 4.6 Test Email Setup

```bash
echo "Test email from rclone-backup-suite" | mail -s "Backup Test" your-email@example.com
```

**Check your email inbox** (and spam folder) for the test message.

**Troubleshooting:**

- If email doesn't arrive, check system mail logs: `tail -f /var/log/mail.log`
- Ensure your system's hostname is properly configured
- Some mail servers require additional configuration

---

## Step 5: Test Your Setup

### 5.1 Run Test Backup

Execute the test backup script:

```bash
./scripts/test_backup.sh
```

**Expected Prompts:**

```
[INFO] Running test backup...
[INFO] This will perform a real backup operation.

Continue? (y/N):
```

Type `y` and press `Enter`.

### 5.2 Monitor the Backup

Watch the output for:

- `[INFO] Starting backup at ...`
- `[INFO] Backing up /path/to/directory ...`
- Progress bars showing file transfers
- `[SUCCESS] Successfully backed up ...`
- `[SUCCESS] Backup completed successfully.`

### 5.3 Verify Backup in Cloud Storage

Check your cloud storage manually:

- **Google Drive**: Visit https://drive.google.com
- **Dropbox**: Visit https://www.dropbox.com
- **OneDrive**: Visit https://onedrive.live.com

Navigate to `Backups/rclone-backup-suite/` and verify your folders are there.

### 5.4 Check Log Files

View the most recent log:

```bash
ls -lt logs/
cat logs/backup_*.log | tail -50
```

Look for successful completion messages.

### 5.5 Verify Email Notification

Check your email for a backup success notification.

---

## Step 6: Automate with Cron

### 6.1 Open Crontab Editor

```bash
crontab -e
```

**First time?** You'll be asked to choose an editor:

- Choose `1` for nano (easiest for beginners)
- Or `2` for vim

### 6.2 Add Backup Schedule

Add this line at the bottom of the file:

```bash
# Daily backup at 11:30 PM
30 23 * * * /home/yourusername/rclone-backup-suite/scripts/backup.sh
```

**Important:** Replace `/home/yourusername/` with your actual path!

To find your full path:

```bash
pwd
```

**Other Schedule Examples:**

```bash
# Every day at 2:00 AM
0 2 * * * /full/path/to/rclone-backup-suite/scripts/backup.sh

# Every day at 6:00 PM
0 18 * * * /full/path/to/rclone-backup-suite/scripts/backup.sh

# Twice daily: 6 AM and 6 PM
0 6,18 * * * /full/path/to/rclone-backup-suite/scripts/backup.sh

# Every Sunday at midnight
0 0 * * 0 /full/path/to/rclone-backup-suite/scripts/backup.sh
```

**Cron Time Format:**

```
* * * * * command
│ │ │ │ │
│ │ │ │ └─── Day of week (0-7, Sun=0 or 7)
│ │ │ └───── Month (1-12)
│ │ └─────── Day of month (1-31)
│ └───────── Hour (0-23)
└─────────── Minute (0-59)
```

### 6.3 Save and Exit

- **nano**: `Ctrl+X`, then `Y`, then `Enter`
- **vim**: `Esc`, `:wq`, `Enter`

### 6.4 Verify Cron Job

```bash
crontab -l
```

You should see your backup schedule listed.

---

## Step 7: Verification & Troubleshooting

### 7.1 Common Issues and Solutions

#### "Remote not found" Error

**Solution:**

```bash
rclone listremotes
```

Verify your remote name matches what's in `configs/backup.conf`

#### "Source directory not found" Error

**Solution:**
Check that paths in `configs/backup.conf` exist:

```bash
ls -la /home/yourusername/Documents
```

#### "Permission denied" Error

**Solution:**

```bash
chmod +x scripts/*.sh
```

#### Email Not Arriving

**Solutions:**

1. Check spam folder
2. Verify email address in `configs/email.conf`
3. Test mail command: `echo "test" | mail -s "test" your@email.com`
4. Check mail logs: `sudo tail -f /var/log/mail.log`

#### Cron Job Not Running

**Solutions:**

1. Check cron logs: `grep CRON /var/log/syslog`
2. Verify cron service: `sudo systemctl status cron`
3. Check for errors in script logs: `ls -lt logs/`

### 7.2 Useful Commands

**View recent logs:**

```bash
ls -lt logs/ | head -5
tail -100 logs/backup_*.log
```

**Manual backup run:**

```bash
./scripts/backup.sh
```

**Check disk space:**

```bash
df -h
```

**Check rclone version:**

```bash
rclone version
```

**List files in cloud storage:**

```bash
rclone ls mygdrive:Backups/rclone-backup-suite/
```

### 7.3 Testing Restore

To test file restoration (⚠️ **CAUTION**: This overwrites local files):

```bash
./scripts/restore.sh
```

**Recommendation:** Test restore in a safe directory first!

---

## Setup Complete!

Your rclone-backup-suite is now fully configured and automated!

### What Happens Now?

1. Backups run automatically according to your cron schedule
2. You receive email notifications after each backup
3. Logs are automatically cleaned up after `RETENTION_DAYS`
4. Your data is safely stored in the cloud

### Next Steps

- Watch for your first automated backup email
- Periodically check logs: `ls -lt logs/`
- Monitor cloud storage space usage
- Test restore procedure in a safe environment

### Getting Help

- Read the main [README.md](README.md) for detailed information
- Check logs in the `logs/` directory
- Report issues on GitHub: https://github.com/itswijay/rclone-backup-suite/issues

---

## Quick Reference Card

```bash
# Run manual backup
./scripts/backup.sh

# Run test backup
./scripts/test_backup.sh

# Restore from backup (⚠️ CAUTION)
./scripts/restore.sh

# View recent logs
ls -lt logs/

# Edit backup settings
nano configs/backup.conf

# Edit email settings
nano configs/email.conf

# Check cron schedule
crontab -l

# Edit cron schedule
crontab -e

# Test rclone connection
rclone lsd mygdrive:

# List remote files
rclone ls mygdrive:Backups/
```

---

**Happy Backing Up!**

_Last Updated: October 2025_
