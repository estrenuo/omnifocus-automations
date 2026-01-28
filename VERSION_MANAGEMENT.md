# Version Management Guide

This guide covers the version management scripts for OmniFocus plugins.

## Overview

Two scripts are provided for managing plugin versions:

1. **bump-version.sh** - Simple version bumping
2. **release.sh** - Complete release workflow (recommended)

Both scripts follow [Semantic Versioning](https://semver.org/):
- **Major** (1.0.0 → 2.0.0) - Breaking changes
- **Minor** (1.0.0 → 1.1.0) - New features, backwards compatible
- **Patch** (1.0.0 → 1.0.1) - Bug fixes, backwards compatible

## Quick Start

### Simple Version Bump

```bash
# Bump patch version for all plugins (1.0.0 → 1.0.1)
./bump-version.sh patch

# Bump minor version for all plugins (1.0.0 → 1.1.0)
./bump-version.sh minor

# Bump major version for all plugins (1.0.0 → 2.0.0)
./bump-version.sh major

# Bump specific plugin only
./bump-version.sh patch AI-Task-Clarifier
```

### Complete Release

```bash
# Full release workflow (recommended)
./release.sh patch

# Release without git tag
./release.sh minor --no-tag

# Release without iCloud sync
./release.sh patch --no-sync
```

## bump-version.sh

### Usage

```bash
./bump-version.sh <bump_type> [plugin_name]
```

**Bump types:**
- `major` - Breaking changes (1.0.0 → 2.0.0)
- `minor` - New features (1.0.0 → 1.1.0)
- `patch` - Bug fixes (1.0.0 → 1.0.1)

**Optional plugin_name:**
- If provided, only bumps that specific plugin
- If omitted, bumps all plugins

### What It Does

1. ✅ Extracts current version from plugin metadata
2. ✅ Calculates new version based on bump type
3. ✅ Updates version in plugin file(s)
4. ✅ Verifies update was successful
5. ✅ Optionally syncs to iCloud

### Examples

**Example 1: Patch all plugins**
```bash
$ ./bump-version.sh patch
========================================
OmniFocus Plugin Version Bumper
========================================

Bump type: patch
Plugins to update: 2

✓ AI-Task-Clarifier.omnifocusjs
  1.0.0 → 1.0.1
✓ JIRA-Import.omnifocusjs
  1.0.0 → 1.0.1

========================================
✓ Version Bump Complete!
========================================

Sync updated plugins to iCloud?
Press 'y' to sync, any other key to skip: y
```

**Example 2: Minor version for specific plugin**
```bash
$ ./bump-version.sh minor AI-Task-Clarifier
========================================
OmniFocus Plugin Version Bumper
========================================

Bump type: minor
Plugins to update: 1

✓ AI-Task-Clarifier.omnifocusjs
  1.0.1 → 1.1.0

========================================
✓ Version Bump Complete!
========================================
```

### When to Use

Use `bump-version.sh` when:
- You want a quick version bump
- You don't need to update the changelog
- You're doing local testing
- You want to bump versions independently

## release.sh

### Usage

```bash
./release.sh <bump_type> [--no-sync] [--no-tag]
```

**Bump types:**
- `major` - Breaking changes (1.0.0 → 2.0.0)
- `minor` - New features (1.0.0 → 1.1.0)
- `patch` - Bug fixes (1.0.0 → 1.0.1)

**Options:**
- `--no-sync` - Skip iCloud sync
- `--no-tag` - Skip git tag creation

### What It Does

1. ✅ Prompts for changelog entry
2. ✅ Shows release summary for confirmation
3. ✅ Updates version in all plugin files
4. ✅ Updates CHANGELOG.md with new entry
5. ✅ Syncs to iCloud (unless --no-sync)
6. ✅ Commits changes to git
7. ✅ Creates git tag (unless --no-tag)
8. ✅ Shows next steps

### Interactive Workflow

```bash
$ ./release.sh patch
========================================
OmniFocus Plugin Release
========================================

Current version: 1.0.0
New version: 1.0.1

Enter changelog entry (press Ctrl+D when done):
Tip: Use markdown format. Example:
### Added
- New feature description
### Fixed
- Bug fix description

### Fixed
- Fixed temperature parameter error in AI Task Clarifier
- Improved error handling in JIRA Import
^D

========================================
Release Summary
========================================

Version: 1.0.0 → 1.0.1
Plugins to update: 2
Sync to iCloud: Yes
Create git tag: Yes

Changelog:
### Fixed
- Fixed temperature parameter error in AI Task Clarifier
- Improved error handling in JIRA Import

Proceed with release? (y/n) y

Processing...

✓ Updated AI-Task-Clarifier.omnifocusjs to v1.0.1
✓ Updated JIRA-Import.omnifocusjs to v1.0.1

Updating changelog...
✓ Changelog updated

Syncing to iCloud...
[sync output...]

Git operations...
✓ Changes committed
✓ Tag v1.0.1 created

========================================
✓ Release Complete!
========================================

Version: v1.0.1

Next steps:
  1. Test the plugins in OmniFocus
  2. Push changes: git push
  3. Push tags: git push --tags
```

### Changelog Format

Use markdown format with sections:

```markdown
### Added
- New feature 1
- New feature 2

### Changed
- Changed behavior 1

### Fixed
- Bug fix 1
- Bug fix 2

### Removed
- Removed feature 1
```

### When to Use

Use `release.sh` when:
- You're making an official release
- You want to update the changelog
- You want git commits and tags
- You want a complete workflow

## Semantic Versioning Guide

### When to Bump Major (X.0.0)

**Breaking changes that require user action:**
- Changed API key format
- Removed features
- Changed plugin identifiers
- Changed data structures
- Incompatible with previous versions

**Example:**
```bash
./release.sh major
```

**Changelog:**
```markdown
### Breaking Changes
- Changed plugin identifier format
- Removed deprecated features
- Updated to new Claude API version (requires new API key)
```

### When to Bump Minor (0.X.0)

**New features, backwards compatible:**
- Added new functionality
- Added new options
- Enhanced existing features
- New integrations

**Example:**
```bash
./release.sh minor
```

**Changelog:**
```markdown
### Added
- GitHub issue import
- Custom AI analysis profiles
- Scheduled automatic imports
```

### When to Bump Patch (0.0.X)

**Bug fixes, backwards compatible:**
- Fixed bugs
- Improved error handling
- Performance improvements
- Documentation updates

**Example:**
```bash
./release.sh patch
```

**Changelog:**
```markdown
### Fixed
- Fixed temperature parameter error
- Improved error messages
- Fixed duplicate import detection
```

## Best Practices

### 1. Always Test Before Release

```bash
# Bump version locally
./bump-version.sh patch

# Sync to iCloud
./sync-to-icloud.sh

# Test in OmniFocus
# ... test thoroughly ...

# If tests pass, do official release
./release.sh patch
```

### 2. Write Clear Changelog Entries

**Good:**
```markdown
### Fixed
- Fixed "temperature not supported" error in AI Task Clarifier when using Claude API
- Improved JIRA API error messages to show specific authentication issues
```

**Bad:**
```markdown
### Fixed
- Fixed bug
- Updated code
```

### 3. Use Conventional Commits

When the release script commits, it uses this format:
```
Release v1.0.1

### Fixed
- Fixed temperature parameter error
```

### 4. Tag Releases

Always create git tags for releases:
```bash
# Automatic with release.sh
./release.sh patch

# Or manual
git tag -a v1.0.1 -m "Release v1.0.1"
git push --tags
```

### 5. Keep Versions in Sync

Both plugins should have the same version number:
```bash
# Good - bumps both
./bump-version.sh patch

# Avoid - creates version mismatch
./bump-version.sh patch AI-Task-Clarifier
./bump-version.sh minor JIRA-Import
```

## Troubleshooting

### "Could not extract version"

**Problem:** Script can't find version in plugin file.

**Solution:** Check that plugin has version in metadata:
```javascript
/*{
    "version": "1.0.0",
    ...
}*/
```

### "Failed to update version"

**Problem:** sed command failed to update file.

**Solution:** Check file permissions:
```bash
chmod +w *.omnifocusjs
```

### "Tag already exists"

**Problem:** Git tag already exists for this version.

**Solution:** Delete the tag or use a different version:
```bash
# Delete tag
git tag -d v1.0.1
git push origin :refs/tags/v1.0.1

# Or bump to next version
./release.sh patch
```

### Changelog not updating

**Problem:** CHANGELOG.md not being updated correctly.

**Solution:** Check file exists and is writable:
```bash
touch CHANGELOG.md
chmod +w CHANGELOG.md
```

## Advanced Usage

### Custom Version Numbers

To set a specific version (not recommended):

```bash
# Edit plugin files manually
vim AI-Task-Clarifier.omnifocusjs
# Change: "version": "1.0.0" to "version": "2.0.0"

# Then sync
./sync-to-icloud.sh
```

### Dry Run

To see what would change without actually changing:

```bash
# Check current versions
grep '"version"' *.omnifocusjs

# Calculate new version manually
# Current: 1.0.0
# Patch: 1.0.1
# Minor: 1.1.0
# Major: 2.0.0
```

### Rollback

To rollback a version bump:

```bash
# Undo git commit
git reset --soft HEAD~1

# Or restore from git
git checkout HEAD~1 -- *.omnifocusjs CHANGELOG.md

# Sync to iCloud
./sync-to-icloud.sh
```

## Integration with CI/CD

### GitHub Actions Example

```yaml
name: Release

on:
  workflow_dispatch:
    inputs:
      bump_type:
        description: 'Version bump type'
        required: true
        type: choice
        options:
          - patch
          - minor
          - major

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Bump version
        run: ./bump-version.sh ${{ github.event.inputs.bump_type }}
      
      - name: Commit and push
        run: |
          git config user.name "GitHub Actions"
          git config user.email "actions@github.com"
          git add *.omnifocusjs
          git commit -m "Bump version"
          git push
```

## Summary

**For quick version bumps:**
```bash
./bump-version.sh patch
```

**For official releases:**
```bash
./release.sh patch
```

**Version numbering:**
- Major: Breaking changes
- Minor: New features
- Patch: Bug fixes

**Always:**
- Test before releasing
- Write clear changelog entries
- Keep versions in sync
- Tag releases in git

