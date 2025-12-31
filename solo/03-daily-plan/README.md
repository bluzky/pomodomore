# Workflow 3: Daily Plan (Solo Dev)

**When:** Every morning, 9 AM
**Duration:** 10 minutes (+ ask AI to generate)
**Output:** `docs/plan/week-X/day-Y-plan.md`

---

## What to Do

Create a detailed plan for today in 10 minutes.

### Step 1: Review Week Plan (2 min)

Check today's goal from `week-X-plan.md`

Example: "Recording button setup and visual states"

### Step 2: Define Done (3 min)

Write specific, testable criteria:

✅ Good:
- User can tap Record button
- Button changes text to "Stop"
- All buttons are visible and spaced correctly
- All tests pass
- Build clean

❌ Bad:
- Recording buttons work
- Tests pass
- No errors

### Step 3: Ask AI (5 min)

Ask AI to generate your day plan:

```
"Create day-1-plan.md following solo/03-daily-plan/ai-prompt.md

Goal: [Today's goal from weekly plan]
Time: ~8 hours

Generate 3-4 specific tasks with acceptance criteria"
```

AI generates complete plan. Done!

---

## What's in Your Day Plan

- **Definition of Done** (specific, testable)
- **3-4 Tasks** (each with what, why, acceptance criteria)
- **Testing Strategy** (what to test, how)
- **Implementation Notes** (architecture, known challenges)
- **Execution Section** (fill during day)

---

## During the Day

1. **Follow the plan** — Work on tasks in order
2. **Work with AI** — Stuck? Ask AI for help
3. **Log progress** — Every 1-2 hours, note time
4. **Test as you go** — Don't wait until end

---

## At 5 PM

1. **Complete execution section**
   - Mark tasks done/incomplete
   - Log actual hours
   - Note any blockers

2. **Verify quality**
   - Tests passing?
   - Build clean?
   - Manual testing done?

3. **Update progress.md**
   - What got done
   - Actual time
   - Any blockers

4. **Tomorrow prep** (optional)
   - Ask AI to create tomorrow's plan

---

## Can You Do This Yourself?

You can create the day plan manually if you prefer, but AI can do it in 2 minutes. Save the time, use AI.

---

## Checklist

- [ ] Definition of Done is specific
- [ ] 3-4 clear tasks
- [ ] Each task has acceptance criteria
- [ ] Testing approach clear
- [ ] You understand what "done" means

---

## Next

Work through your day. At 5 PM, log results in `progress.md`.

Friday: Go to [Workflow 4: Weekly Review](../04-weekly-review/)
