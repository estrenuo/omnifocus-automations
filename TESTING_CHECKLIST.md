# Testing Checklist for OmniFocus Plugins

Use this checklist to verify both plugins are working correctly after installation.

## Pre-Testing Setup

### Prerequisites
- [ ] OmniFocus 4 installed (macOS or iOS)
- [ ] Developer Mode enabled in OmniFocus
- [ ] OpenAI API key obtained (with GPT-5 access)
- [ ] JIRA API token obtained
- [ ] Active internet connection

### Plugin Installation
- [ ] `AI-Task-Clarifier.omnifocusjs` installed
- [ ] `AI-Task-Breakdown.omnifocusjs` installed
- [ ] `JIRA-Import.omnifocusjs` installed
- [ ] All plugins visible in Automation menu

## AI Task Clarifier Testing

### Initial Setup
- [ ] Run plugin for first time
- [ ] Prompted for OpenAI API key
- [ ] API key entered and accepted
- [ ] No error messages displayed

### Test Case 1: Analyze Selected Tasks
**Setup:**
1. Create test tasks:
   - "Think about project" (vague)
   - "Do everything for website launch" (too broad)
   - "Call dentist about appointment on Tuesday" (good task)

**Test:**
- [ ] Select the three test tasks
- [ ] Run "AI Task Clarifier" from Automation menu
- [ ] Wait for analysis to complete (10-30 seconds)

**Expected Results:**
- [ ] Analysis completes without errors
- [ ] Summary shows tasks analyzed
- [ ] "AI: Needs Improvement" tag created
- [ ] Vague/broad tasks tagged with "AI: Needs Improvement"
- [ ] AI suggestions added to task notes
- [ ] High-severity issues flagged
- [ ] Good task may not be flagged (or low severity)

**Verify Task Notes:**
- [ ] Notes contain "AI IMPROVEMENT SUGGESTION" section
- [ ] Issue type identified (vague/broad/etc.)
- [ ] Severity level shown (low/medium/high)
- [ ] Specific suggestion provided
- [ ] Recommended action listed

### Test Case 2: Analyze All Tasks
**Setup:**
1. Create 5-10 tasks with various quality levels
2. Don't select any tasks

**Test:**
- [ ] Run "AI Task Clarifier" from Automation menu
- [ ] Choose "All incomplete tasks" scope
- [ ] Confirm analysis

**Expected Results:**
- [ ] All incomplete tasks analyzed
- [ ] Summary shows correct count
- [ ] Problematic tasks identified and tagged
- [ ] No errors or crashes

### Test Case 3: Analyze Old Tasks
**Setup:**
1. Manually set some task "added" dates to 60+ days ago (requires editing in database or waiting)
2. Or skip this test if not feasible

**Test:**
- [ ] Run "AI Task Clarifier"
- [ ] Choose "Tasks older than 30 days" scope

**Expected Results:**
- [ ] Only old tasks analyzed
- [ ] Stale tasks identified
- [ ] Summary shows correct count

### Test Case 4: No Tasks Selected
**Test:**
- [ ] Don't select any tasks
- [ ] Run plugin
- [ ] Choose "Selected tasks only"

**Expected Results:**
- [ ] Error message: "No tasks selected"
- [ ] Plugin exits gracefully

### Test Case 5: Large Batch
**Setup:**
1. Create or select 60+ tasks

**Test:**
- [ ] Select all tasks
- [ ] Run plugin

**Expected Results:**
- [ ] Warning about 50 task limit
- [ ] Option to continue or cancel
- [ ] Only first 50 tasks analyzed if continued

### Test Case 6: API Key Management
**Test:**
- [ ] Open Keychain Access
- [ ] Search for "openai"
- [ ] Verify entry exists
- [ ] Delete the entry
- [ ] Run plugin again
- [ ] Prompted for API key again

**Expected Results:**
- [ ] Credentials stored securely
- [ ] Re-prompting works correctly

### Test Case 7: Analyze Selected Projects
**Setup:**
1. Create test projects:
   - "Stuff" (vague project name)
   - "Redesign company website with new brand guidelines" (good project name)

**Test:**
- [ ] Select both projects
- [ ] Run "AI Task Clarifier" from Automation menu
- [ ] Wait for analysis to complete

**Expected Results:**
- [ ] Projects analyzed alongside tasks
- [ ] Vague project tagged with "AI: Needs Improvement" (via `project.task.addTag()`)
- [ ] Suggestions added to project notes
- [ ] Good project may not be flagged
- [ ] Projects sent to AI with `type: "project"` for context-aware analysis

### Test Case 8: Project with No Tasks Falls Back to Scope Selection
**Setup:**
1. Create or select a project with no tasks

**Test:**
- [ ] Select the empty project
- [ ] Run "AI Task Clarifier"

**Expected Results:**
- [ ] Falls back to scope selection dialog
- [ ] Can choose "All incomplete tasks" or "Tasks older than 30 days"

### Error Handling Tests
**Test Invalid API Key:**
- [ ] Delete stored key from Keychain
- [ ] Run plugin with invalid key
- [ ] Verify error message: "API Error: 401"

