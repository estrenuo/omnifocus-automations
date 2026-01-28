# Changelog

All notable changes to the OmniFocus plugins will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-01-26

### Added
- **AI Task Clarifier Plugin**
  - Analyzes tasks using Claude AI to identify vague, non-actionable, or problematic tasks
  - Provides specific improvement suggestions with severity levels
  - Auto-tags problematic tasks with "AI Review"
  - Flags high-severity issues automatically
  - Supports analyzing selected tasks, all tasks, or tasks older than 30 days
  - Comprehensive debug logging for troubleshooting
  - Built-in credential management for easy API key updates

- **JIRA Import Plugin**
  - Imports all unresolved JIRA issues as OmniFocus tasks
  - Comprehensive field mapping (summary, description, priority, type, labels, components, due dates)
  - Creates organized folder/project structure (JIRA folder → JIRA Issues project)
  - Prevents duplicate imports by checking for existing JIRA keys
  - Auto-creates tags for priorities, issue types, labels, and components
  - Preserves JIRA metadata (assignee, reporter, dates) in task notes
  - Includes clickable JIRA URLs
  - Comprehensive debug logging for troubleshooting
  - Built-in credential management for easy credential updates

- **Sync Scripts**
  - `sync-to-icloud.sh` - Deploy plugins from repository to iCloud OmniFocus Plug-Ins folder
  - `sync-from-icloud.sh` - Backup plugins from iCloud to repository
  - Color-coded output showing what changed (new/updated/unchanged)
  - Safe file comparison before copying
  - Portable using `$USER` variable

- **Version Management Scripts**
  - `bump-version.sh` - Bump plugin versions (major/minor/patch)
  - `release.sh` - Complete release workflow (version bump, changelog, sync, git tag)
  - Automatic changelog generation
  - Git integration for commits and tags

- **Documentation**
  - Complete API primer for OmniFocus JavaScript API
  - Detailed setup guide with troubleshooting
  - Technical reference with API details and field mappings
  - Debug logging guide
  - Credential management guide
  - Sync scripts guide
  - Editor setup guide (Neovim, VS Code, and more)
  - Testing checklist

- **Editor Support**
  - Neovim configuration for `.omnifocusjs` syntax highlighting
  - `.gitattributes` for GitHub/GitLab syntax highlighting
  - Instructions for VS Code, Sublime Text, Vim, Emacs, and more

### Security
- All credentials stored securely in macOS Keychain
- API keys and tokens redacted in debug logs
- HTTPS-only API communication
- No sensitive data in error messages

### Technical
- Uses Claude AI API (model: `claude-sonnet-4-20250514`)
- Uses JIRA REST API v3
- Supports OmniFocus 4 on macOS and iOS/iPadOS
- Cross-platform JavaScript (ES6+)
- Async/await for API calls
- Comprehensive error handling

## [Unreleased]

### Planned Features
- Bidirectional JIRA sync (update JIRA from OmniFocus)
- GitHub issue import
- AI-powered task breakdown (auto-create subtasks)
- Scheduled automatic imports
- Custom AI analysis profiles
- Export analysis reports
- Linear, Asana, Trello integrations

---

## Version History

- **1.0.0** (2025-01-26) - Initial release with AI Task Clarifier and JIRA Import plugins

