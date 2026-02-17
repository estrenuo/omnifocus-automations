# Changelog

All notable changes to the OmniFocus plugins will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.7.0] - 2026-02-17

### Added
- **Project Selection Support**
  - AI Task Clarifier now analyzes both tasks and projects
  - AI Task Breakdown now creates tasks inside selected projects (not just subtasks of tasks)
  - Projects are sent to AI with `type: "project"` for context-aware analysis
  - System prompts updated to handle project containers differently from tasks
  - Falls back to scope selection when selected projects have no tasks

- **AI Task Breakdown Plugin**
  - New plugin for breaking down tasks into subtasks and projects into tasks
  - Select a project to generate top-level tasks for it
  - Select a task to generate subtasks within it
  - Creates 2-10 items depending on complexity
  - Tags created items with "AI: Suggested"

### Changed
- AI Task Clarifier analyzes project names for clarity, specificity, and whether they represent a clear outcome
- AI Task Breakdown `action.validate` now enables when tasks or projects are selected
- Scope selection option renamed to "Selected tasks/projects"
- Project findings applied via `project.task.addTag()` and `project.note`

## [1.0.0] - 2025-01-26

### Added
- **AI Task Clarifier Plugin**
  - Analyzes tasks using OpenAI GPT-5 to identify vague, non-actionable, or problematic tasks
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
- Uses OpenAI GPT-5 API (model: `gpt-5-2025-08-07`)
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

- **1.7.0** (2026-02-17) - Project selection support, AI Task Breakdown plugin
- **1.0.0** (2025-01-26) - Initial release with AI Task Clarifier and JIRA Import plugins

