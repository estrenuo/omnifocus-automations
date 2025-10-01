# OmniFocus Plugin Sync Scripts Guide

Two bash scripts are provided to sync plugins between this repository and your iCloud Drive OmniFocus Plug-Ins folder.

## Overview

### sync-to-icloud.sh
**Purpose**: Deploy plugins from repository → iCloud → OmniFocus

**When to use:**
- After editing plugins in this repository
- Initial setup/installation
- Deploying updates to OmniFocus
- Sharing plugins across devices via iCloud

### sync-from-icloud.sh
**Purpose**: Backup plugins from iCloud → repository

**When to use:**
- After editing plugins in OmniFocus Console
- Backing up modifications
- Saving changes to git
- Syncing changes made on another device

## Quick Start

### First Time Setup

1. **Make scripts executable** (already done if you cloned the repo):
```bash
chmod +x sync-to-icloud.sh sync-from-icloud.sh
```

2. **Deploy plugins to OmniFocus**:
```bash
./sync-to-icloud.sh
```

3. **Open OmniFocus** - plugins will be automatically loaded

### Regular Workflow

**Editing in Repository:**
```bash
# 1. Edit plugin files in your editor
vim AI-Task-Clarifier.omnifocusjs

# 2. Deploy to OmniFocus
./sync-to-icloud.sh

# 3. Test in OmniFocus
# Plugins are automatically reloaded
```

**Editing in OmniFocus:**
```bash
# 1. Edit in OmniFocus Console
# (Automation menu → Configure Plug-Ins → Edit)

# 2. Save changes back to repository
./sync-from-icloud.sh

# 3. Commit to git
git add *.omnifocusjs
git commit -m "Updated plugins"
```

## Detailed Usage

### sync-to-icloud.sh

**Basic usage:**
```bash
./sync-to-icloud.sh
```

**What it does:**
1. Checks if iCloud OmniFocus folder exists
2. Verifies all plugin files are present in repository
3. Compares each plugin with iCloud version
4. Copies only changed files
5. Shows summary of changes

**Output example:**
```
========================================
OmniFocus Plugin Sync to iCloud
========================================

✓ Found iCloud OmniFocus Plug-Ins folder
  Path: /Users/mpetters/Library/Mobile Documents/iCloud~com~omnigroup~OmniFocus/Documents/Plug-Ins

✓ All plugin files found in repository

Syncing plugins...

  ↻ AI-Task-Clarifier.omnifocusjs (updated)
  ≈ JIRA-Import.omnifocusjs (no changes)

========================================
✓ Sync Complete!
========================================

Summary:
  Total plugins: 2
  New: 0
  Updated: 1
  Unchanged: 1

Note: OmniFocus will automatically detect the changes.
If OmniFocus is running, the plugins will be reloaded.

Plugins synced to:
  /Users/mpetters/Library/Mobile Documents/iCloud~com~omnigroup~OmniFocus/Documents/Plug-Ins
```

**Status indicators:**
- `+` (green) - New plugin added
- `↻` (yellow) - Plugin updated
- `≈` (blue) - No changes

### sync-from-icloud.sh

**Basic usage:**
```bash
./sync-from-icloud.sh
```

**What it does:**
1. Checks if iCloud OmniFocus folder exists
2. Verifies plugin files exist in iCloud
3. Compares each plugin with repository version
4. Copies only changed files
5. Warns about updates (so you can review before committing)

**Output example:**
```
========================================
OmniFocus Plugin Sync from iCloud
========================================

✓ Found iCloud OmniFocus Plug-Ins folder
  Path: /Users/mpetters/Library/Mobile Documents/iCloud~com~omnigroup~OmniFocus/Documents/Plug-Ins

Syncing plugins from iCloud...

  ↻ AI-Task-Clarifier.omnifocusjs (updated from iCloud)
  ≈ JIRA-Import.omnifocusjs (no changes)

========================================
✓ Sync Complete!
========================================

Summary:
  Total plugins checked: 2
  Synced: 2
  New: 0
  Updated: 1
  Unchanged: 1
  Skipped: 0

⚠ Warning: 1 file(s) were updated from iCloud
Review the changes before committing to git:
  git diff

Plugins synced from:
  /Users/mpetters/Library/Mobile Documents/iCloud~com~omnigroup~OmniFocus/Documents/Plug-Ins
To repository:
  /Users/mpetters/code/omnifocus-automations
```

## iCloud Drive Path

The scripts use a portable path that works for any user:
```bash
/Users/$USER/Library/Mobile Documents/iCloud~com~omnigroup~OmniFocus/Documents/Plug-Ins
```

**Your actual path:**
```
/Users/mpetters/Library/Mobile Documents/iCloud~com~omnigroup~OmniFocus/Documents/Plug-Ins
```

## Troubleshooting

### "iCloud Drive OmniFocus Plug-Ins folder not found"

**Possible causes:**
1. iCloud Drive is not enabled
2. OmniFocus is not syncing to iCloud
3. OmniFocus hasn't created the Plug-Ins folder yet

**Solutions:**
1. Open OmniFocus → Settings/Preferences
2. Enable iCloud sync if not already enabled
3. Install at least one plugin manually to create the folder:
   - Double-click a `.omnifocusjs` file
   - Or use Automation menu → Configure Plug-Ins → Add

### "Missing plugin files"

**For sync-to-icloud.sh:**
- Make sure you're running the script from the repository directory
- Verify `.omnifocusjs` files exist in current directory