**Test Network Failure:**
- [ ] Disconnect internet
- [ ] Run plugin
- [ ] Verify appropriate error message

## AI Task Breakdown Testing

### Initial Setup
- [ ] Run plugin for first time
- [ ] Prompted for OpenAI API key
- [ ] API key entered and accepted
- [ ] No error messages displayed

### Test Case 1: Break Down Selected Task
**Setup:**
1. Create a task: "Plan team offsite"

**Test:**
- [ ] Select the task
- [ ] Run "AI Task Breakdown" from Automation menu
- [ ] Wait for breakdown (30-60 seconds)

**Expected Results:**
- [ ] Subtasks created as children of parent task
- [ ] 2-10 subtasks created depending on complexity
- [ ] All subtasks tagged "AI: Suggested"
- [ ] Parent task note updated with breakdown info
- [ ] Summary shows tasks processed and subtasks created

### Test Case 2: Break Down Selected Project
**Setup:**
1. Create a project: "Launch new website"

**Test:**
- [ ] Select the project
- [ ] Run "AI Task Breakdown" from Automation menu
- [ ] Wait for breakdown

**Expected Results:**
- [ ] Top-level tasks created inside the project (not subtasks of a task)
- [ ] 2-10 tasks created depending on complexity
- [ ] All tasks tagged "AI: Suggested"
- [ ] Project note updated with breakdown info

### Test Case 3: Mixed Selection (Tasks and Projects)
**Test:**
- [ ] Select 1 task and 1 project
- [ ] Run "AI Task Breakdown"

**Expected Results:**
- [ ] Task gets subtasks, project gets top-level tasks
- [ ] Both processed correctly
- [ ] Summary shows correct counts

### Test Case 4: No Selection
**Test:**
- [ ] Don't select any tasks or projects
- [ ] Run plugin

**Expected Results:**
- [ ] Error message about no selection
- [ ] Plugin exits gracefully

### Test Case 5: Too Many Items
**Setup:**
1. Select 6+ tasks/projects

**Test:**
- [ ] Run plugin

**Expected Results:**
- [ ] Warning about 5 item limit
- [ ] Only first 5 items processed

## JIRA Import Testing

### Initial Setup
- [ ] Run plugin for first time
- [ ] Prompted for JIRA credentials
- [ ] Domain entered (e.g., `company.atlassian.net`)
- [ ] Email entered
- [ ] API token entered
- [ ] Project key entered (or left empty)
- [ ] Credentials accepted
- [ ] No error messages

### Test Case 1: Basic Import
**Prerequisites:**
- At least 3-5 open issues in JIRA

**Test:**
- [ ] Run "Import JIRA Issues" from Automation menu
- [ ] Wait for import to complete

**Expected Results:**
- [ ] Import completes without errors
- [ ] "JIRA" folder created in library
- [ ] "JIRA Issues" project created in folder
- [ ] Tasks created for each open issue
- [ ] Summary shows correct counts

**Verify Task Structure:**
- [ ] Task names: `[JIRA-KEY] Summary`
- [ ] Tasks in "JIRA Issues" project
- [ ] "JIRA" tag applied to all tasks

**Verify Task Notes:**
- [ ] Contains "JIRA: KEY"
- [ ] Contains clickable URL
- [ ] Contains status, type, priority
- [ ] Contains assignee (if set)
- [ ] Contains reporter
- [ ] Contains created/updated dates
- [ ] Contains full description

**Verify Tags:**
- [ ] Base "JIRA" tag exists
- [ ] Priority tags created (e.g., "Priority: High")
- [ ] Type tags created (e.g., "Type: Bug")
- [ ] Label tags created (if issues have labels)
- [ ] Component tags created (if issues have components)

**Verify Due Dates:**
- [ ] Tasks with JIRA due dates have OmniFocus due dates
- [ ] Dates match correctly

### Test Case 2: Duplicate Prevention
**Test:**
- [ ] Run import again immediately
- [ ] Wait for completion

**Expected Results:**
- [ ] Import completes
- [ ] Summary shows "0 new tasks created"
- [ ] Summary shows "X skipped (already imported)"
- [ ] No duplicate tasks created
- [ ] Existing tasks unchanged

### Test Case 3: Project Filter
**Test:**
- [ ] Delete stored credentials from Keychain
- [ ] Run plugin again
- [ ] Enter credentials with specific project key (e.g., "PROJ")

**Expected Results:**
- [ ] Only issues from specified project imported
- [ ] Other projects' issues not imported

### Test Case 4: Empty Result Set
**Setup:**
- Use a project key with no open issues, or resolve all issues

**Test:**
- [ ] Run import

**Expected Results:**
- [ ] Message: "No open JIRA issues found"
- [ ] No tasks created
- [ ] No errors

### Test Case 5: Field Mapping Verification
**Setup:**
- Create a JIRA issue with all fields populated:
  - Summary
  - Description
  - Priority
  - Type
  - Labels (2-3 labels)
  - Components (1-2 components)
  - Due date
  - Assignee

**Test:**
- [ ] Import the issue
- [ ] Verify all fields mapped correctly

