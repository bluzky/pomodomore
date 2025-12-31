# Week 1 Plan

**Week:** Week 1 (Dec 31, 2024 - Jan 3, 2025)
**Goal:** Menubar app with working 25-minute Pomodoro timer countdown

---

## Context

Starting from Xcode template project. Need to convert from standard WindowGroup app to menubar-only app (LSUIElement = YES, no dock icon). Focus: Get basic timer running in menubar with countdown window.

**Available:** ~37 hours this week
**Risk:** SwiftUI + AppKit menubar integration (new territory)

---

## Daily Breakdown

**DAY 1 (Monday) - Menubar App Foundation**
- Hours: ~8
- Goal: Convert app to menubar-only, remove dock icon, setup NSStatusBar with basic icon
- Deliverables:
  - App runs in menubar (no dock icon)
  - Menubar icon visible (tomato emoji or placeholder)
  - Clicking icon shows basic menu with "Quit" option
  - App stays running when all windows closed
- Test: App appears in menubar, menu clickable, app quits correctly
- Files: `AppDelegate.swift` (create), `Info.plist` (LSUIElement), refactor `pomodomoreApp.swift`

---

**DAY 2 (Tuesday) - Timer Window UI**
- Hours: ~8
- Goal: Create basic timer window with layout (no functionality yet)
- Deliverables:
  - Timer window (320×200px) with close button
  - Large timer display showing "25:00" (static)
  - Three buttons: [Start] [Pause] [Reset] (non-functional)
  - Session indicators: ○ ○ ○ ○ (static circles)
  - Window positioned correctly, draggable
- Test: Window appears, displays correctly, closes properly
- Files: `TimerWindow.swift` (create), `TimerView.swift` (create)

---

**DAY 3 (Wednesday) - Timer State & Countdown Logic**
- Hours: ~8
- Goal: Implement timer countdown mechanism and state management
- Deliverables:
  - `TimerViewModel.swift` with timer state (idle/running/paused)
  - Timer counts down from 25:00 to 00:00 using Timer.publish
  - Display updates every second (MM:SS format)
  - Timer stops at 00:00 (no sound/notification yet)
  - State machine: idle → running → completed
- Test: Timer counts down accurately, stops at zero, time display formats correctly
- Files: `TimerViewModel.swift` (create), `TimerState.swift` (create), update `TimerView.swift`

---

**DAY 4 (Thursday) - Control Buttons Functionality**
- Hours: ~7
- Goal: Wire up Start/Pause/Reset buttons to timer logic
- Deliverables:
  - [Start] button starts countdown from 25:00
  - [Pause] button pauses timer (button text changes to "Start")
  - [Reset] button resets timer to 25:00
  - Button states change based on timer state
  - Timer color changes: green (active), orange (paused), default (idle)
- Test: All button interactions work, state transitions correct, no crashes
- Files: Update `TimerViewModel.swift`, `TimerView.swift`

---

**DAY 5 (Friday) - Integration & Window Management**
- Hours: ~6
- Goal: Connect menubar to timer window, test full workflow
- Deliverables:
  - Menu item "Start" opens timer window and starts countdown
  - Timer window "Always on Top" toggle (basic implementation)
  - Window position remembered across app restarts
  - Menubar menu updates based on timer state (Start/Pause)
  - Clean up SwiftData boilerplate (remove Item.swift, etc.)
- Test: Full workflow - menubar click → timer starts → pause/reset work → window positioning persists
- Files: Update `AppDelegate.swift`, create `WindowManager.swift`, cleanup

---

## Total: ~37 hours

---

## Success Metrics

By Friday EOD:
- [x] App runs as menubar-only (no dock icon)
- [x] Menubar icon visible with basic menu
- [x] Timer window displays and functions
- [x] 25-minute countdown works accurately
- [x] Start/Pause/Reset buttons functional
- [x] Window position persists
- [x] Build: 0 errors, 0 warnings
- [x] No crashes during basic operation

---

## Out of Scope (Week 2+)

- Break timer (short/long)
- Session cycle logic (4 pomodoros)
- Settings dialog
- Themes/fonts
- Statistics
- Sounds/notifications
- Data persistence (sessions)
- System tray timer display

---

## Notes

**Architecture Decision:**
- Use AppDelegate for menubar management (AppKit)
- Use SwiftUI for timer window UI
- MVVM pattern: TimerViewModel manages state
- Hybrid approach: AppKit menubar + SwiftUI windows

**Testing Strategy:**
- Manual testing daily
- Focus on timer accuracy (run full 25min test Thursday)
- Test window positioning on Friday

**Risks:**
- SwiftUI window + AppKit menubar integration may need research (Day 1-2)
- Timer accuracy - validate Timer.publish vs DispatchSourceTimer (Day 3)

---

**Created:** December 31, 2024
**Status:** ✅ Ready to Start
