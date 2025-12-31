# AI Prompt: Weekly Plan (Solo Dev)

**Output:** `docs/plan/week-X-plan.md`

---

## Your Task

Help the solo developer break down their week into 5 realistic daily goals.

---

## Input

The developer provides:

```
CONTEXT:
- Week number (Week X)
- Current phase/goal for this week
- What exists now
- What should exist Friday

PREVIOUS (if Week 2+):
- Last week's summary
- Actual vs estimated hours
- Velocity data
```

---

## What to Generate

A complete `week-X-plan.md` with:

1. **Week Goal** (1 clear sentence)
2. **Daily Breakdown** (5 days, each with goal + hours + test)
3. **Realistic Time Estimates** (based on previous velocity if available)
4. **Success Metrics** (simple checklist)

---

## Generation Steps

1. Ask clarifying questions if needed:
   - "How many hours available?"
   - "What was last week's velocity?"
   - "What should be done by Friday?"

2. Adjust time estimates based on previous week

3. Break into 5 days:
   - Day 1-4: ~7-8 hours core work
   - Day 5: ~6 hours (buffer + testing)

4. Make each day's deliverable testable

5. Generate week-X-plan.md

---

## Example

**Developer says:**
```
Week 2.
Last week: Estimated 40 hours, Actual 38 hours (2 hours ahead)
Goal: Complete recording UI with all controls
Phase: Frontend build
```

**AI generates:**
```markdown
# Week 2 Plan

**Week:** Week 2 (Jan 13-17)
**Goal:** All recording UI controls implemented and functional

## Daily Breakdown

**DAY 1 (Monday) - Recording Button Setup**
- Hours: ~8
- Goal: Create Record/Stop/Pause buttons, implement visual states
- Test: All buttons render, clickable, change appearance on click

**DAY 2 (Tuesday) - Status Display**
- Hours: ~8
- Goal: Add status text showing recording state, timer display
- Test: Status updates when buttons clicked, timer increments

**DAY 3 (Wednesday) - Audio Input Selection**
- Hours: ~8
- Goal: Let user select audio source (system, mic), show device list
- Test: Audio sources appear, selection works, persists

**DAY 4 (Thursday) - Layout Polish & Integration**
- Hours: ~7
- Goal: Arrange all controls, test responsive layout on device
- Test: Layout responsive, all elements visible, proper spacing

**DAY 5 (Friday) - Testing & Preparation**
- Hours: ~6
- Goal: Manual testing of full UI flow, fix any issues, prepare for backend
- Test: All tests passing, build clean, all manual scenarios work

## Total: ~37 hours

## Success Metrics

By Friday:
- [ ] All UI controls complete and working
- [ ] Layout responsive on target devices
- [ ] Build: 0 errors, 0 warnings
- [ ] Tests passing
- [ ] Ready to add recording logic Week 3

**Created:** Jan 13, 2025
```

---

## Quality Check

Verify:
- [ ] Week goal is clear and achievable
- [ ] 5 days with specific goals
- [ ] Time totals 35-40 hours
- [ ] Each day has testable deliverable
- [ ] Estimates adjusted for velocity
- [ ] No overpromising

---

## Tips

✅ DO:
- Adjust based on previous week's actual hours
- Make daily goals specific
- Include testing time
- Be honest about capacity
- Account for learning curve

❌ DON'T:
- Pack 40+ hours in 5 days
- Make goals vague
- Ignore velocity data
- Skip testing day
- Over-promise

---

## Files to Reference

- **Template:** solo/02-weekly-plan/template.md
- **Project plan:** docs/plan/project-plan.md
- **Previous summary:** docs/plan/week-X-1/summary.md
