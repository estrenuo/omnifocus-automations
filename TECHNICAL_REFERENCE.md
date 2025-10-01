# Technical Reference - OmniFocus Automation Plugins

## Plugin Architecture

Both plugins follow the OmniFocus Omni Automation plugin structure with:
- Metadata header (JSON comment block)
- Self-executing anonymous function returning a `PlugIn.Action`
- Async/await for API calls
- Secure credential storage using `Credentials` class
- Error handling and user feedback via `Alert` and `Form` classes

## AI Task Clarifier - Technical Details

### API Integration

**Endpoint**: `https://api.openai.com/v1/chat/completions`

**Model**: `gpt-5-2025-08-07` (GPT-5, released August 2025)

**Request Format**:
```json
{
  "model": "gpt-5-2025-08-07",
  "messages": [
    {
      "role": "system",
      "content": "You are a productivity expert..."
    },
    {
      "role": "user",
      "content": "Analyze these tasks:\n[task data]"
    }
  ],
  "response_format": { "type": "json_object" },
  "temperature": 0.3
}
```

**Response Format**:
```json
{
  "choices": [
    {
      "message": {
        "content": "{\"results\": [{\"index\": 0, \"issue\": \"vague\", \"severity\": \"high\", \"suggestion\": \"...\", \"action\": \"clarify\"}]}"
      }
    }
  ]
}
```

### Task Analysis Logic

**Task Data Sent to AI**:
```javascript
{
  index: 0,
  name: "Task name",
  note: "First 200 chars of note",
  age_days: 45,
  has_due_date: true,
  has_defer_date: false,
  flagged: false,
  tags: "tag1, tag2"
}
```

**Issue Types Detected**:
- `vague` - Non-actionable or unclear tasks
- `broad` - Tasks that should be broken down
- `stale` - Old tasks without progress
- `ambiguous` - Unclear or confusing tasks
- `missing-context` - Tasks lacking necessary information

**Severity Levels**:
- `low` - Minor issue, optional improvement
- `medium` - Should be addressed
- `high` - Critical issue, task is flagged automatically

**Recommended Actions**:
- `clarify` - Rewrite task to be more specific
- `break-down` - Split into subtasks
- `defer` - Move to someday/maybe
- `delete` - Remove if no longer relevant
- `add-context` - Add more information to note

### Task Modifications

1. **Tag Addition**: Creates/applies "AI Review" tag
2. **Note Appending**: Adds analysis section to existing note
3. **Flagging**: High-severity issues are automatically flagged
4. **Preservation**: Original task data is never deleted

### Limitations

- Maximum 50 tasks per analysis (to avoid token limits)
- Note preview limited to 200 characters (for API efficiency)
- Requires active internet connection
- API costs apply per analysis

## JIRA Import - Technical Details

### API Integration

**Endpoint**: `https://YOUR-DOMAIN.atlassian.net/rest/api/3/search`

**Authentication**: Basic Auth (Base64 encoded `email:api_token`)

**Request Format**:
```json
{
  "jql": "resolution = Unresolved ORDER BY created DESC",
  "maxResults": 100,
  "fields": [
    "summary", "description", "status", "priority",
    "issuetype", "assignee", "reporter", "created",
    "updated", "duedate", "labels", "components"
  ]
}
```

**Response Format**:
```json
{
  "issues": [
    {
      "key": "PROJ-123",
      "fields": {
        "summary": "Issue title",
        "description": "Issue description",
        "status": { "name": "In Progress" },
        "priority": { "name": "High" },
        "issuetype": { "name": "Bug" },
        "assignee": { "displayName": "John Doe" },
        "reporter": { "displayName": "Jane Smith" },
        "created": "2025-01-01T10:00:00.000+0000",
        "updated": "2025-01-15T14:30:00.000+0000",
        "duedate": "2025-02-01",
        "labels": ["frontend", "urgent"],
        "components": [{ "name": "API" }]
      }
    }
  ]
}
```

