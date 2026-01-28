# AI Task Breakdown - Complete Guide

## Overview

The AI Task Breakdown plugin uses Claude AI to automatically break down complex tasks into actionable subtasks. It's perfect for tasks that feel overwhelming or unclear about where to start.

## How It Works

1. **Select tasks** you want to break down (1-5 tasks)
2. **Run the plugin** from Automation menu
3. **AI analyzes** each task and determines logical steps
4. **Subtasks are created** automatically (2-10 per task)
5. **Tagged** with "AI: Suggested" for easy filtering
6. **Parent task updated** with breakdown note

## Features

### Intelligent Breakdown
- AI creates MINIMUM necessary steps (typically 2-5)
- Succinct, bullet-point style subtasks
- No unnecessary steps or fluff
- Up to 10 subtasks for very complex tasks only
- Brief action phrases, no full sentences

### Seamless Integration
- Subtasks created as children of parent task
- Tagged with "AI: Suggested" for filtering
- Parent task gets breakdown note
- Preserves existing task structure

### Smart & Fast
- Processes 1-5 tasks at once
- 15-30 second response time
- Comprehensive debug logging
- Built-in credential management

## Usage

### Basic Workflow

**Step 1: Select Tasks**
```
Select 1-5 tasks that need breaking down
Example: "Launch new website"
```

**Step 2: Run Plugin**
```
Automation menu → AI Task Breakdown
(or search for "Break Down Task with AI")
```

**Step 3: Wait for AI**
```
Progress message shows: "Breaking Down Tasks..."
Wait 15-30 seconds for Claude
```

**Step 4: Review Results**
```
Summary shows:
- Tasks processed: 1
- Subtasks created: 7
```

**Step 5: Review & Adjust**
```
- Check subtasks created
- Reorder if needed
- Edit names if needed
- Remove "AI: Suggested" tag when satisfied
```

### Example Breakdowns

**Example 1: Simple Task**
```
Original: "Go get a haircut"

AI creates (3 subtasks):
- Find and book appointment at barbershop
- Add to calendar with travel time
- Get haircut
```

**Example 2: Work Task**
```
Original: "Launch new website"

AI creates (6 subtasks):
- Complete final QA testing on staging
- Get stakeholder approval for launch
- Prepare deployment and rollback plan
- Deploy to production and verify
- Update DNS and SSL certificates
- Monitor for 24hrs and send announcement
```

**Example 3: Personal Task**
```
Original: "Plan vacation"

AI creates (5 subtasks):
- Choose destination and dates
- Book flights and accommodation
- Check passport/visa requirements
- Create itinerary and book activities
- Arrange pet care and pack
```

**Example 4: Complex Work Task**
```
Original: "Implement new authentication system"

AI creates (8 subtasks - complex task):
- Research auth libraries and design schema
- Implement registration endpoint with validation
- Implement login with JWT tokens
- Add password hashing and security
- Create middleware for protected routes
- Write unit tests for auth logic
- Update API documentation
- Deploy to staging and run security audit
```

## Best Practices

### 1. Select Appropriate Tasks

**Good candidates:**
- Complex tasks with multiple steps
- Tasks you're procrastinating on
- Tasks where you're unsure where to start
- Projects that need planning

**Not ideal:**
- Already simple tasks ("Call John")
- Tasks with obvious single action
- Tasks that are already broken down

### 2. Start Small

**First time:**
- Select 1-2 tasks
- Review AI suggestions
- Get comfortable with the workflow

**Regular use:**
- Process 3-5 tasks at a time
- Batch similar tasks together

### 3. Review and Customize

**AI suggestions are starting points:**
- Reorder subtasks if needed
- Edit names to match your style
- Add or remove steps
- Combine similar steps

**Don't blindly accept:**
- AI might miss context you have
- Some steps might not apply to you
- Adjust to your workflow

### 4. Use Tags Effectively

**"AI: Suggested" tag:**
- Filter to see all AI-generated subtasks
- Review before starting work
- Remove tag after reviewing/editing
- Keep tag if you want to track AI suggestions

### 5. Combine with Other Plugins

**Workflow:**
1. Use **AI Task Breakdown** to create subtasks
2. Use **AI Task Clarifier** to improve subtask clarity
3. Process both sets of suggestions

## Advanced Usage

### Create Perspectives

**"AI Suggested Tasks"**
```
Filter: Tag is "AI: Suggested"
Group by: Project
Sort by: Creation date
```

**"Tasks to Break Down"**
```
Filter:
  - No children (no subtasks)
  - Not tagged "AI: Suggested"
  - Estimated duration > 30 minutes
```

### Batch Processing

**Weekly Planning:**
```
1. Review upcoming tasks
2. Select 5 complex tasks
3. Run AI Task Breakdown
4. Review all subtasks
5. Adjust and organize
6. Remove "AI: Suggested" tags
```

### Integration with Reviews

