# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

OmniFocus automation plugins (`.omnifocusjs` files) that integrate with Claude AI and JIRA APIs. Plugins run in OmniFocus 4's Omni Automation JavaScript environment (not Node.js).

## Development Commands

```bash
# Deploy plugins to OmniFocus (iCloud sync)
./sync-to-icloud.sh

# Backup plugins from iCloud to repo
./sync-from-icloud.sh

# Version bump (updates metadata in plugin files)
./bump-version.sh patch|minor|major [plugin_name]

# Full release workflow (version bump + changelog + sync + git tag)
./release.sh patch|minor|major [--no-sync] [--no-tag]
```

**Testing:** Manual testing only. Open OmniFocus → Automation menu → Automation Console to view debug logs (`console.log` output).

## Plugin Architecture

Each `.omnifocusjs` file follows this structure:
```javascript
/*{ JSON metadata: type, targets, identifier, version, description, label }*/
(() => {
    const credentials = new Credentials();  // Keychain access
    const action = new PlugIn.Action(async function(selection, sender) {
        // Plugin logic with async/await for API calls
    });
    action.validate = function(selection, sender) { ... };
    return action;
})();
```

**Key OmniFocus APIs:**
- `Credentials` - macOS Keychain storage (`read()`, `write()`, `remove()`)
- `flattenedTasks` - All tasks in database
- `tags.byName()` - Find/create tags
- `Alert`, `Form` - UI dialogs
- `URL.FetchRequest` - HTTP requests (no fetch/axios)

## Credential Storage

- Anthropic: service `"anthropic"`, user `"api-key"`
- JIRA: service `"jira"` for email/token, `"jira-settings"` for domain

## Current Plugins

1. **AI-Task-Clarifier.omnifocusjs** - Analyzes tasks via Claude, tags problematic ones
2. **AI-Task-Breakdown.omnifocusjs** - Creates subtasks for complex tasks via Claude
3. **JIRA-Import.omnifocusjs** - Imports unresolved JIRA issues with full field mapping
