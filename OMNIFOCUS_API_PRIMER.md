# OmniFocus 4 JavaScript API Primer

## Overview

OmniFocus 4 includes **Omni Automation**, a powerful JavaScript-based automation framework that allows you to programmatically interact with your tasks, projects, folders, and tags. This is a client-side automation system that runs within the OmniFocus application itself (both macOS and iOS/iPadOS).

## Key Concepts

### Architecture
- **JavaScript-based**: Uses standard JavaScript (ES6+) with OmniFocus-specific APIs
- **Client-side execution**: Scripts run within the OmniFocus app, not on a server
- **Cross-platform**: Works on macOS, iOS, and iPadOS
- **Plugin system**: Create reusable automation plugins that appear in the Automation Menu
- **Console access**: Built-in console for testing and running scripts interactively

### Accessing the API
1. **Enable Developer Mode** (iOS/iPadOS): Settings → Automation → Developer Mode
2. **Automation Console**: Access via Automation Menu (gear icon) → Automation Console
3. **API Reference**: Built into the app - switch to "API Reference" tab in console window

## Core API Components

### Database Access
The main entry point is the global `database` object (or shorthand `library`, `inbox`, `tags`):

```javascript
// Access the database
const db = database;

// Top-level collections
library;        // Array of top-level folders and projects
inbox;          // Array of inbox tasks
tags;           // Array of top-level tags
flattenedTasks; // All tasks in the database
```

### Main Object Types

#### 1. **Task** (The fundamental unit)
- Properties: `name`, `note`, `dueDate`, `deferDate`, `completionDate`, `estimatedMinutes`
- Status: `completed`, `dropped`, `flagged`
- Relationships: `tags`, `project`, `parent`, `children`
- Methods: `addTag()`, `removeTag()`, `markComplete()`, `drop()`

#### 2. **Project**
- Properties: `name`, `note`, `status`, `dueDate`, `completionDate`
- Status types: `active`, `on-hold`, `completed`, `dropped`
- Contains: `task` (root task), `tasks` (all tasks)
- Review: `nextReviewDate`, `reviewInterval`

#### 3. **Folder**
- Properties: `name`, `status`, `active`
- Contains: `projects`, `folders` (nested folders)
- Hierarchy: `parent`, `children`

#### 4. **Tag**
- Properties: `name`, `status`, `active`, `allowsNextAction`
- Hierarchy: `parent`, `children`, `tags`
- Special: `Tag.forecastTag` (the Forecast tag)

### Creating Objects

```javascript
// Create a new task in inbox
const task = new Task("Call dentist", inbox.ending);

// Create a project
const project = new Project("Website Redesign", library.ending);

// Create a folder
const folder = new Folder("Personal", library.ending);

// Create a tag
const tag = new Tag("Urgent", tags.ending);
```

### Querying and Filtering

```javascript
// Find by name
const project = database.projectNamed("Website Redesign");
const tag = database.tagNamed("Urgent");

// Smart matching (fuzzy search)
const projects = database.projectsMatching("website");
const tags = database.tagsMatching("urgent");

// Filter tasks
const flaggedTasks = flattenedTasks.filter(task => task.flagged);
const dueSoon = flattenedTasks.filter(task => {
    return task.dueDate && task.dueDate < new Date(Date.now() + 7*24*60*60*1000);
});
```

### Traversing Hierarchies

```javascript
// Apply function to all items recursively
library.apply(item => {
    console.log(item.name);
    // Return ApplyResult.Stop to stop iteration
    // Return ApplyResult.SkipChildren to skip descendants
});

// Iterate through tasks
inbox.forEach(task => {
    console.log(task.name);
});
```

## External Integration Capabilities

### HTTP Requests (URL.FetchRequest)
OmniFocus includes a powerful HTTP client for calling external APIs:

```javascript
// Create a fetch request
const request = new URL.FetchRequest();
request.url = URL.fromString("https://api.example.com/data");
request.method = "POST";
request.headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer YOUR_TOKEN"
};
request.bodyString = JSON.stringify({ key: "value" });

// Execute the request
request.fetch().then(response => {
    console.log(response.statusCode);
    const data = JSON.parse(response.bodyString);
    // Process response
}).catch(error => {
    console.error(error);
});
```

### Credentials Storage
Securely store API keys and passwords:

```javascript
// In plugin loading context
const credentials = new Credentials();

// Store credentials
credentials.write("myService", "username", "password");

// Retrieve credentials
const creds = credentials.read("myService");
// Returns: { user: "username", password: "password" }

// Store URL bookmarks (for file access)
credentials.writeBookmark("myFiles", bookmark);
```

