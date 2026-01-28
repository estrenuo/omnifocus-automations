# OmniFocus Automation Plugins

Two powerful OmniFocus plugins that integrate AI and JIRA to supercharge your task management workflow.

## Quick Start

1. **Install plugins**: Double-click the `.omnifocusjs` files
2. **Configure credentials**: Run each plugin once to enter API keys
3. **Start automating**: Access via OmniFocus Automation menu

## What's Included

### 1. AI Task Clarifier (`AI-Task-Clarifier.omnifocusjs`)
Analyzes your tasks using Claude AI to identify and fix problems.

### 2. AI Task Breakdown (`AI-Task-Breakdown.omnifocusjs`)
Breaks down complex tasks into actionable subtasks using Claude AI.

### 3. JIRA Import (`JIRA-Import.omnifocusjs`)
Imports all open JIRA issues as OmniFocus tasks with full field mapping.

---

### AI Task Clarifier

**Features:**
- Identifies vague or non-actionable tasks
- Detects tasks that need breaking down
- Flags stale tasks (old with no progress)
- Finds missing context or ambiguous tasks
- Provides specific improvement suggestions
- Auto-tags problematic tasks for review
- Flags high-severity issues
- Built-in credential management (easy to update API key)
- Comprehensive debug logging for troubleshooting

**Example Output:**
```
Task: "Review PR" [Tagged: AI: Needs Improvement]
Note includes formatted suggestion with issue type, severity, and actionable advice
```

### AI Task Breakdown

**Features:**
- Creates MINIMUM necessary subtasks (typically 2-5)
- Succinct bullet-point style (no full sentences)
- AI determines optimal number of steps
- Up to 10 subtasks for very complex tasks
- Tags subtasks with "AI: Suggested"
- Adds breakdown note to parent task
- Built-in credential management
- Comprehensive debug logging

**Example:**
```
Task: "Go get a haircut"

AI creates 3 subtasks:
  - Find and book appointment at barbershop [AI: Suggested]
  - Add to calendar with travel time [AI: Suggested]
  - Get haircut [AI: Suggested]

Task: "Launch new website"

AI creates 6 subtasks:
  - Complete final QA testing on staging [AI: Suggested]
  - Get stakeholder approval for launch [AI: Suggested]
  - Prepare deployment and rollback plan [AI: Suggested]
  - Deploy to production and verify [AI: Suggested]
  - Update DNS and SSL certificates [AI: Suggested]
  - Monitor for 24hrs and send announcement [AI: Suggested]
```

### JIRA Import

**Features:**
- Imports all unresolved JIRA issues
- Maps priorities, types, labels, and components to tags
- Preserves JIRA metadata (assignee, reporter, dates)
- Sets due dates from JIRA
- Prevents duplicate imports
- Organizes in dedicated JIRA folder/project
- Includes clickable JIRA URLs
- Built-in credential management (easy to update credentials)
- Comprehensive debug logging for troubleshooting

**Example Task:**
```
[PROJ-123] Fix login bug
Tags: JIRA, Priority: High, Type: Bug, frontend
Note:
  JIRA: PROJ-123
  URL: https://company.atlassian.net/browse/PROJ-123
  Status: In Progress
  Assignee: John Doe
  ...
```

## Requirements

### AI Task Clarifier / AI Task Breakdown
- Anthropic API key
- Active internet connection
- OmniFocus 4 (macOS or iOS)

### JIRA Import
- JIRA Cloud account
- JIRA API token
- Active internet connection
- OmniFocus 4 (macOS or iOS)

## Installation

### Quick Install (Using Sync Script)

If you're using iCloud sync with OmniFocus:

```bash
# Copy plugins to iCloud OmniFocus Plug-Ins folder
./sync-to-icloud.sh
```

The plugins will automatically appear in OmniFocus!

### Manual Installation

### Step 1: Get API Credentials

**Anthropic API Key:**
1. Visit https://console.anthropic.com/
2. Create an account or sign in
3. Navigate to API Keys
4. Create a new key
5. Copy and save it securely

**JIRA API Token:**
1. Visit https://id.atlassian.com/manage-profile/security/api-tokens
2. Click "Create API token"
3. Name it (e.g., "OmniFocus")
4. Copy and save it securely

### Step 2: Install Plugins

**Easiest Method:**
1. Double-click each `.omnifocusjs` file
2. Click "Install" when prompted

