# Week 2 Plan

**Week:** Week 2 (Jan 6-10, 2025)
**Goal:** Complete full Pomodoro cycle with breaks and session tracking

---

## Context

Week 1 delivered a working menubar Pomodoro timer (25-min countdown with Start/Pause/Reset). Week 2 completes the core Pomodoro Technique implementation: break timers (short/long), session cycle logic (4 Pomodoros → Long Break), and visual session indicators.

**Available:** ~40 hours this week
**Week 1 Velocity:** Tasks completed in ~20% of estimated time (7.5 actual vs 37 planned)
**Adjusted Estimate:** ~8-12 hours actual work expected

---

## Daily Breakdown

### DAY 1 (Monday) - Session Type System & Break Timers

**Hours:** ~8 (estimated ~2 actual based on velocity)
**Goal:** Extend timer to support multiple session types (Pomodoro, Short Break, Long Break)

**Deliverables:**
- Extend `TimerState` to include session types (Pomodoro, Short Break, Long Break)
- Update `TimerViewModel` to handle different durations per session type
  - Pomodoro: 25 minutes (1500s)
  - Short Break: 5 minutes (300s)
  - Long Break: 15 minutes (900s)
- Add session type tracking to ViewModel (`currentSessionType`)
- Timer initializes with correct duration based on session type
- Test: Timer can countdown for all three session types with correct durations

**Files:**
- Update `TimerState.swift` (add SessionType enum)
- Update `TimerViewModel.swift` (add session type handling)
- Update `TimerView.swift` (prepare for session type display)

**Testing:**
- Build clean (0 errors, 0 warnings)
- All three session types countdown correctly
- Reset works for each session type

---

### DAY 2 (Tuesday) - Session Cycle Logic

**Hours:** ~8 (estimated ~2 actual based on velocity)
**Goal:** Implement Pomodoro cycle state machine (4 Pomodoros → Long Break)

**Deliverables:**
- Session counter tracking completed Pomodoros (1-4)
- Auto-transition logic when timer completes:
  - Pomodoro complete → Short Break (if sessions < 4)
  - Pomodoro complete → Long Break (if sessions == 4)
  - Break complete → Reset to Pomodoro ready state
  - Long Break complete → Reset session counter to 0
- Add `completedSessions` property to track current cycle progress
- Timer automatically transitions to next session type
- Test: Complete cycle flows correctly (Pomodoro → Break → Pomodoro...)

**Files:**
- Update `TimerViewModel.swift` (add session counter, transition logic)
- Add `Session.swift` model (data structure for session tracking)

**Testing:**
- Build clean (0 errors, 0 warnings)
- Session counter increments correctly
- Transitions work: Pomodoro → Short Break → Pomodoro
- Long Break triggered after 4th Pomodoro
- Counter resets after Long Break

**Implementation Notes:**
- Update `complete()` method in ViewModel to determine next session
- Use switch statement on session type + counter for transition logic
- Session counter only increments when Pomodoro completes (not breaks)

---

### DAY 3 (Wednesday) - Session Indicators UI

**Hours:** ~8 (estimated ~2 actual based on velocity)
**Goal:** Add visual session progress indicators (4 circles)

**Deliverables:**
- Session indicator component displaying 4 circles
- Empty circle (○): Upcoming Pomodoro session
- Filled circle (●): Completed Pomodoro session
- Indicators update as sessions complete
- Indicators reset after Long Break cycle
- Position indicators at bottom of timer window
- Test: Circles fill as sessions complete, reset after long break

**Files:**
- Create `SessionIndicatorsView.swift` (new component)
- Update `TimerView.swift` (integrate indicators)
- Update `TimerViewModel.swift` (expose session count for UI binding)

**Testing:**
- Build clean (0 errors, 0 warnings)
- Indicators render correctly (4 circles)
- Circles fill on Pomodoro completion (1st = ●○○○, 2nd = ●●○○, etc.)
- Circles reset after Long Break completes
- Visual spacing and alignment look good

**UI Specifications:**
- Layout: Horizontal row of 4 circles
- Size: ~12pt diameter circles
- Spacing: 8pt between circles
- Colors: Filled (theme primary), Empty (theme secondary/border)
- Position: Bottom of timer window, centered

---

### DAY 4 (Thursday) - Break UI & Controls

**Hours:** ~8 (estimated ~2 actual based on velocity)
**Goal:** Update UI for break sessions with appropriate controls

**Deliverables:**
- Display session type label ("Short Break" or "Long Break") during breaks
- Hide session type label during Pomodoro sessions
- Break session controls: Only [Stop] button visible
- Pomodoro session controls: [Pause] and [Reset] buttons
- Timer color changes based on session:
  - Active Pomodoro: Green (existing)
  - Paused Pomodoro: Orange (existing)
  - Active Break: Cyan/Blue (new)
- Stop button ends break and returns to Pomodoro ready state
- Test: UI updates correctly for each session type

**Files:**
- Update `TimerView.swift` (conditional UI based on session type)
- Update `TimerViewModel.swift` (add `stop()` method for breaks)