### Field Mapping

| JIRA Field | OmniFocus Property | Notes |
|------------|-------------------|-------|
| `key` + `summary` | Task name | Format: `[JIRA-123] Summary` |
| `description` | Task note | Appended after metadata |
| `duedate` | Task due date | Direct mapping |
| `priority.name` | Tag | Format: `Priority: High` |
| `issuetype.name` | Tag | Format: `Type: Bug` |
| `labels[]` | Tags | One tag per label |
| `components[].name` | Tags | Format: `Component: API` |
| `status.name` | Note metadata | Not mapped to task status |
| `assignee.displayName` | Note metadata | Reference only |
| `reporter.displayName` | Note metadata | Reference only |
| `created` | Note metadata | Reference only |
| `updated` | Note metadata | Reference only |

### Task Note Structure

```
JIRA: PROJ-123
URL: https://company.atlassian.net/browse/PROJ-123
Status: In Progress
Type: Bug
Priority: High
Assignee: John Doe
Reporter: Jane Smith
Created: 1/1/2025
Updated: 1/15/2025

--- Description ---
[Full JIRA description text]
```

### Organizational Structure

```
Library
└─ Folder: JIRA
   └─ Project: JIRA Issues
      └─ Task: [PROJ-123] Issue title
      └─ Task: [PROJ-124] Another issue
      └─ ...

Tags
└─ Tag: JIRA
   ├─ Tag: Priority: High
   ├─ Tag: Priority: Medium
   ├─ Tag: Type: Bug
   ├─ Tag: Type: Story
   ├─ Tag: Component: API
   └─ ...
```

### Duplicate Prevention

**Detection Method**: Searches all tasks for JIRA key in note field

```javascript
const existingTask = flattenedTasks.find(task => 
    task.note && task.note.includes(`JIRA: ${issueKey}`)
);
```

**Behavior**: 
- Existing tasks are skipped (not updated)
- Only new issues are imported
- Summary shows count of skipped tasks

### JQL Query Customization

**Default Query**: `resolution = Unresolved ORDER BY created DESC`

**With Project Filter**: `project = PROJ AND resolution = Unresolved ORDER BY created DESC`

**Possible Customizations** (edit plugin code):
```javascript
// Only assigned to you
jql = 'assignee = currentUser() AND resolution = Unresolved';

// Only specific issue types
jql = 'issuetype in (Bug, Task) AND resolution = Unresolved';

// Only high priority
jql = 'priority = High AND resolution = Unresolved';

// Created in last 30 days
jql = 'created >= -30d AND resolution = Unresolved';

// Specific sprint
jql = 'sprint = "Sprint 1" AND resolution = Unresolved';
```

### Pagination

**Current Limit**: 100 issues per import

**To Increase** (edit plugin code):
```javascript
// Change maxResults in request
request.bodyString = JSON.stringify({
    jql: jql,
    maxResults: 500,  // Increase this
    fields: [...]
});
```

**To Implement Full Pagination**:
```javascript
// Add loop to fetch all pages
let startAt = 0;
let allIssues = [];
do {
    const response = await fetchIssues(startAt);
    allIssues = allIssues.concat(response.issues);
    startAt += response.maxResults;
} while (startAt < response.total);
```

## Credential Storage

Both plugins use the OmniFocus `Credentials` class which stores data in macOS Keychain.

### Storage Keys

**AI Task Clarifier**:
- Service: `"openai"`
- User: `"api-key"`
- Password: `[Your OpenAI API key]`

**JIRA Import**:
- Service: `"jira"`
- User: `[Your JIRA email]`
- Password: `[Your JIRA API token]`
- Service: `"jira-settings"`
- User: `"config"`
- Password: `{"domain": "...", "projectKey": "..."}`

### Security Features

1. **Keychain Encryption**: All credentials encrypted by macOS
2. **No Plaintext Storage**: Never stored in plugin files or preferences
3. **Sandboxed Access**: Only accessible by OmniFocus
4. **HTTPS Only**: All API calls use encrypted connections