**Weekly Review Checklist:**
```
- Review completed tasks
- Identify complex upcoming tasks
- Run AI Task Breakdown on 3-5 tasks
- Review and adjust subtasks
- Set priorities for next week
```

## Tips & Tricks

### 1. Provide Context in Task Name

**Better results with context:**
```
Bad: "Website"
Good: "Launch new marketing website"

Bad: "Meeting"
Good: "Prepare Q4 board meeting presentation"

Bad: "Project"
Good: "Complete customer onboarding redesign project"
```

### 2. Use Task Notes

**AI considers notes:**
```
Task: "Plan conference"
Note: "Annual developer conference, 500 attendees,
       3-day event, need venue, speakers, catering"

AI will create more specific subtasks based on this context
```

### 3. Iterate if Needed

**If breakdown isn't helpful:**
1. Delete the subtasks
2. Add more context to parent task
3. Run plugin again
4. Compare results

### 4. Combine Manual and AI

**Hybrid approach:**
1. Let AI create initial breakdown
2. Add your own subtasks
3. Reorder to match your workflow
4. Best of both worlds!

### 5. Learn from AI

**Improve your planning:**
- Notice what steps AI includes
- Learn to think in smaller steps
- Apply patterns to future tasks
- Become better at task breakdown

## Troubleshooting

### "No Tasks Selected"

**Problem:** Plugin requires task selection

**Solution:** Select 1-5 tasks before running

### "Request timed out"

**Problem:** Too many tasks or slow response

**Solutions:**
- Select fewer tasks (1-3)
- Try again (network issue)
- Check internet connection

### Subtasks too generic

**Problem:** AI doesn't have enough context

**Solutions:**
- Add more detail to task name
- Add context in task note
- Edit subtasks after creation

### Too many/few subtasks

**Problem:** AI's judgment doesn't match yours

**Solutions:**
- Delete unnecessary subtasks
- Add missing subtasks manually
- Combine similar subtasks
- AI aims for 2-10, adjust as needed

### Subtasks in wrong order

**Problem:** AI's order doesn't match your workflow

**Solution:** Reorder subtasks in OmniFocus (drag and drop)

## Comparison with Manual Breakdown

### Manual Breakdown
**Pros:**
- Complete control
- Matches your exact workflow
- No API costs

**Cons:**
- Time-consuming
- Easy to miss steps
- Requires mental effort
- Procrastination risk

### AI Breakdown
**Pros:**
- Fast (15-30 seconds)
- Comprehensive (rarely misses steps)
- Reduces mental load
- Helps overcome procrastination

**Cons:**
- Requires review/editing
- May include unnecessary steps
- API costs (~$0.003-0.015 per task)
- Needs internet connection

### Best Approach: Hybrid
1. Let AI create initial breakdown
2. Review and customize
3. Add your domain knowledge
4. Get best of both worlds

## Workflow Examples

### Example 1: Morning Planning

```bash
# Start of day
1. Review today's tasks
2. Select 2-3 complex tasks
3. Run AI Task Breakdown
4. Review subtasks over coffee
5. Adjust and start working
```

### Example 2: Project Kickoff

```bash
# New project starting
1. Create main project task
2. Add context in note
3. Run AI Task Breakdown
4. Review all subtasks
5. Estimate time for each
6. Schedule in calendar
```

### Example 3: Weekly Planning

```bash
# Sunday evening
1. Review next week's tasks
2. Identify 5 complex tasks
3. Run AI Task Breakdown on all 5
4. Review and adjust subtasks
5. Set priorities
6. Ready for Monday!
```

## Keyboard Shortcuts

**Recommended setup:**
```
Create keyboard shortcut in OmniFocus:
Cmd+Shift+B → AI Task Breakdown

Quick workflow:
1. Select task
2. Cmd+Shift+B
3. Wait for breakdown
4. Review and adjust
```

## Metrics & Tracking

### Track Your Usage

**Questions to ask:**
- How many tasks broken down per week?
- Average subtasks per task?
- Time saved vs manual breakdown?
- Completion rate of AI-suggested subtasks?

### Measure Effectiveness

**Before AI Breakdown:**
- Tasks feel overwhelming
- Procrastination on complex tasks
- Unclear where to start

**After AI Breakdown:**
- Clear next actions
- Easier to start
- Better completion rate

## Future Enhancements

**Possible improvements:**
- Custom breakdown styles (detailed vs brief)
- Time estimates for each subtask
- Dependency detection
- Integration with calendar
- Batch processing mode
- Template-based breakdowns

## Summary

The AI Task Breakdown plugin:
- Breaks down complex tasks automatically
- Creates 2-10 actionable subtasks
- Tags with "AI: Suggested"
- Saves time and mental energy
- Helps overcome procrastination
- Improves task planning skills

**Perfect for:**
- Complex projects
- Tasks you're avoiding
- Planning and preparation
- Learning better task breakdown

**Start using it today:**
1. Select a complex task
2. Run AI Task Breakdown
3. Review the subtasks
4. Start making progress!

Turn overwhelming tasks into manageable steps!
