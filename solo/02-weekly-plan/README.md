# Workflow 2: Weekly Plan (Solo Dev)

**When:** Every Monday, 9 AM
**Duration:** 30 minutes
**Output:** `docs/plan/week-X-plan.md`

---

## What to Do

Plan your week in 30 minutes.

### Step 1: Review Context (5 min)

Check:
- [ ] Read project plan
- [ ] Read last week's summary (if Week 2+)
- [ ] How many hours do you have? (usually 40)

### Step 2: Set Week Goal (5 min)

1 sentence: What will exist by Friday?

Example:
> "All recording UI controls implemented and responsive"

### Step 3: Daily Breakdown (15 min)

For each of 5 days, write:
- **Goal:** What gets done
- **Hours:** Estimate (usually 7-8 per day)
- **Deliverable:** What you test Friday

Example:
```
DAY 1 (Monday): Set up project, build basic buttons
  ~8 hours | Test: All buttons render, clickable

DAY 2 (Tuesday): Add status display and updates
  ~8 hours | Test: Status changes on button click

DAY 3 (Wednesday): Polish layout and styling
  ~8 hours | Test: Layout matches design on device

DAY 4 (Thursday): Handle edge cases and states
  ~7 hours | Test: All state transitions work

DAY 5 (Friday): Testing and preparation for integration
  ~6 hours | Test: Full workflow end-to-end
```

### Step 4: Fill Template (5 min)

Copy [template.md](./template.md) to `docs/plan/week-X-plan.md`

---

## Can AI Help?

Ask AI to break down your week:

```
"Plan my week following solo/02-weekly-plan/ai-prompt.md

Goal: [what you want done by Friday]
Previous week: [velocity data if Week 2+]

Generate week-X-plan.md"
```

AI will create daily breakdown with realistic estimates.

---

## Checklist

- [ ] Week goal is clear (1 sentence)
- [ ] 5 days defined with goals
- [ ] Daily hours total ~35-40
- [ ] Deliverables are testable
- [ ] You understand each day's target

---

## Next

Tomorrow morning: Go to [Workflow 3: Daily Plan](../03-daily-plan/)
