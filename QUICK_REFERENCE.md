# Quick Reference Card

## Essential Commands

### Backup Operations

```bash
# Run manual backup
./scripts/backup.sh

# Run test backup (with confirmation)
./scripts/test_backup.sh

# Restore from backup (⚠️ CAUTION: Overwrites local files)
./scripts/restore.sh
```

### View Logs

```bash
# List all logs (newest first)
ls -lt logs/

# View most recent backup log
tail -100 logs/backup_*.log

# View most recent 5 logs
ls -lt logs/ | head -6

# Follow live backup log (during backup)
tail -f logs/backup_$(date +%Y-%m-%d)*.log
```

### Configuration

```bash
# Edit backup settings (sources, remote, mode)
nano configs/backup.conf

# Edit email settings
nano configs/email.conf

# View current configuration
cat configs/backup.conf
```

### Rclone Commands

```bash
# List configured remotes
rclone listremotes

# Test remote connection
rclone lsd mygdrive:

# List files in backup location
rclone ls mygdrive:Backups/rclone-backup-suite/

# Check backup size
rclone size mygdrive:Backups/rclone-backup-suite/

# Manually sync a directory
rclone sync /local/path mygdrive:remote/path --progress
```

### Cron Automation

```bash
# View cron schedule
crontab -l

# Edit cron schedule
crontab -e

# View cron logs
grep CRON /var/log/syslog | tail -20

# Check cron service status
sudo systemctl status cron
```

### Email Testing

```bash
# Send test email
echo "Test message" | mail -s "Test Subject" your-email@example.com

# Check mail logs
sudo tail -f /var/log/mail.log

# View mail queue
mailq
```

### System Checks

```bash
# Check disk space
df -h

# Check rclone version
rclone version

# Check if scripts are executable
ls -l scripts/

# Make scripts executable (if needed)
chmod +x scripts/*.sh

# Check system mail setup
which mail
```

## Configuration File Quick Edit

### configs/backup.conf

```bash
# Key settings to customize:
SOURCE_DIRS=(          # Directories to backup
  "/home/user/Documents"
  "/home/user/Pictures"
)
REMOTE_NAME="mygdrive" # Your rclone remote name
REMOTE_PATH="Backups"  # Destination path on cloud
BACKUP_MODE="sync"     # "sync" or "copy"
RETENTION_DAYS=7       # Days to keep logs
```

### configs/email.conf

```bash
# Key settings:
EMAIL_RECIPIENT="your-email@example.com"
EMAIL_SUBJECT_SUCCESS="Backup Successful"
EMAIL_SUBJECT_FAILURE="Backup Failed"
```

## Cron Schedule Examples

```bash
# Every day at 2:00 AM
0 2 * * * /path/to/rclone-backup-suite/scripts/backup.sh

# Every day at 11:30 PM
30 23 * * * /path/to/rclone-backup-suite/scripts/backup.sh

# Twice daily: 6 AM and 6 PM
0 6,18 * * * /path/to/rclone-backup-suite/scripts/backup.sh

# Every Sunday at midnight
0 0 * * 0 /path/to/rclone-backup-suite/scripts/backup.sh

# Every 6 hours
0 */6 * * * /path/to/rclone-backup-suite/scripts/backup.sh
```

## Troubleshooting Quick Fixes

### Problem: "Remote not found"

```bash
# Solution: Check remote name
rclone listremotes
# Update configs/backup.conf with correct name
```

### Problem: "Source directory not found"

```bash
# Solution: Verify directory exists
ls -la /path/to/directory
# Update configs/backup.conf with correct path
```

### Problem: "Permission denied"

```bash
# Solution: Make scripts executable
chmod +x scripts/*.sh
```

### Problem: Email not arriving

```bash
# Solution 1: Check spam folder
# Solution 2: Test mail command
echo "test" | mail -s "test" your@email.com
# Solution 3: Check mail logs
sudo tail -f /var/log/mail.log
```

### Problem: Cron job not running

```bash
# Solution 1: Check cron service
sudo systemctl status cron

# Solution 2: View cron logs
grep CRON /var/log/syslog | tail -20

# Solution 3: Use full paths in crontab
# Bad:  0 2 * * * ./scripts/backup.sh
# Good: 0 2 * * * /home/user/rclone-backup-suite/scripts/backup.sh
```

### Problem: Backup running slow

```bash
# Check internet speed
speedtest-cli

# Check what files are being transferred
rclone ls mygdrive:path --max-depth 1

# Use bandwidth limit (in KB/s)
# Edit backup.sh and add to rclone command:
--bwlimit 1000  # Limit to 1 MB/s
```

## File Locations

```
rclone-backup-suite/
├── scripts/
│   ├── backup.sh         # Main backup script
│   ├── restore.sh        # Restore script
│   ├── setup.sh          # Initial setup script
│   └── test_backup.sh    # Test backup script
├── configs/
│   ├── backup.conf       # Backup configuration
│   └── email.conf        # Email configuration
├── logs/
│   └── backup_*.log      # Timestamped log files
├── README.md             # Main documentation
├── SETUP_GUIDE.md        # Detailed setup guide
└── QUICK_REFERENCE.md    # This file
```

## Status Indicators

### In Log Files

```
[INFO]    - Informational message
[SUCCESS] - Operation completed successfully
[ERROR]   - Something went wrong
[WARNING] - Potential issue detected
```

### Exit Codes

```
0  - Success
1  - Error occurred
130 - User cancelled (Ctrl+C)
```

## Emergency Commands

### Stop running backup

```bash
# Find backup process
ps aux | grep backup.sh

# Kill process (replace PID)
kill PID

# Force kill if necessary
kill -9 PID
```

### Quick restore test

```bash
# Restore to temporary location (safer)
rclone copy mygdrive:Backups/folder /tmp/restore-test/
ls -la /tmp/restore-test/
```

### Check cloud storage quota

```bash
# Google Drive
rclone about mygdrive:

# Generic check
rclone size mygdrive:Backups/
```

## Performance Tips

1. **Use copy mode** for large backups: `BACKUP_MODE="copy"`
2. **Exclude unnecessary files**: Add `--exclude` flags to rclone commands
3. **Bandwidth limits**: Add `--bwlimit` during business hours
4. **Compress before upload**: Add `--compress` flag
5. **Check file count first**: `rclone ls source/ | wc -l`

## Security Best Practices

1. Keep configs private: `chmod 600 configs/*.conf`
2. Use rclone encryption: Set up crypt remote for sensitive data
3. Regular restore tests: Test restore monthly
4. Monitor email alerts: Don't ignore failure emails
5. Check logs regularly: `tail logs/backup_*.log`
6. Verify backup integrity: Compare file counts periodically

## Getting Help

- Full guide: [SETUP_GUIDE.md](SETUP_GUIDE.md)
- Main docs: [README.md](README.md)
- Report issues: https://github.com/itswijay/rclone-backup-suite/issues
- Rclone docs: https://rclone.org/docs/

---

**Last Updated:** October 2025
