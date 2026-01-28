# Debug Logging Guide

Both OmniFocus plugins include comprehensive debug logging to help troubleshoot issues and understand what's happening during execution.

## Accessing the Console

### macOS
1. Open OmniFocus
2. Click Automation menu (gear icon in toolbar or menu bar)
3. Select "Automation Console"
4. Ensure "Console" tab is selected (not "API Reference")
5. Run your plugin
6. View logs in the output area below the input field

### iOS/iPadOS
1. Open OmniFocus
2. Tap Automation menu (gear icon at bottom-left)
3. Tap "Automation Console"
4. Ensure "Console" tab is selected
5. Run your plugin
6. Scroll through console output

## What Gets Logged

### AI Task Clarifier

**Startup & Configuration:**
```
=== AI Task Clarifier Debug Log ===
Starting plugin execution...
Credentials check: Found stored credentials
```

**Task Selection:**
```
Selection check - tasks selected: 3
Using selected tasks, filtered to incomplete: 3
Total tasks to analyze: 3
```

**Task Data Preparation:**
```
Preparing task data for AI analysis...
Task data prepared, sample: {
  "index": 0,
  "name": "Think about project",
  "note": "",
  "age_days": 5,
  "has_due_date": false,
  "has_defer_date": false,
  "flagged": false,
  "tags": ""
}
```

**API Request:**
```
=== Claude API Request ===
URL: https://api.anthropic.com/v1/messages
Method: POST
Headers: {
  "x-api-key": "[REDACTED]",
  "anthropic-version": "2023-06-01",
  "Content-Type": "application/json"
}
Request Body: {
  "model": "claude-sonnet-4-20250514",
  "max_tokens": 4096,
  "system": "...",
  "messages": [...]
}
```

**API Response:**
```
=== Claude API Response ===
Status Code: 200
Response Body: {
  "id": "msg_...",
  "type": "message",
  "role": "assistant",
  "model": "claude-sonnet-4-20250514",
  "content": [...]
}
Parsed response data: {...}
Parsed AI response: {
  "analysis": [
    {
      "index": 0,
      "issue": "vague",
      "severity": "high",
      "suggestion": "...",
      "action": "clarify"
    }
  ]
}
```

**Processing Results:**
```
Issues found: 2
Creating/finding 'AI Review' tag...
Found existing 'AI Review' tag
Applying findings to tasks...
Processing issue 1/2: {...}
Updating task: "Think about project"
Added 'AI Review' tag to task
Flagged task due to high severity
Updated 2 tasks
```

**Summary:**
```
=== Analysis Summary ===
Analysis Complete!

Tasks analyzed: 3
Issues found: 2
Tasks updated: 2

Tasks with issues have been tagged "AI Review" and notes added with suggestions.
=== End Debug Log ===
```

### JIRA Import

**Startup & Configuration:**
```
=== JIRA Import Debug Log ===
Starting plugin execution...
Credentials check: Found stored credentials
Loading stored credentials...
Loaded config: {
  "domain": "company.atlassian.net",
  "email": "user@company.com",
  "apiToken": "[REDACTED]",
  "projectKey": "PROJ"
}
```

**JQL Query:**
```
JQL Query: project = PROJ AND resolution = Unresolved ORDER BY created DESC
```

**API Request:**
```
=== JIRA API Request ===
URL: https://company.atlassian.net/rest/api/3/search
Method: POST
Headers: {
  "Authorization": "Basic [REDACTED]",
  "Content-Type": "application/json",
  "Accept": "application/json"
}
Request Body: {
  "jql": "project = PROJ AND resolution = Unresolved ORDER BY created DESC",
  "maxResults": 100,
  "fields": [...]
}
```

**API Response:**
```
=== JIRA API Response ===
Status Code: 200
Response Body: {
  "expand": "...",
  "startAt": 0,
  "maxResults": 100,
  "total": 15,
  "issues": [...]
}
Parsed response data - Total issues: 15
Issues returned: 15
```

**Setup:**
```
Found 15 issues to import
Setting up JIRA folder and project...
Found existing JIRA folder
Found existing JIRA Issues project
Setting up JIRA tag...
Found existing JIRA tag
```

**Processing Issues:**
```
Processing issues...

Processing issue: PROJ-123
Issue data: {
  "key": "PROJ-123",
  "summary": "Fix login bug",
  "status": "In Progress",
  "type": "Bug",
  "priority": "High"
}
Creating new task for PROJ-123
Set due date: 2025-02-01
Added JIRA tag
Successfully created task for PROJ-123

Processing issue: PROJ-124
Issue data: {...}
Skipping PROJ-124 - already exists
```

**Summary:**
```
=== Import Summary ===
JIRA Import Complete!

Total issues found: 15
New tasks created: 10
Skipped (already imported): 5

Tasks have been added to the "JIRA Issues" project in the "JIRA" folder.
=== End Debug Log ===
```

## Error Logging

Both plugins log detailed error information:

