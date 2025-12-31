# Workflow 4: Weekly Review (Solo Dev)

**When:** Friday evening, 5 PM
**Duration:** 30 minutes
**Output:** `docs/plan/week-X/summary.md` + update `master-progress.md`

---

## What to Do

Spend 30 minutes reflecting on the week.

### Part 1: What Happened (10 min)

Write down:
- ✅ What got done vs planned
- ❌ What didn't get done
- 🎯 Reasons why

Example:
```
DONE:
- All UI buttons complete
- Status display working
- Layout responsive

NOT DONE:
- Keyboard shortcuts (moved to Week 3)

REASON:
- UI took longer than estimated (button constraints)
- But we're still on track overall
```

### Part 2: Reflections (10 min)

Write answers to:

**What went well?**
- What was easier?
- What decision worked?

**What was harder?**
- What took longer?
- What surprised you?

**What to improve?**
- What should you do differently next week?
- What patterns did you notice?

Example:
```
WENT WELL:
- Design mockups were clear, no rework
- SwiftUI preview saved time

HARDER:
- Button constraints trickier than expected
- iPad layout needed fixes

IMPROVE:
- Test on all devices earlier (not Friday)
- Budget more time for constraints work
- Use preview-first approach
```

### Part 3: Metrics (5 min)

Write:
- Hours estimated vs actual
- What you accomplished
- Any blockers

Example:
```
METRICS:
- Estimated: 40 hours
- Actual: 38 hours (5% ahead)
- Velocity: 5 UI components done
- Quality: 0 errors, 100% tests

BLOCKERS:
- None, all resolved same day
```

### Part 4: Next Week (5 min)

Based on this week:
- What should change?
- What scope should adjust?
- Any risks to watch?

---

## Can AI Help?

Ask AI to help draft your summary:

```
"Draft week-X summary following solo/04-weekly-review/ai-prompt.md

This week:
- Estimated 40 hours, Actual 38 hours
- Completed: [list]
- Blockers: [list]
- Learnings: [list]

Generate summary.md with reflection and metrics"
```

AI drafts it. You review and customize.

---

## Update Master Progress

Add a line to `master-progress.md`:

```
## Week 1 Results
- Completed UI components (5 elements)
- 38 hours actual vs 40 estimated (5% ahead)
- Quality: 0 errors, 100% tests
- Next: Backend integration
```

---

## Checklist

- [ ] What got done / didn't get done documented
- [ ] Reflections written (went well, harder, improve)
- [ ] Metrics recorded (hours, velocity)
- [ ] Next week's adjustments noted
- [ ] Master progress updated

---

## Next

Monday: Go to [Workflow 2: Weekly Plan](../02-weekly-plan/) for next week