**For sync-from-icloud.sh:**
- Run `./sync-to-icloud.sh` first to copy plugins to iCloud
- Or install plugins manually in OmniFocus

### Scripts not executable

```bash
chmod +x sync-to-icloud.sh sync-from-icloud.sh
```

### iCloud sync is slow

iCloud Drive can take a few seconds to sync files. If you don't see changes immediately:
1. Wait 10-30 seconds
2. Check iCloud sync status in Finder
3. Restart OmniFocus if needed

## Advanced Usage

### Adding New Plugins

Edit the `PLUGINS` array in both scripts:

```bash
# In sync-to-icloud.sh and sync-from-icloud.sh
PLUGINS=(
    "AI-Task-Clarifier.omnifocusjs"
    "JIRA-Import.omnifocusjs"
    "My-New-Plugin.omnifocusjs"  # Add your plugin here
)
```

### Custom iCloud Path

If your iCloud path is different, edit the scripts:

```bash
# Change this line in both scripts
ICLOUD_PLUGINS_DIR="/Users/$USER/Library/Mobile Documents/iCloud~com~omnigroup~OmniFocus/Documents/Plug-Ins"

# To your custom path
ICLOUD_PLUGINS_DIR="/path/to/your/custom/location"
```

### Dry Run (Preview Changes)

To see what would change without actually copying:

```bash
# Add this after the comparison in the script
if cmp -s "$source_file" "$dest_file"; then
    echo "  ≈ $plugin (no changes)"
else
    echo "  ↻ $plugin (would be updated)"
    # Comment out the cp command:
    # cp "$source_file" "$dest_file"
fi
```

### Automated Sync

Add to crontab for automatic syncing:

```bash
# Edit crontab
crontab -e

# Add line to sync every hour
0 * * * * cd /Users/mpetters/code/omnifocus-automations && ./sync-to-icloud.sh > /dev/null 2>&1
```

Or use launchd for more control (create a plist file).

## Integration with Git

### Recommended Workflow

```bash
# 1. Make changes to plugins
vim AI-Task-Clarifier.omnifocusjs

# 2. Deploy to OmniFocus for testing
./sync-to-icloud.sh

# 3. Test in OmniFocus
# ... test the plugin ...

# 4. If you made changes in OmniFocus, sync back
./sync-from-icloud.sh

# 5. Review changes
git diff

# 6. Commit
git add *.omnifocusjs
git commit -m "Fixed temperature parameter in AI Task Clarifier"

# 7. Push
git push
```

### Pre-commit Hook

Create `.git/hooks/pre-commit`:

```bash
#!/bin/bash
# Sync from iCloud before committing to ensure latest version

cd "$(git rev-parse --show-toplevel)"
./sync-from-icloud.sh

# Add any updated plugins to the commit
git add *.omnifocusjs
```

Make it executable:
```bash
chmod +x .git/hooks/pre-commit
```

## Script Features

### Safety Features
- ✅ Compares files before copying (no unnecessary writes)
- ✅ Validates paths exist before proceeding
- ✅ Clear error messages with suggestions
- ✅ Non-destructive (never deletes files)
- ✅ Shows what changed before committing

### User Experience
- ✅ Color-coded output (green=success, yellow=warning, red=error)
- ✅ Clear status indicators (+/↻/≈/-)
- ✅ Summary statistics
- ✅ Helpful error messages
- ✅ Portable (works for any user)

### Performance
- ✅ Fast (only copies changed files)
- ✅ Efficient (uses `cmp` for comparison)
- ✅ Minimal output (only shows relevant info)

## Examples

### Example 1: Initial Setup
```bash
$ ./sync-to-icloud.sh
========================================
OmniFocus Plugin Sync to iCloud
========================================

✓ Found iCloud OmniFocus Plug-Ins folder
✓ All plugin files found in repository

Syncing plugins...

  + AI-Task-Clarifier.omnifocusjs (new)
  + JIRA-Import.omnifocusjs (new)

========================================
✓ Sync Complete!
========================================

Summary:
  Total plugins: 2
  New: 2
  Updated: 0
  Unchanged: 0
```

### Example 2: After Editing One Plugin
```bash
$ ./sync-to-icloud.sh
...
Syncing plugins...

  ↻ AI-Task-Clarifier.omnifocusjs (updated)
  ≈ JIRA-Import.omnifocusjs (no changes)

Summary:
  Total plugins: 2
  New: 0
  Updated: 1
  Unchanged: 1
```

### Example 3: No Changes
```bash
$ ./sync-to-icloud.sh
...
Syncing plugins...

  ≈ AI-Task-Clarifier.omnifocusjs (no changes)
  ≈ JIRA-Import.omnifocusjs (no changes)

Summary:
  Total plugins: 2
  New: 0
  Updated: 0
  Unchanged: 2
```

## Tips

1. **Always sync before editing**: Run `./sync-from-icloud.sh` before making changes to ensure you have the latest version

2. **Test before committing**: Deploy with `./sync-to-icloud.sh` and test in OmniFocus before committing to git

3. **Use git diff**: After syncing from iCloud, review changes with `git diff` before committing

4. **Backup regularly**: Commit plugin changes to git frequently to avoid losing work

5. **Multiple devices**: If you edit on multiple devices, always sync from iCloud before making new changes

## Support

If you encounter issues:
1. Check the troubleshooting section above
2. Verify iCloud sync is working in Finder
3. Check OmniFocus sync settings
4. Review script output for specific error messages