### URL Schemes (x-callback-url)
Trigger actions in other apps:

```javascript
// Call another app
const url = URL.fromString("shortcuts://run-shortcut?name=MyShortcut");
url.call(
    (result) => { console.log("Success:", result); },
    (error) => { console.error("Error:", error); }
);
```

## AI Integration Possibilities

### 1. **Task Analysis & Cleanup**
You can build automations that:
- Extract all tasks and send to AI for analysis
- Identify vague/non-actionable tasks (e.g., "Think about project")
- Suggest better task names or breakdowns
- Flag tasks that have been stagnant too long
- Detect duplicate or similar tasks

**Example workflow:**
```javascript
// Collect problematic tasks
const oldTasks = flattenedTasks.filter(task => {
    const age = Date.now() - task.added.getTime();
    return !task.completed && age > 30*24*60*60*1000; // 30+ days old
});

// Send to AI API for analysis
const request = new URL.FetchRequest();
request.url = URL.fromString("https://api.anthropic.com/v1/messages");
request.method = "POST";
request.headers = {
    "x-api-key": "YOUR_API_KEY",
    "anthropic-version": "2023-06-01",
    "Content-Type": "application/json"
};
request.bodyString = JSON.stringify({
    model: "claude-sonnet-4-20250514",
    max_tokens: 4096,
    messages: [{
        role: "user",
        content: `Analyze these tasks and identify which are vague or non-actionable: ${JSON.stringify(oldTasks.map(t => t.name))}`
    }]
});

request.fetch().then(response => {
    const data = JSON.parse(response.bodyString);
    // Process AI recommendations from data.content[0].text
    // Tag problematic tasks, add notes, etc.
});
```

### 2. **Natural Language Task Creation**
- Send task descriptions to AI for parsing
- Extract due dates, tags, project assignments
- Break complex tasks into subtasks

### 3. **Smart Tagging & Categorization**
- AI analyzes task content and suggests appropriate tags
- Auto-categorize tasks into projects
- Detect task dependencies

### 4. **Review Assistant**
- AI generates review summaries
- Suggests tasks to defer, delete, or complete
- Identifies bottlenecks in projects

## JIRA Integration Possibilities

### Bidirectional Sync
```javascript
// Fetch JIRA issues
const jiraRequest = new URL.FetchRequest();
jiraRequest.url = URL.fromString("https://your-domain.atlassian.net/rest/api/3/search");
jiraRequest.headers = {
    "Authorization": "Basic " + btoa("email:api_token"),
    "Content-Type": "application/json"
};

jiraRequest.fetch().then(response => {
    const issues = JSON.parse(response.bodyString).issues;
    
    // Create OmniFocus tasks from JIRA issues
    issues.forEach(issue => {
        const task = new Task(issue.fields.summary, inbox.ending);
        task.note = `JIRA: ${issue.key}\n${issue.fields.description}`;
        task.addTag(database.tagNamed("JIRA"));
    });
});

// Update JIRA when task is completed
const jiraTask = flattenedTasks.find(t => t.note.includes("JIRA-123"));
if (jiraTask.completed) {
    // Send update to JIRA API
    const updateRequest = new URL.FetchRequest();
    updateRequest.url = URL.fromString("https://your-domain.atlassian.net/rest/api/3/issue/JIRA-123/transitions");
    updateRequest.method = "POST";
    // ... transition issue to Done
}
```

### Possible JIRA Workflows
- **Import sprints**: Create OmniFocus projects from JIRA sprints
- **Status sync**: Update JIRA status when OmniFocus task is completed
- **Comment sync**: Add OmniFocus notes as JIRA comments
- **Time tracking**: Log time from OmniFocus to JIRA

## GitHub Integration Possibilities

### Repository & Issue Management
```javascript
// Fetch GitHub issues
const ghRequest = new URL.FetchRequest();
ghRequest.url = URL.fromString("https://api.github.com/repos/owner/repo/issues");
ghRequest.headers = {
    "Authorization": "token YOUR_GITHUB_TOKEN",
    "Accept": "application/vnd.github.v3+json"
};

ghRequest.fetch().then(response => {
    const issues = JSON.parse(response.bodyString);
    // Create tasks from issues
});

// Create PR from OmniFocus task
const createPR = (task) => {
    const prRequest = new URL.FetchRequest();
    prRequest.url = URL.fromString("https://api.github.com/repos/owner/repo/pulls");
    prRequest.method = "POST";
    prRequest.bodyString = JSON.stringify({
        title: task.name,
        head: "feature-branch",
        base: "main",
        body: task.note
    });
    // ... execute request
};
```