## Error Handling

### Common Error Codes

**OpenAI API**:
- `401` - Invalid API key
- `429` - Rate limit exceeded
- `500` - OpenAI server error
- `503` - Service temporarily unavailable

**JIRA API**:
- `401` - Invalid credentials
- `403` - Insufficient permissions
- `404` - Domain or resource not found
- `429` - Rate limit exceeded

### Error Recovery

Both plugins include try-catch blocks and display user-friendly error messages via `Alert` dialogs.

## Performance Considerations

### AI Task Clarifier

**Factors Affecting Speed**:
- Number of tasks analyzed (more tasks = longer processing)
- OpenAI API response time (typically 5-30 seconds)
- Network latency

**Optimization Tips**:
- Analyze in batches of 20-30 tasks
- Use "Tasks older than 30 days" scope for focused analysis
- Run during off-peak hours for faster API response

### JIRA Import

**Factors Affecting Speed**:
- Number of open issues (more issues = longer processing)
- JIRA API response time (typically 2-10 seconds)
- Network latency
- Tag creation (first run is slower)

**Optimization Tips**:
- Use project key filter to limit scope
- Run periodically (daily/weekly) to keep imports small
- Consider custom JQL for specific issue sets

## Extending the Plugins

### Adding Custom AI Prompts

Edit the `systemPrompt` in AI Task Clarifier:

```javascript
const systemPrompt = `You are a productivity expert analyzing OmniFocus tasks.
Additionally, check for:
- Tasks without time estimates
- Tasks missing project context
- Tasks that could be automated
...`;
```

### Adding Custom JIRA Fields

Edit the `fields` array in JIRA Import:

```javascript
fields: [
    "summary",
    "description",
    // Add custom fields
    "customfield_10001",  // Story points
    "customfield_10002",  // Sprint
    // ...
]
```

Then access in processing:

```javascript
const storyPoints = fields.customfield_10001;
task.estimatedMinutes = storyPoints * 60; // Convert to minutes
```

### Adding Bidirectional Sync

To update JIRA when tasks are completed:

```javascript
// Check for completed tasks with JIRA keys
const completedJiraTasks = flattenedTasks.filter(task => 
    task.completed && task.note && task.note.includes('JIRA:')
);

// Extract JIRA key and update via API
for (const task of completedJiraTasks) {
    const match = task.note.match(/JIRA: ([A-Z]+-\d+)/);
    if (match) {
        const issueKey = match[1];
        // Call JIRA API to transition issue
        await transitionJiraIssue(issueKey, 'Done');
    }
}
```

## Testing

### Testing AI Task Clarifier

1. Create test tasks with known issues:
   - "Think about project" (vague)
   - "Do everything for launch" (too broad)
   - Old task from 60 days ago (stale)

2. Run plugin on test tasks
3. Verify AI identifies issues correctly
4. Check tags and notes are added properly

### Testing JIRA Import

1. Create test JIRA issues with various fields
2. Run import plugin
3. Verify:
   - Tasks created in correct location
   - All fields mapped correctly
   - Tags created properly
   - Duplicate prevention works

4. Run import again to test skip logic

## API Rate Limits

### OpenAI
- Varies by account tier
- Typical: 3,500 requests/minute (Tier 1)
- Monitor usage at https://platform.openai.com/usage

### JIRA
- Cloud: 300 requests/minute per IP
- Rarely hit with normal plugin usage
- Automatic retry with exponential backoff recommended for production

## Future Enhancements

Possible improvements:
1. Bidirectional JIRA sync (update JIRA from OmniFocus)
2. GitHub issue import
3. AI-powered task breakdown (create subtasks automatically)
4. Scheduled automatic imports
5. Custom AI analysis profiles
6. Batch processing for large datasets
7. Export analysis reports
8. Integration with other project management tools