**Testing:**
- Build clean (0 errors, 0 warnings)
- Session label displays correctly ("Short Break", "Long Break")
- Session label hidden during Pomodoro
- Buttons change: Pomodoro shows Pause/Reset, Break shows Stop
- Timer colors correct for each state
- Stop button works: ends break, returns to idle Pomodoro state

**UI Layout:**
```
During Pomodoro:
  25:00
  [Pause] [Reset]
  ●●○○

During Break:
  Short Break
  05:00
  [Stop]
  ●●○○
```

---

### DAY 5 (Friday) - Integration, Testing & Documentation

**Hours:** ~8 (estimated ~2-3 actual based on velocity)
**Goal:** Full cycle testing, menubar integration, documentation

**Deliverables:**
- Menubar menu updates based on session type:
  - Pomodoro: "Start" or "Pause"
  - Break: "Stop"
- Menubar countdown shows during all session types
- Menubar shows session type in title (optional enhancement)
- Test full Pomodoro cycle end-to-end:
  - 4 Pomodoros with Short Breaks
  - Long Break after 4th Pomodoro
  - Counter reset and new cycle begins
- Manual testing with shorter durations (e.g., 10s Pomodoro, 5s Break)
- Create Week 2 summary document
- Build: 0 errors, 0 warnings

**Files:**
- Update `AppDelegate.swift` (menubar menu for session types)
- Update `WindowManager.swift` if needed (session type handling)
- Create `docs/plan/week-2/summary.md`

**Testing Strategy:**
- Use shortened durations for testing (set in code temporarily):
  - Pomodoro: 10 seconds
  - Short Break: 5 seconds
  - Long Break: 8 seconds
- Run full cycle test: 4 Pomodoros + 3 Short Breaks + 1 Long Break
- Verify session counter increments and resets correctly
- Test all button states and transitions
- Test menubar updates during cycle
- Restore production durations after testing

**Success Criteria:**
- Full Pomodoro cycle works end-to-end
- UI updates correctly for all session types
- Menubar controls work for all session types
- No crashes or state inconsistencies
- Build clean with 0 errors, 0 warnings

---

## Total: ~40 hours estimated, ~8-12 hours actual expected

---

## Success Metrics

By Friday EOD:
- [ ] Three session types implemented (Pomodoro, Short Break, Long Break)
- [ ] Session cycle logic working (4 Pomodoros → Long Break)
- [ ] Session indicators display and update correctly (4 circles)
- [ ] Break UI with appropriate controls (Stop button)
- [ ] Timer colors differentiate session states
- [ ] Menubar integrates with all session types
- [ ] Full cycle tested end-to-end
- [ ] Build: 0 errors, 0 warnings
- [ ] No crashes during cycle operation

---

## Out of Scope (Week 3+)

**Week 3 Focus:**
- Settings dialog UI
- Timer duration customization
- Theme system (Nord, Monokai, Dracula)
- Font selection (SF Mono, Menlo, Monaco)
- Settings persistence (settings.json)

**Week 4+ Focus:**
- Statistics window with weekly chart
- Session data persistence (sessions.json)
- Sounds and notifications
- Auto-start next session toggle
- System sleep/wake handling

---

## Architecture Notes

### Session Type Enum
```swift
enum SessionType {
    case pomodoro
    case shortBreak
    case longBreak

    var duration: Int {
        switch self {
        case .pomodoro: return 1500  // 25 min
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

### Session Cycle State Machine
```
State: (sessionType, completedSessions, timerState)

Pomodoro completes:
  if completedSessions < 4:
    → Short Break, increment counter
  if completedSessions == 4:
    → Long Break, keep counter at 4

Break completes:
  if was Long Break:
    → Pomodoro, reset counter to 0
  if was Short Break:
    → Pomodoro, keep counter
```

### ViewModel Key Properties
- `currentSessionType: SessionType`
- `completedSessions: Int` (0-4)
- `currentState: TimerState` (idle/running/paused/completed)
- `timeRemaining: Int`

---

## Testing Strategy

**Daily Testing:**
- Manual testing after each feature implementation
- Build verification (0 errors, 0 warnings)
- State transition verification

**End-to-End Testing (Day 5):**
- Full cycle with shortened durations
- Edge cases:
  - Pause during Pomodoro → Resume → Complete
  - Reset during Pomodoro → Counter unchanged
  - Stop during Break → Returns to Pomodoro ready
  - Window close during session → Timer continues
  - Quit app during session → State lost (acceptable for now, persistence in Week 4)

---

## Risks & Mitigations

| Risk | Mitigation |
|------|-----------|
| Session cycle logic complexity | Draw state machine diagram first, write clear transition logic |
| UI layout shifts between session types | Test all three session types early, use consistent spacing |
| Timer accuracy during transitions | Validate countdown remains accurate across session changes |
| Session counter edge cases | Test boundary conditions (sessions 0,1,3,4 and after reset) |

---

**Created:** January 6, 2025
**Status:** ✅ Ready to Start