**Alternative Methods:**
- Drag and drop onto OmniFocus window (macOS)
- Use Automation menu → Configure Plug-Ins → Add

### Step 3: Configure

**First run of each plugin:**
1. Click Automation menu → Select plugin
2. Enter your credentials when prompted
3. Credentials are securely stored in macOS Keychain

## Usage

### AI Task Clarifier

**Analyze Selected Tasks:**
1. Select tasks in OmniFocus
2. Automation menu → "AI Task Clarifier"
3. Review results

**Analyze All Tasks:**
1. Don't select anything
2. Automation menu → "AI Task Clarifier"
3. Choose scope (all tasks, or tasks older than 30 days)
4. Review results

**Results:**
- Problematic tasks tagged "AI Review"
- High-severity issues flagged
- Suggestions added to task notes

### JIRA Import

**Import Issues:**
1. Automation menu → "Import JIRA Issues"
2. Wait for import to complete
3. Check "JIRA Issues" project in "JIRA" folder

**What Gets Imported:**
- All unresolved JIRA issues
- Full metadata and descriptions
- Priorities, types, labels as tags
- Due dates (if set in JIRA)

**Duplicate Prevention:**
- Already-imported issues are skipped
- Safe to run multiple times

## Documentation

- **[PLUGIN_SETUP_GUIDE.md](PLUGIN_SETUP_GUIDE.md)** - Detailed setup instructions, troubleshooting, and advanced usage
- **[TECHNICAL_REFERENCE.md](TECHNICAL_REFERENCE.md)** - API details, field mappings, customization guide
- **[DEBUG_LOGGING_GUIDE.md](DEBUG_LOGGING_GUIDE.md)** - Complete guide to debug logging and troubleshooting
- **[CREDENTIAL_MANAGEMENT.md](CREDENTIAL_MANAGEMENT.md)** - Guide to managing API keys and credentials
- **[SYNC_SCRIPTS_GUIDE.md](SYNC_SCRIPTS_GUIDE.md)** - Guide to using the iCloud sync scripts
- **[VERSION_MANAGEMENT.md](VERSION_MANAGEMENT.md)** - Guide to version bumping and releases
- **[EDITOR_SETUP.md](EDITOR_SETUP.md)** - Configure your editor for `.omnifocusjs` syntax highlighting
- **[OMNIFOCUS_API_PRIMER.md](OMNIFOCUS_API_PRIMER.md)** - Complete OmniFocus JavaScript API reference
- **[CHANGELOG.md](CHANGELOG.md)** - Version history and release notes

## Security

- All credentials stored in macOS Keychain (encrypted)
- HTTPS-only API communication
- No data sent to third parties (except Anthropic/JIRA APIs)
- Open source - review the code yourself

## Costs

**Claude AI (Anthropic):**
- Pay-per-use pricing
- Typical cost: $0.003-0.015 per analysis
- Check current pricing: https://www.anthropic.com/pricing

**JIRA API:**
- Free for standard usage
- No additional costs

## Sync Scripts

Two utility scripts are included for managing plugins with iCloud Drive:

### sync-to-icloud.sh
Copies plugins from this repository to iCloud OmniFocus Plug-Ins folder:
```bash
./sync-to-icloud.sh
```

**Use this when:**
- You edit plugins in this repository
- You want to deploy updates to OmniFocus
- You're setting up for the first time

### sync-from-icloud.sh
Copies plugins from iCloud back to this repository:
```bash
./sync-from-icloud.sh
```

**Use this when:**
- You edit plugins directly in OmniFocus
- You want to save iCloud changes to git
- You need to backup your modifications

**Features:**
- Portable (uses `$USER` variable)
- Shows what changed (new/updated/unchanged)
- Color-coded output
- Safe (compares files before copying)
- Automatic detection of iCloud folder

## Version Management

Scripts for managing plugin versions and releases:

### bump-version.sh
Quick version bumping:
```bash
# Bump patch version (1.0.0 → 1.0.1)
./bump-version.sh patch

# Bump minor version (1.0.0 → 1.1.0)
./bump-version.sh minor

# Bump major version (1.0.0 → 2.0.0)
./bump-version.sh major
```

### release.sh
Complete release workflow (recommended):
```bash
# Full release: version bump, changelog, sync, git tag
./release.sh patch
```

