# Day 4 Plan - Control Buttons Functionality

**Date:** Thursday, January 3, 2025
**Week:** Week 1, Day 4
**Hours Available:** ~7 hours
**Goal:** Wire up Start/Pause/Reset buttons to timer logic

---

## Definition of Done

By end of day:
- [ ] [Start] button starts countdown from 25:00
- [ ] [Pause] button pauses timer and changes button text to "Start"
- [ ] [Reset] button resets timer to 25:00 regardless of current state
- [ ] Button states change based on timer state (enabled/disabled/text changes)
- [ ] Timer display color changes: green (running), orange (paused), default (idle)
- [ ] Build: 0 errors, 0 warnings
- [ ] No crashes during button interactions
- [ ] All state transitions work correctly (idle→running→paused→reset)

---

## Tasks

### Task 1: Implement Start Button Logic
**Time:** ~2 hours
**What:** Wire Start button to begin countdown from 25:00
**Why:** Core functionality - user needs to start the timer
**Acceptance:**
- Clicking [Start] when timer is idle begins countdown from 25:00
- Clicking [Start] when timer is paused resumes from current time
- Timer state transitions from idle→running or paused→running
- Display updates every second during countdown
- Button becomes [Pause] when timer is running

**Files:** `TimerViewModel.swift`, `TimerView.swift`

---

### Task 2: Implement Pause Button Logic
**Time:** ~1.5 hours
**What:** Wire Pause button to stop countdown and preserve current time
**Why:** User needs ability to pause without losing progress
**Acceptance:**
- Clicking [Pause] when timer is running stops countdown
- Current time is preserved (e.g., paused at 18:42 stays at 18:42)
- Timer state transitions from running→paused
- Button text changes from [Pause] to [Start]
- Display shows paused time (no updates)

**Files:** `TimerViewModel.swift`, `TimerView.swift`

---

### Task 3: Implement Reset Button Logic
**Time:** ~1.5 hours
**What:** Wire Reset button to return timer to 25:00 from any state
**Why:** User needs to restart timer without completing full cycle
**Acceptance:**
- Clicking [Reset] from any state (idle/running/paused) returns to 25:00
- Timer state transitions to idle
- Countdown stops if running
- Button states reset to initial (Start button visible)
- Display shows "25:00"

**Files:** `TimerViewModel.swift`, `TimerView.swift`

---

### Task 4: Add Visual State Indicators
**Time:** ~1.5 hours
**What:** Change timer display color based on state
**Why:** User needs visual feedback about timer status
**Acceptance:**
- Timer display is green when running
- Timer display is orange when paused
- Timer display is default (white/black) when idle
- Color transitions are smooth (not jarring)
- Colors are visible in both light/dark mode

**Files:** `TimerView.swift`

---

### Task 5: Testing & Edge Cases
**Time:** ~1 hour
**What:** Test all button combinations and state transitions
**Why:** Ensure robust behavior and no crashes
**Acceptance:**
- Test rapid clicking (Start→Pause→Start→Reset)
- Test reset during active countdown
- Test reset when paused
- Verify timer accuracy after pause/resume
- No memory leaks during repeated start/stop cycles
- Build clean: 0 errors, 0 warnings

**Files:** Manual testing

---

## Implementation Notes

### State Machine
```
idle → running (Start clicked)
running → paused (Pause clicked)
paused → running (Start clicked)
any → idle (Reset clicked)
```

### Button State Logic
- **Start button:** Visible when idle or paused, text changes context
- **Pause button:** Visible only when running
- **Reset button:** Always visible, enabled in any state

### Timer Color Mapping
- `.green` when `timerState == .running`
- `.orange` when `timerState == .paused`
- `.primary` when `timerState == .idle`

### Architecture Guidance
- Keep all state logic in `TimerViewModel`
- `TimerView` should only bind to @Published properties
- Use SwiftUI animations for color transitions
- Ensure timer invalidation on pause to prevent background updates

---

## Testing Strategy

**Manual Tests:**
1. Start timer → verify countdown begins
2. Pause timer → verify countdown stops
3. Resume timer → verify countdown continues from paused time
4. Reset during countdown → verify returns to 25:00
5. Reset when paused → verify returns to 25:00
6. Rapid button clicks → verify no crashes
7. Visual check: colors change correctly

**Accuracy Test:**
- Start timer, let run for 2 minutes, verify time is accurate

---

## Execution

**Morning (9:00 AM - 12:00 PM):**
_[Fill in during the day]_

**Afternoon (1:00 PM - 5:00 PM):**
_[Fill in during the day]_

**Evening (if needed):**
_[Fill in during the day]_

---

**Blockers:**
_[List any blockers encountered]_

**Notes:**
_[Add notes during the day]_

---

**Plan Created:** January 3, 2025
**Status:** ⏳ Ready to Start