```
=== ERROR ===
Error message: API Error: 401 - Unauthorized
Error stack: Error: API Error: 401 - Unauthorized
    at <anonymous>:150:23
    at <anonymous>
=== End Debug Log ===
```

## Using Debug Logs for Troubleshooting

### Common Issues and What to Look For

**1. API Authentication Errors**

Look for:
```
Status Code: 401
```

This means:
- Claude: Invalid API key
- JIRA: Invalid email or API token

**2. API Rate Limiting**

Look for:
```
Status Code: 429
```

This means you've exceeded rate limits. Wait and try again.

**3. Invalid Domain/URL**

Look for:
```
Status Code: 404
```

For JIRA, check the domain in the logs:
```
URL: https://company.atlassian.net/rest/api/3/search
```

Make sure the domain is correct.

**4. No Tasks/Issues Found**

Look for:
```
No tasks found matching criteria
```
or
```
Issues returned: 0
```

Check your selection or JQL query.

**5. JSON Parsing Errors**

Look for:
```
Error: Unexpected token...
```

This usually means the API returned an unexpected response format.

### Debugging Workflow

1. **Run the plugin** with debug logging enabled (it's always on)

2. **Check the console** immediately after running

3. **Look for the error section** if something went wrong:
   ```
   === ERROR ===
   ```

4. **Review the API request** to verify parameters:
   - Check URL is correct
   - Verify request body format
   - Confirm headers are set

5. **Review the API response** to see what the server returned:
   - Check status code
   - Read error message in response body
   - Look for specific error codes

6. **Check processing logs** to see where it failed:
   - Did it get past authentication?
   - Did it parse the response?
   - Did it create tasks/tags?

## Copying Debug Logs

### macOS
1. Select the log text in the console
2. Press Cmd+C to copy
3. Paste into a text file or email

### iOS/iPadOS
1. Long-press on the log text
2. Select "Select All" or drag to select
3. Tap "Copy"
4. Paste into Notes or email

## Privacy & Security

**What's Redacted:**
- API keys show only first 20 characters: `sk-ant-api03-...`
- JIRA API tokens: `[REDACTED]`
- Authorization headers: `x-api-key: [REDACTED]` or `Basic [REDACTED]`

**What's NOT Redacted:**
- Task names and notes (your data)
- JIRA issue summaries and descriptions
- Domain names and URLs
- Email addresses

**Tip:** If sharing logs for support, manually redact any sensitive task content.

## Disabling Debug Logging

If you want to disable debug logging (not recommended for troubleshooting):

1. Open the `.omnifocusjs` file in a text editor
2. Find all `console.log()` statements
3. Comment them out with `//`:
   ```javascript
   // console.log("Debug message");
   ```
4. Save and sync to iCloud

Or use a global flag:

```javascript
const DEBUG = false; // Set to true to enable logging

if (DEBUG) console.log("Debug message");
```

## Advanced: Logging Custom Data

You can add your own debug logs by editing the plugin:

```javascript
// Log a simple message
console.log("My custom message");

// Log an object
console.log("Task data:", JSON.stringify(task, null, 2));

// Log with context
console.log(`Processing task ${index + 1} of ${total}`);

// Log errors
console.error("Something went wrong:", error);

// Log warnings
console.warn("This might be a problem:", value);
```

## Console Commands

You can also run commands directly in the console:

```javascript
// View all tasks
flattenedTasks.forEach(t => console.log(t.name));

// Count incomplete tasks
console.log(flattenedTasks.filter(t => !t.completed).length);

// Find tasks with specific tag
const tagged = flattenedTasks.filter(t => 
  t.tags.some(tag => tag.name === "AI Review")
);
console.log(tagged.length);

// Clear console
console.clear();
```

## Tips

1. **Keep console open** while testing plugins
2. **Clear console** before each run for clarity: `console.clear()`
3. **Copy logs** before they scroll away
4. **Look for patterns** in repeated errors
5. **Check timestamps** in API responses to verify freshness
6. **Compare request/response** to API documentation
7. **Test with minimal data** first (1-2 tasks/issues)

## Getting Help

When asking for help:

1. **Copy the full debug log** from start to end
2. **Include the error section** if present
3. **Describe what you expected** vs what happened
4. **Mention your setup**: macOS/iOS, OmniFocus version
5. **Redact sensitive information** (task content, full API keys)

Example support request:
```
I'm getting a 401 error when running AI Task Clarifier.

Debug log:
=== AI Task Clarifier Debug Log ===
Starting plugin execution...
Credentials check: Found stored credentials
...
Status Code: 401
Error: API Error: 401 - Unauthorized

I've verified my API key is correct in the Anthropic console.
Using OmniFocus 4.2 on macOS 14.2.
```

## Summary

Debug logging is your best friend for troubleshooting. It shows:
- ✅ What the plugin is doing at each step
- ✅ Exact API requests being sent
- ✅ Complete API responses received
- ✅ How data is being processed
- ✅ Where errors occur

Always check the console first when something doesn't work as expected!