### Possible GitHub Workflows
- **Issue import**: Create tasks from GitHub issues
- **PR creation**: Trigger PR creation from task completion
- **Branch management**: Create branches based on task names
- **Status updates**: Update issue labels when task status changes
- **Code review tracking**: Track PR reviews as tasks

## Limitations & Challenges

### What You CAN'T Do

1. **No Background Execution**
   - Scripts only run when triggered manually or via plugin actions
   - No automatic triggers on task completion, due date changes, etc.
   - No scheduled/cron-like execution

2. **No Push Notifications**
   - Cannot send external notifications
   - Cannot trigger webhooks automatically

3. **No Direct Database Triggers**
   - Cannot listen for database changes
   - No event-driven architecture

4. **Limited File System Access**
   - Sandboxed environment
   - Need explicit permission (URL.Bookmark) for file access

5. **No REST API**
   - OmniFocus doesn't expose a REST API for external access
   - All automation must run within the app

6. **Platform Limitations**
   - Some features may differ between macOS and iOS
   - iOS has more restrictions on file access

### Workarounds

1. **For Automatic Triggers**: Use iOS Shortcuts or macOS Automator to periodically run OmniFocus plugins
2. **For Webhooks**: Combine with external services (Zapier, Make.com) that poll OmniFocus
3. **For Background Tasks**: Use system-level automation tools (Keyboard Maestro, Hazel, cron) to trigger scripts

## Plugin Development

### Plugin Structure
```javascript
(() => {
    // Plugin setup
    const action = new PlugIn.Action(function(selection, sender) {
        // Your automation code here
        const tasks = selection.tasks;
        tasks.forEach(task => {
            // Do something with each task
        });
    });
    
    action.validate = function(selection, sender) {
        // Return true if action should be enabled
        return selection.tasks.length > 0;
    };
    
    return action;
})();
```

### Plugin Types
- **Action**: Performs an operation on selected items
- **Library**: Reusable functions for other plugins
- **Form**: Collects user input before executing

## Best Practices

1. **Error Handling**: Always wrap API calls in try-catch
2. **Credentials**: Use Credentials class for sensitive data
3. **Validation**: Check for null/undefined before accessing properties
4. **Performance**: Use `flattenedTasks` for bulk operations instead of recursive traversal
5. **User Feedback**: Use `Alert` class to show results/errors
6. **Testing**: Use the Console extensively before creating plugins

## Recommended Automation Ideas

### High-Value Automations
1. **AI Task Clarifier**: Weekly review that sends vague tasks to AI for clarification suggestions
2. **Stale Task Reporter**: Identify tasks older than X days without progress
3. **JIRA Sync**: Bidirectional sync of assigned issues
4. **GitHub Issue Importer**: Import issues with specific labels as tasks
5. **Smart Tagging**: AI-powered tag suggestions based on task content
6. **Duplicate Detector**: Find similar tasks across projects
7. **Project Health Dashboard**: Export project status to external dashboard
8. **Time Estimate Validator**: AI reviews estimated times for realism

### Integration Architecture
```
OmniFocus Plugin → HTTP Request → External API (Claude/JIRA/GitHub)
                                         ↓
                                   Process Response
                                         ↓
                                Update OmniFocus Tasks
```

## Resources

- **Official API Documentation**: Built into OmniFocus (Automation Console → API Reference tab)
- **Omni Automation Website**: https://omni-automation.com/omnifocus/
- **Plugin Examples**: https://omni-automation.com/omnifocus/actions.html
- **Community Forum**: https://discourse.omnigroup.com/c/omnifocus
- **Tutorial**: https://omni-automation.com/omnifocus/tutorial/

## Next Steps

1. Enable Developer Mode in OmniFocus
2. Open Automation Console and explore the API Reference
3. Test simple scripts in the Console (e.g., `inbox.forEach(t => console.log(t.name))`)
4. Create a simple plugin to automate a repetitive task
5. Build HTTP integration with external API (start with a simple GET request)
6. Develop AI-powered task analysis automation
7. Create JIRA/GitHub integration plugins

## Conclusion

OmniFocus's JavaScript API is powerful for client-side automation and can be extended to integrate with external services through HTTP requests. While it lacks automatic triggers and a REST API, creative use of the URL.FetchRequest class enables rich integrations with AI services, JIRA, GitHub, and other tools. The key is to think of OmniFocus as the orchestrator that you manually trigger (or trigger via system automation) to sync with external systems.

