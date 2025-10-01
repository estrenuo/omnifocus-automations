# OmniFocus Automation Plugins - Setup Guide

This repository contains two powerful OmniFocus automation plugins that integrate with external services.

## Plugins Included

### 1. AI Task Clarifier (`AI-Task-Clarifier.omnifocusjs`)
Uses OpenAI GPT-5 to analyze your tasks and identify issues like:
- Vague or non-actionable tasks
- Tasks that are too broad (need breaking down)
- Missing critical context
- Stale tasks (old with no progress)
- Ambiguous or unclear tasks

### 2. JIRA Import (`JIRA-Import.omnifocusjs`)
Imports all open JIRA issues as OmniFocus tasks with comprehensive field mapping:
- Creates tasks from all unresolved JIRA issues
- Maps JIRA fields to OmniFocus properties
- Creates tags for priorities, issue types, labels, and components
- Stores JIRA metadata in task notes
- Prevents duplicate imports

## Prerequisites

### For AI Task Clarifier
1. **OpenAI API Key**
   - Sign up at https://platform.openai.com/
   - Navigate to API Keys section
   - Create a new API key
   - **Important**: You need access to GPT-5 (released August 2025)
   - Keep your API key secure - it will be stored in your macOS Keychain

### For JIRA Import
1. **JIRA Cloud Account**
   - You need access to a JIRA Cloud instance (e.g., `your-company.atlassian.net`)
   