**Features:**
- Automatic version bumping (major/minor/patch)
- Changelog generation
- Git commit and tag creation
- iCloud sync integration
- Interactive prompts
- Follows semantic versioning

See [VERSION_MANAGEMENT.md](VERSION_MANAGEMENT.md) for details.

## Customization

Both plugins are fully customizable:
- Edit `.omnifocusjs` files in any text editor
- Modify AI prompts, field mappings, tag names
- Add custom logic or integrations
- Use sync scripts to deploy changes
- See TECHNICAL_REFERENCE.md for details

## Debug Logging

Both plugins include comprehensive debug logging visible in the OmniFocus Automation Console.

**To view logs:**
1. Open Automation Console (Automation menu → Automation Console)
2. Ensure "Console" tab is selected
3. Run the plugin
4. View detailed logs showing:
   - API requests and responses
   - Task/issue processing
   - Error details with stack traces
   - Step-by-step execution flow

**See [DEBUG_LOGGING_GUIDE.md](DEBUG_LOGGING_GUIDE.md) for complete details.**

## Troubleshooting

### Common Issues

**"API Error: 401"**
- Invalid API key/token
- Delete from Keychain and re-enter

**"No issues found" (JIRA)**
- All issues are resolved
- Check project key filter
- Verify JIRA permissions

**"Could not parse JSON from Claude response"**
- Temporary API issue
- Try again or reduce number of tasks

See PLUGIN_SETUP_GUIDE.md for complete troubleshooting guide.

## Advanced Usage

### Automation Ideas

1. **Scheduled JIRA Sync**
   - Use Keyboard Maestro or Shortcuts
   - Run import daily at 9 AM
   - Keep OmniFocus in sync with JIRA

2. **Weekly Task Review**
   - Run AI Clarifier every Friday
   - Review flagged tasks
   - Clean up before weekly review

3. **Combined Workflow**
   - Import JIRA issues
   - Run AI Clarifier on new tasks
   - Review and refine

### Integration with Other Tools

- Combine with GitHub issue import (future enhancement)
- Export AI analysis reports
- Trigger from other automation tools
- Build custom workflows

## Examples

### AI Task Clarifier Output

**Before:**
```
Task: "Website stuff"
```

**After:**
```
Task: "Website stuff" [FLAGGED] [Tagged: AI Review]
Note:
  --- AI Analysis (1/26/2025) ---
  Issue: vague
  Severity: high
  Suggestion: Specify what needs to be done. Consider:
    - "Update website homepage copy"
    - "Fix website mobile navigation bug"
    - "Review website analytics report"
  Recommended Action: clarify
```

### JIRA Import Result

**JIRA Issue:**
```
PROJ-123: Fix login bug
Priority: High
Type: Bug
Labels: frontend, urgent
Due: Feb 1, 2025
```

**OmniFocus Task:**
```
[PROJ-123] Fix login bug
Due: Feb 1, 2025
Tags: JIRA, Priority: High, Type: Bug, frontend, urgent
Note:
  JIRA: PROJ-123
  URL: https://company.atlassian.net/browse/PROJ-123
  Status: In Progress
  Type: Bug
  Priority: High
  Assignee: John Doe
  Reporter: Jane Smith
  Created: 1/15/2025
  Updated: 1/20/2025

  --- Description ---
  Users cannot log in when using Safari browser.
  Steps to reproduce: ...
```

## Contributing

These plugins are open source. Feel free to:
- Modify for your needs
- Share improvements
- Report issues
- Suggest features

## License

Provided as-is for personal and commercial use.
Modify and distribute freely.

## Credits

Built with:
- OmniFocus Omni Automation framework
- Claude AI API (Anthropic)
- JIRA REST API v3

## Support

- Check documentation files in this repo
- OmniFocus forums: https://discourse.omnigroup.com/
- Anthropic docs: https://docs.anthropic.com/
- JIRA docs: https://developer.atlassian.com/cloud/jira/

## Roadmap

Future enhancements:
- [ ] Bidirectional JIRA sync (update JIRA from OmniFocus)
- [ ] GitHub issue import
- [ ] Scheduled automatic imports
- [ ] Custom AI analysis profiles
- [ ] Export analysis reports
- [ ] Linear, Asana, Trello integrations

---

**Version 2.0** | January 2025 | Made with love for OmniFocus users
