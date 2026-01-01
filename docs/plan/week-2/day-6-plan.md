# Day 6 Plan - Session Type System & Break Timers

**Date:** January 6, 2025 (Monday)
**Week:** Week 2, Day 1
**Goal:** Extend timer to support multiple session types (Pomodoro, Short Break, Long Break)

---

## Context

Week 1 delivered a working menubar Pomodoro timer with basic Start/Pause/Reset functionality. Today begins Week 2, where we implement the full Pomodoro Technique cycle with breaks and session tracking.

This is the foundation day - we're adding the session type system that everything else builds on.

---

## Definition of Done

By end of day:
- Timer supports three distinct session types with different durations
- SessionType enum exists with duration and display properties
- TimerViewModel tracks current session type
- Timer correctly initializes and counts down for each session type
- Build is clean: 0 errors, 0 warnings
- Manual testing confirms all three session types work

---

## Tasks

### Task 1: Create SessionType Enum
**What:** Define SessionType enum with three cases and computed properties
**Why:** Encapsulates session type logic and durations in one place
**Time:** 30 minutes

**Acceptance Criteria:**
- SessionType enum created in `pomodomore/Models/SessionType.swift`
- Three cases: `pomodoro`, `shortBreak`, `longBreak`
- `duration` property returns correct seconds:
  - Pomodoro: 1500 (25 min)
  - Short Break: 300 (5 min)
  - Long Break: 900 (15 min)
- `displayName` property returns:
  - Pomodoro: "" (empty)
  - Short Break: "Short Break"
  - Long Break: "Long Break"
- Code compiles without errors

---

### Task 2: Add Session Type to TimerViewModel
**What:** Add `currentSessionType` property and update initialization logic
**Why:** ViewModel needs to track which session type is active
**Time:** 45 minutes

**Acceptance Criteria:**
- TimerViewModel has `@Published var currentSessionType: SessionType`
- Default session type is `.pomodoro`
- `initialize()` method sets `timeRemaining` from `currentSessionType.duration`
- Timer initialization respects session type duration
- Existing Start/Pause/Reset functionality still works
- Build clean: 0 errors, 0 warnings

**Files to Update:**
- `pomodomore/ViewModels/TimerViewModel.swift`

---

### Task 3: Update TimerView for Session Types
**What:** Prepare TimerView to display session type information
**Why:** UI needs to reflect different session types (foundation for Day 4)
**Time:** 30 minutes

**Acceptance Criteria:**
- TimerView can access `viewModel.currentSessionType`
- Timer display still shows correct countdown format (MM:SS)
- No visual changes yet (just internal preparation)
- Build clean: 0 errors, 0 warnings

**Files to Update:**
- `pomodomore/Views/TimerView.swift`

---

### Task 4: Manual Testing & Verification
**What:** Test all three session types manually
**Why:** Verify durations are correct and transitions work
**Time:** 45 minutes

**Test Cases:**
1. **Pomodoro Timer:**
   - Start timer, verify it starts at 25:00
   - Verify countdown works correctly
   - Pause/Resume works
   - Reset returns to 25:00

2. **Short Break Timer (temporary test):**
   - Temporarily change default session type to `.shortBreak` in code
   - Start timer, verify it starts at 05:00
   - Verify countdown works
   - Reset returns to 05:00

3. **Long Break Timer (temporary test):**
   - Temporarily change default session type to `.longBreak`
   - Start timer, verify it starts at 15:00
   - Verify countdown works
   - Reset returns to 15:00

4. **Build Verification:**
   - Run build: 0 errors, 0 warnings
   - No crashes during any session type

**Acceptance Criteria:**
- All three session types countdown correctly
- Each session type shows correct initial duration
- Reset works for each session type
- No build errors or warnings
- Restore default to `.pomodoro` after testing

---

## Implementation Notes

### SessionType Architecture
```swift
// pomodomore/Models/SessionType.swift
enum SessionType {
    case pomodoro
    case shortBreak
    case longBreak

    var duration: Int {
        switch self {
        case .pomodoro: return 1500   // 25 min
        case .shortBreak: return 300  // 5 min
        case .longBreak: return 900   // 15 min
        }
    }

    var displayName: String {
        switch self {
        case .pomodoro: return ""
        case .shortBreak: return "Short Break"
        case .longBreak: return "Long Break"
        }
    }
}
```

### ViewModel Integration
- Add `currentSessionType` as published property
- Update `initialize()` to use `currentSessionType.duration`
- Keep existing timer logic unchanged for now
- Session type changes will come in Day 7 (auto-transitions)

### Testing Strategy
- Use code changes to temporarily test different session types
- Verify each duration initializes correctly
- Confirm countdown accuracy for each type
- Check that existing Start/Pause/Reset still works

---

## Out of Scope (Future Days)

**Not today:**
- Auto-transition between session types (Day 7)
- Session counter/cycle logic (Day 7)
- Session indicators UI (Day 8)
- Break-specific UI controls (Day 9)
- Menubar session type display (Day 10)

---

## Files to Create/Modify

**New Files:**
- `pomodomore/Models/SessionType.swift`

**Modified Files:**
- `pomodomore/ViewModels/TimerViewModel.swift`
- `pomodomore/Views/TimerView.swift`

---

## Success Criteria

- [ ] SessionType enum created with 3 cases and computed properties
- [ ] TimerViewModel tracks currentSessionType
- [ ] Timer initializes with correct duration for each session type
- [ ] All three session types manually tested and working
- [ ] Build: 0 errors, 0 warnings
- [ ] Existing Start/Pause/Reset functionality preserved
- [ ] Code is clean and well-structured

---

## Execution Log

**Start Time:** ___
**End Time:** ___
**Actual Hours:** ___

### Progress Notes
_[Fill in during the day]_

### Blockers
_[Note any blockers encountered]_

### Wins
_[Celebrate accomplishments]_

---

**Next Day:** Day 7 - Session Cycle Logic (auto-transitions, session counter)
