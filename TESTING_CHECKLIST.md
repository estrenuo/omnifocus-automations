# Testing Checklist for OmniFocus Plugins

Use this checklist to verify both plugins are working correctly after installation.

## Pre-Testing Setup

### Prerequisites
- [ ] OmniFocus 4 installed (macOS or iOS)
- [ ] Developer Mode enabled in OmniFocus
- [ ] OpenAI API key obtained (with GPT-5 access) **and/or** Anthropic API key obtained
- [ ] JIRA API token obtained
- [ ] Active internet connection

### Plugin Installation
- [ ] `AI-Task-Clarifier.omnifocusjs` installed
- [ ] `AI-Task-Breakdown.omnifocusjs` installed
- [ ] `Headless-Settings.omnifocusjs` installed
- [ ] `JIRA-Import.omnifocusjs` installed
- [ ] All plugins visible in Automation menu

## AI Task Clarifier Testing

### Initial Setup
- [ ] Run plugin for first time
- [ ] Prompted to choose AI provider (ChatGPT or Claude)
- [ ] Prompted for API key (provider-specific label shown)
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
- [ ] Search for "openai" or "anthropic" (depending on provider)
- [ ] Verify entry exists
- [ ] Delete the entry
- [ ] Run plugin again
- [ ] Prompted for API key again

**Expected Results:**
- [ ] Credentials stored securely
- [ ] Re-prompting works correctly

### Test Case 7: Provider Selection
**Test:**
- [ ] Run plugin with stored credentials
- [ ] Click "Switch AI Provider"
- [ ] Verify provider toggles (ChatGPT → Claude or vice versa)
- [ ] If no credentials for new provider: prompted for API key
- [ ] If credentials exist: used automatically
- [ ] Verify analysis completes with new provider

**Expected Results:**
- [ ] Provider preference saved
- [ ] Subsequent runs use new provider
- [ ] Progress alert shows correct provider name

### Test Case 8: Headless Mode with Provider
**Test:**
- [ ] Open Headless Settings
- [ ] Set AI Provider to Claude
- [ ] Enable headless mode
- [ ] Run AI Clarifier (headless should use Claude silently)

**Expected Results:**
- [ ] Provider preference read correctly in headless mode
- [ ] No dialogs shown
- [ ] API call goes to correct provider

### Error Handling Tests
**Test Invalid API Key:**
- [ ] Delete stored key from Keychain
- [ ] Run plugin with invalid key
- [ ] Verify error message: "API Error: 401"

**Test Network Failure:**
- [ ] Disconnect internet
- [ ] Run plugin
- [ ] Verify appropriate error message

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
3. [ ] Verify both work together

**Expected Results:**
- [ ] JIRA tasks imported successfully
- [ ] AI analysis works on JIRA tasks
- [ ] Both sets of tags/notes coexist
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

## Edge Cases

### AI Task Clarifier
- [ ] Empty task name
- [ ] Very long task name (500+ chars)
- [ ] Task with no note
- [ ] Task with very long note (10,000+ chars)
- [ ] Task with special characters in name
- [ ] Task with emoji in name

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