**Expected Results:**
- [ ] Summary → Task name (with key prefix)
- [ ] Description → Task note
- [ ] Priority → Tag
- [ ] Type → Tag
- [ ] Labels → Individual tags
- [ ] Components → Individual tags
- [ ] Due date → Task due date
- [ ] Assignee → In note metadata

### Test Case 6: Credential Management
**Test:**
- [ ] Open Keychain Access
- [ ] Search for "jira"
- [ ] Verify "jira" and "jira-settings" entries exist
- [ ] Delete both entries
- [ ] Run plugin again
- [ ] Prompted for credentials again

**Expected Results:**
- [ ] Credentials stored securely
- [ ] Re-prompting works correctly

### Error Handling Tests
**Test Invalid Credentials:**
- [ ] Delete stored credentials
- [ ] Run plugin with invalid email/token
- [ ] Verify error message: "JIRA API Error: 401"

**Test Invalid Domain:**
- [ ] Delete stored credentials
- [ ] Run plugin with invalid domain
- [ ] Verify error message: "JIRA API Error: 404"

**Test Network Failure:**
- [ ] Disconnect internet
- [ ] Run plugin
- [ ] Verify appropriate error message

## Integration Testing

### Test Case 1: Combined Workflow
**Test:**
1. [ ] Import JIRA issues
2. [ ] Run AI Task Clarifier on imported tasks
3. [ ] Run AI Task Breakdown on a complex imported task
4. [ ] Verify all plugins work together

**Expected Results:**
- [ ] JIRA tasks imported successfully
- [ ] AI analysis works on JIRA tasks
- [ ] AI breakdown creates subtasks for JIRA tasks
- [ ] All sets of tags/notes coexist ("JIRA", "AI: Needs Improvement", "AI: Suggested")
- [ ] No conflicts or errors

### Test Case 2: Multiple Runs
**Test:**
1. [ ] Run JIRA import
2. [ ] Create new JIRA issue
3. [ ] Run import again
4. [ ] Run AI Clarifier
5. [ ] Create more tasks
6. [ ] Run AI Clarifier again

**Expected Results:**
- [ ] All operations work correctly
- [ ] No degradation over multiple runs
- [ ] No memory leaks or slowdowns

## Performance Testing

### AI Task Clarifier
- [ ] Test with 10 tasks: < 15 seconds
- [ ] Test with 30 tasks: < 30 seconds
- [ ] Test with 50 tasks: < 60 seconds

### JIRA Import
- [ ] Test with 10 issues: < 10 seconds
- [ ] Test with 50 issues: < 30 seconds
- [ ] Test with 100 issues: < 60 seconds

### AI Task Breakdown
- [ ] Test with 1 task: < 30 seconds
- [ ] Test with 3 tasks: < 60 seconds
- [ ] Test with 5 tasks: < 90 seconds

## Edge Cases

### AI Task Clarifier
- [ ] Empty task name
- [ ] Very long task name (500+ chars)
- [ ] Task with no note
- [ ] Task with very long note (10,000+ chars)
- [ ] Task with special characters in name
- [ ] Task with emoji in name
- [ ] Project with no tasks (should fall back to scope selection)
- [ ] Project with very long name
- [ ] Mixed selection of tasks and projects

### AI Task Breakdown
- [ ] Task with no note (AI uses name only)
- [ ] Task with very long name
- [ ] Project with existing tasks (new tasks added alongside)
- [ ] Already-broken-down task (has subtasks)

### JIRA Import
- [ ] Issue with no description
- [ ] Issue with very long description
- [ ] Issue with no assignee
- [ ] Issue with no due date
- [ ] Issue with no labels/components
- [ ] Issue with special characters in summary

## Final Verification

### Documentation
- [ ] README.md reviewed
- [ ] PLUGIN_SETUP_GUIDE.md reviewed
- [ ] TECHNICAL_REFERENCE.md reviewed
- [ ] All instructions clear and accurate

### User Experience
- [ ] Plugins easy to install
- [ ] Credential entry straightforward
- [ ] Error messages helpful
- [ ] Results clearly communicated
- [ ] No confusing behavior

### Security
- [ ] Credentials stored in Keychain
- [ ] No plaintext passwords in logs
- [ ] HTTPS used for all API calls
- [ ] No sensitive data in error messages

## Test Results Summary

**Date Tested:** _______________

**Tester:** _______________

**OmniFocus Version:** _______________

**macOS/iOS Version:** _______________

### AI Task Clarifier
- [ ] All tests passed
- [ ] Issues found: _______________
- [ ] Notes: _______________

### AI Task Breakdown
- [ ] All tests passed
- [ ] Issues found: _______________
- [ ] Notes: _______________

### JIRA Import
- [ ] All tests passed
- [ ] Issues found: _______________
- [ ] Notes: _______________

### Overall Assessment
- [ ] Ready for production use
- [ ] Needs fixes (list below)
- [ ] Needs improvements (list below)

**Issues/Improvements:**
_______________________________________________
_______________________________________________
_______________________________________________

**Signature:** _______________

