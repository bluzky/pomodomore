# AI Prompt: Daily Plan (Solo Dev)

**Output:** `docs/plan/week-X/day-Y-plan.md`

---

## Your Task

Create a detailed daily work plan with 3-4 specific tasks and acceptance criteria.

---

## Input

The developer provides:

```
CONTEXT:
- Day number (Day Y)
- Week number
- Today's goal (from week plan)
- Time available (usually 8 hours)

OPTIONAL:
- Architecture decisions
- Files involved
- Previous day's blockers
```

---

## What to Generate

Complete `day-Y-plan.md` with:

1. **Definition of Done** (specific, testable criteria)
2. **3-4 Tasks** (each with what, why, acceptance criteria)
3. **Implementation Notes** (architecture, challenges)
4. **Testing Strategy** (what to test, how)
5. **Execution Section** (empty, to fill during day)

---

## Generation Steps

1. Understand today's goal

2. Ask clarifying questions if needed:
   - "How many hours available?"
   - "What was the blocker yesterday?"
   - "What architecture is this building on?"

3. Design 3-4 focused tasks:
   - Task 1-3: Core work (2-2.5 hours each)
   - Task 4: Testing (1 hour)

4. For each task write:
   - What: Specific description
   - Why: Why it matters
   - Acceptance: Testable outcomes

5. Include implementation guidance (but not code)

6. Generate complete day-Y-plan.md

---

## Example

**Developer says:**
```
Day 1 of Week 2
Goal: Recording button setup and visual states
Time: 8 hours
Using SwiftUI
```

**AI generates:**
```markdown
# Day 1 Plan

**Date:** Jan 13, 2025
**Goal:** Create Record/Stop/Pause buttons with visual state changes
**Time Estimate:** ~8 hours

## Definition of Done

Day complete when:
- [ ] All 3 buttons (Record, Stop, Pause) render correctly
- [ ] Buttons change appearance when tapped (visual feedback)
- [ ] Layout has proper spacing (8pt grid)
- [ ] Build: 0 errors, 0 warnings
- [ ] Tests: 100% passing

## Tasks

### Task 1: Build Button UI Components
**Estimate:** ~2.5 hours

**What:** Create SwiftUI button components for Record, Stop, Pause

**Why:** Users need interface to control recording; foundation for rest of UI

**Acceptance:**
- [ ] All 3 buttons visible on screen
- [ ] Buttons use correct styling (colors, fonts from design)
- [ ] Proper sizing (minimum 44x44 tappable area)
- [ ] Buttons are tappable

---

### Task 2: Implement Button State Logic
**Estimate:** ~2.5 hours

**What:** Connect buttons to recording state, change appearance based on state

**Why:** Users need visual feedback about what action is possible

**Acceptance:**
- [ ] Record button enabled when idle
- [ ] Stop button enabled when recording
- [ ] Pause available during recording
- [ ] Buttons change color/appearance on state change
- [ ] State changes on tap (mock for now)

---

### Task 3: Arrange Layout & Polish
**Estimate:** ~2 hours

**What:** Arrange all buttons with status area, test on device

**Why:** Must be usable and look polished

**Acceptance:**
- [ ] All elements fit on screen
- [ ] Proper spacing between elements
- [ ] Works on iPhone + iPad
- [ ] No layout warnings in Xcode
- [ ] Matches design mockup

---

### Task 4: Testing & Quality Verification
**Estimate:** ~1 hour

**What:** Unit tests + manual testing + build verification

**Why:** Ensure quality before day ends

**Acceptance:**
- [ ] Unit tests passing (target: 8+ tests)
- [ ] Manual testing: all scenarios work
- [ ] Build: 0 errors, 0 warnings
- [ ] No console warnings

---

## Implementation Notes

**Architecture:**
- Use SwiftUI @State for button states
- Define color constants for consistency
- Create reusable button style

**Known Challenges:**
- SwiftUI preview rendering can be slow - use device testing if preview fails
- Button constraints require careful setup - use 8pt grid
- State updates need @State wrapper, not var

**Files to Create:**
- RecordingControls.swift (button components)
- RecordingControlsTests.swift (unit tests)

**Files to Modify:**
- ContentView.swift (embed button component)

---

## Testing Strategy

**Unit Tests:**
- Test button rendering
- Test state transitions
- Test accessibility

**Manual Testing:**
- Tap each button, verify appearance changes
- Check layout on device
- Verify no console errors
- Test dark mode if applicable

---

## Execution (Fill During Day)

**Start:** [Time when you begin]

**Progress Updates:**
(Log these as you work)
- [HH:MM] — [Milestone]
- [HH:MM] — [Progress]

**Actual Time:** (Will fill at end)

**Tasks:**
- [ ] Task 1
- [ ] Task 2
- [ ] Task 3
- [ ] Task 4

**Quality Checklist:**
- [ ] Build: 0 errors, 0 warnings
- [ ] Tests: 100% passing
- [ ] Manual verification complete

---

**Complete:** [End time]
```

---

## Quality Check

Before generating, verify:
- [ ] Definition of Done is specific (not vague)
- [ ] 3-4 tasks with clear breakdown
- [ ] Each task has What, Why, Acceptance
- [ ] Time estimates total ~8 hours
- [ ] Testing is included as separate task
- [ ] Implementation notes guide without coding
- [ ] File structure is clear

---

## Tips

✅ DO:
- Make acceptance criteria specific and testable
- Include testing as separate task
- Estimate realistically (2-2.5 hours per core task, 1 hour for testing)
- Anticipate challenges
- Reference architecture decisions

❌ DON'T:
- Make acceptance criteria vague ("works", "no errors")
- Pack more than 4 tasks
- Forget testing
- Include actual code (just architecture guidance)
- Make tasks too large

---

## Handling Carryover

If the developer says "Day 2 but Task 1 from yesterday isn't done":

```
Ask: "What's blocking Task 1?"
Adjust: Break Task 1 into smaller pieces
Or: Move Task 1 to today, shift other tasks
```

Always help them succeed, not fail.

---

## Files to Reference

- **Template:** solo/03-daily-plan/template.md
- **Weekly plan:** docs/plan/week-X/week-X-plan.md