2. **JIRA API Token**
   - Log in to https://id.atlassian.com/manage-profile/security/api-tokens
   - Click "Create API token"
   - Give it a name (e.g., "OmniFocus Integration")
   - Copy the token immediately (you won't be able to see it again)
   - Keep your token secure - it will be stored in your macOS Keychain

## Installation

### Step 1: Enable Developer Mode (if not already enabled)

**On macOS:**
1. Open OmniFocus
2. Go to OmniFocus → Settings → Automation
3. Enable "Developer Mode" (if available) or ensure automation is enabled

**On iOS/iPadOS:**
1. Open OmniFocus
2. Tap the gear icon (Settings)
3. Scroll to Automation section
4. Enable "Developer Mode"

### Step 2: Install the Plugins

**Method 1: Double-click (Easiest)**
1. Locate the `.omnifocusjs` files in this repository
2. Double-click each file
3. OmniFocus will prompt you to install the plugin
4. Click "Install"

**Method 2: Manual Installation**
1. Open OmniFocus
2. Click the Automation menu (gear icon at bottom-left on iOS, or in menu bar on Mac)
3. Select "Configure Plug-Ins..."
4. Click the "+" button
5. Navigate to the `.omnifocusjs` file
6. Select and install

**Method 3: Drag and Drop (macOS)**
1. Open OmniFocus
2. Drag the `.omnifocusjs` file onto the OmniFocus window
3. Confirm installation

### Step 3: Verify Installation

1. Open the Automation menu (gear icon)
2. You should see:
   - "AI Task Clarifier" (or "AI Clarifier")
   - "Import JIRA Issues" (or "JIRA Import")

## Usage

### AI Task Clarifier

**First Run:**
1. Click Automation menu → "AI Task Clarifier"
2. You'll be prompted to enter your OpenAI API key
3. Enter your key and click "Continue"
4. The key will be securely stored in your macOS Keychain

**Subsequent Runs:**
1. Click Automation menu → "AI Task Clarifier"
2. You'll see a prompt: "OpenAI Credentials Found"
3. Choose:
   - "Use Stored Key" - Continue with saved credentials
   - "Clear & Re-enter Key" - Update your API key
   - "Cancel" - Exit without running

**Analyzing Tasks:**

**Option A: Analyze Selected Tasks**
1. Select one or more tasks in OmniFocus
2. Click Automation menu → "AI Task Clarifier"
3. Wait for analysis (usually 10-30 seconds)

**Option B: Analyze All Tasks**
1. Don't select any tasks
2. Click Automation menu → "AI Task Clarifier"
3. Choose analysis scope:
   - "All incomplete tasks" - Analyzes all open tasks
   - "Tasks older than 30 days" - Focuses on stale tasks
4. Wait for analysis

**Understanding Results:**
- Tasks with issues are tagged "AI Review"
- High-severity issues are automatically flagged
- AI suggestions are added to task notes with:
  - Issue type (vague/broad/stale/ambiguous/missing-context)
  - Severity level (low/medium/high)
  - Specific improvement suggestion
  - Recommended action (clarify/break-down/defer/delete/add-context)

**Example AI Analysis in Task Note:**
```
--- AI Analysis (1/26/2025) ---
Issue: vague
Severity: high
Suggestion: Change "Think about website" to "Draft 3 key features for website redesign"
Recommended Action: clarify
```

### JIRA Import

**First Run:**
1. Click Automation menu → "Import JIRA Issues"
2. You'll be prompted to enter:
   - **JIRA Domain**: Your JIRA URL (e.g., `mycompany.atlassian.net`)
   - **JIRA Email**: Your JIRA account email
   - **JIRA API Token**: The API token you created
   - **Project Key** (optional): Leave empty to import from all projects, or enter a specific project key (e.g., "PROJ")
3. Click "Continue"
4. Credentials will be securely stored in your macOS Keychain

**Subsequent Runs:**
1. Click Automation menu → "Import JIRA Issues"
2. You'll see a prompt showing your stored domain and email
3. Choose:
   - "Use Stored Credentials" - Continue with saved credentials
   - "Clear & Re-enter Credentials" - Update your credentials
   - "Cancel" - Exit without running

**Importing Issues:**
1. Click Automation menu → "Import JIRA Issues"
2. The plugin will:
   - Fetch all unresolved JIRA issues
   - Create a "JIRA" folder (if it doesn't exist)
   - Create a "JIRA Issues" project inside the folder
   - Import each issue as a task
3. Wait for import to complete (progress shown)

**What Gets Imported:**
- **Task Name**: `[JIRA-123] Issue summary`
- **Task Note**: Contains:
  - JIRA key and URL
  - Status, Type, Priority
  - Assignee and Reporter
  - Created/Updated dates
  - Full description
- **Due Date**: Mapped from JIRA due date (if set)
- **Tags**: Automatically created for:
  - Base "JIRA" tag
  - Priority (e.g., "Priority: High")
  - Issue Type (e.g., "Type: Bug")
  - Labels (e.g., "frontend", "urgent")
  - Components (e.g., "Component: API")

**Duplicate Prevention:**
- The plugin checks for existing tasks with the same JIRA key
- Already-imported issues are skipped
- You can safely run the import multiple times

**Example Task Structure:**
```
Folder: JIRA
  └─ Project: JIRA Issues
      └─ Task: [PROJ-123] Fix login bug
          Tags: JIRA, Priority: High, Type: Bug, frontend
          Note: 
            JIRA: PROJ-123
            URL: https://mycompany.atlassian.net/browse/PROJ-123
            Status: In Progress
            Type: Bug
            Priority: High
            Assignee: John Doe
            ...
```

## Configuration

### Updating Credentials

Both plugins now include a built-in credential management feature!

**Easy Method (Recommended):**
1. Run the plugin (AI Task Clarifier or JIRA Import)
2. When prompted, choose "Clear & Re-enter Key/Credentials"
3. Enter your new credentials
4. Done!

**Manual Method (Alternative):**

**OpenAI API Key:**
1. Open macOS Keychain Access
2. Search for "openai"
3. Delete the entry
4. Run the AI Task Clarifier plugin again
5. Enter your new API key

**JIRA Credentials:**
1. Open macOS Keychain Access
2. Search for "jira"
3. Delete both "jira" and "jira-settings" entries
4. Run the JIRA Import plugin again
5. Enter your new credentials

### Customization

Both plugins are open source and can be customized:
- Edit the `.omnifocusjs` files in any text editor
- Modify prompts, field mappings, tag names, etc.
- Save and reinstall the plugin

## Debug Logging

Both plugins include comprehensive debug logging to help troubleshoot issues.

### Viewing Debug Logs

**On macOS:**
1. Open OmniFocus
2. Go to Automation menu → Automation Console
3. Switch to "Console" tab
4. Run the plugin
5. View detailed logs in the console output

**On iOS/iPadOS:**
1. Open OmniFocus
2. Tap Automation menu → Automation Console
3. Ensure "Console" tab is selected
4. Run the plugin
5. Scroll through console output

### What Gets Logged

**AI Task Clarifier logs:**
- Credential check status
- Number of tasks selected/analyzed
- Task data being sent to API
- Complete API request (with redacted API key)
- Complete API response
- Issues found and severity
- Tasks being updated
- Summary statistics

**JIRA Import logs:**
- Credential check status
- JQL query being used
- Complete API request (with redacted credentials)
- Complete API response
- Number of issues found
- Each issue being processed
- Duplicate detection results
- Tag creation
- Summary statistics

### Example Debug Output

```
=== AI Task Clarifier Debug Log ===
Starting plugin execution...
Credentials check: Found stored credentials
Selection check - tasks selected: 3
Using selected tasks, filtered to incomplete: 3
Total tasks to analyze: 3
Preparing task data for AI analysis...
Task data prepared, sample: {
  "index": 0,
  "name": "Think about project",
  "note": "",
  "age_days": 5,
  ...
}
=== OpenAI API Request ===
URL: https://api.openai.com/v1/chat/completions
Method: POST
Request Body: {...}
Sending request to OpenAI...
=== OpenAI API Response ===
Status Code: 200
Response Body: {...}
Issues found: 2
...
=== End Debug Log ===
```

## Troubleshooting

### AI Task Clarifier Issues

**"API Error: 401"**
- Your API key is invalid or expired
- Delete the stored key from Keychain and re-enter

**"API Error: 429"**
- You've exceeded your OpenAI rate limit
- Wait a few minutes and try again
- Consider analyzing fewer tasks at once

**"Model not found" or "Access denied"**
- You don't have access to GPT-5
- Check your OpenAI account tier
- You may need to upgrade your plan

**No issues found**
- Your tasks are well-written! (Good job!)
- Try analyzing older tasks or a different set

### JIRA Import Issues

**"JIRA API Error: 401"**
- Your credentials are incorrect
- Verify your email and API token
- Make sure you're using an API token, not your password

**"JIRA API Error: 404"**
- Your JIRA domain is incorrect
- Verify the domain (should be like `company.atlassian.net`)
- Don't include `https://` in the domain field

**"No issues found"**
- All your JIRA issues are resolved
- Check if you entered a project key that has no open issues
- Try leaving the project key empty to search all projects

**Tasks not importing**
- Check if they already exist (search for the JIRA key)
- Verify the JQL query is correct
- Check JIRA permissions (you need read access to issues)

## API Costs

### OpenAI GPT-5
- Pricing varies based on usage
- Typical cost: ~$0.01-0.05 per analysis run (50 tasks)
- Check current pricing at https://openai.com/pricing

### JIRA API
- JIRA Cloud API is free for standard usage
- No additional costs for API calls

## Security Notes

- API keys and tokens are stored in macOS Keychain (encrypted)
- Credentials are never sent anywhere except to the respective APIs
- All communication uses HTTPS
- You can review the plugin source code to verify security

## Advanced Usage

### Scheduling Automatic Imports

You can use macOS automation tools to run these plugins automatically:

**Using Keyboard Maestro:**
1. Create a new macro
2. Add action: "Execute JavaScript in OmniFocus"
3. Use: `PlugIn.find('com.omnifocus.jira-import').action('Import JIRA Issues').perform()`
4. Set trigger (e.g., daily at 9 AM)

**Using Shortcuts (iOS/macOS):**
1. Create a new shortcut
2. Add "Run OmniFocus Plug-In" action
3. Select the plugin
4. Set automation trigger

### Combining with Other Automations

These plugins can be combined with other OmniFocus automations:
- Run AI Clarifier after JIRA import to analyze new issues
- Use with review perspectives to focus on AI-flagged tasks
- Integrate with other task management workflows

## Support

For issues or questions:
1. Check the troubleshooting section above
2. Review the plugin source code
3. Check OmniFocus forums: https://discourse.omnigroup.com/
4. OpenAI API docs: https://platform.openai.com/docs/
5. JIRA API docs: https://developer.atlassian.com/cloud/jira/platform/rest/v3/

## Version History

### Version 1.0 (January 2025)
- Initial release
- AI Task Clarifier with GPT-5 support
- JIRA Import with comprehensive field mapping
- Secure credential storage
- Duplicate prevention
- Tag-based organization

## License

These plugins are provided as-is for personal and commercial use.
Feel free to modify and distribute as needed.

