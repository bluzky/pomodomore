# Day 5 Plan - Integration & Window Management

**Date:** Friday, January 4, 2025
**Week:** Week 1, Day 5
**Hours Available:** ~6 hours
**Goal:** Connect menubar to timer window, add window management features, complete Week 1

---

## Definition of Done

By end of day:
- [ ] Menubar menu has "Show Timer" item that opens/shows timer window
- [ ] "Always on Top" toggle works (window stays above other apps)
- [ ] Window position persists across app restarts (UserDefaults)
- [ ] Menubar menu shows timer state (e.g., "⏱️ 18:42" when running)
- [ ] SwiftData boilerplate removed (Item.swift, related files)
- [ ] Build: 0 errors, 0 warnings
- [ ] Full workflow tested: menubar → open window → start timer → close window → reopen → position remembered
- [ ] Week 1 deliverables complete

---

## Tasks

### Task 1: Add "Show Timer" Menu Item
**Time:** ~1.5 hours
**What:** Add menubar menu item to show/bring forward timer window
**Why:** User needs to access timer window from menubar
**Acceptance:**
- Menubar menu has "Show Timer" item
- Clicking menu item opens timer window if closed
- Clicking menu item brings window to front if already open
- Timer window can be closed and reopened without losing state
- Window opens at last known position

**Files:** `AppDelegate.swift`, `WindowManager.swift` (create if needed)

---

### Task 2: Implement "Always on Top" Toggle
**Time:** ~1.5 hours
**What:** Add toggle to keep timer window above all other windows
**Why:** User wants timer visible during work (PRD requirement)
**Acceptance:**
- Timer window has "Always on Top" checkbox/toggle
- When enabled, window stays above all other windows
- State persists in UserDefaults across app restarts
- Toggle can be changed while timer is running
- Window level changes immediately when toggled

**Files:** `TimerView.swift`, `TimerViewModel.swift`, `WindowManager.swift`

---

### Task 3: Window Position Persistence
**Time:** ~1.5 hours
**What:** Remember window position across app restarts using UserDefaults
**Why:** User doesn't want to reposition window every time
**Acceptance:**
- Window position (x, y) saved to UserDefaults on close/move
- Window opens at saved position on app launch
- Default position (center screen) if no saved position exists
- Position updates saved when window is dragged
- Works correctly with multiple monitors

**Files:** `WindowManager.swift`, `AppDelegate.swift`

---

### Task 4: Dynamic Menubar Status
**Time:** ~1 hour
**What:** Update menubar menu to show current timer state
**Why:** User wants to see timer status without opening window
**Acceptance:**
- Menu shows "⏱️ 25:00" when timer is idle
- Menu shows "⏱️ 18:42" (current time) when timer is running
- Menu shows "⏸ 12:15" when timer is paused
- Menu updates every second during countdown
- Menu item text changes based on timer state

**Files:** `AppDelegate.swift`, `TimerViewModel.swift`

---

### Task 5: Cleanup & Testing
**Time:** ~1.5 hours
**What:** Remove unused SwiftData files and test complete workflow
**Why:** Clean codebase, ensure Week 1 deliverables work end-to-end
**Acceptance:**
- Remove `Item.swift` (SwiftData model)
- Remove SwiftData imports from `pomodomoreApp.swift`
- Remove `.modelContainer()` modifier if present
- Full workflow test: menubar → open → start → pause → reset → close → reopen → position remembered → always on top works
- Build clean: 0 errors, 0 warnings
- No crashes during complete workflow

**Files:** `Item.swift` (delete), `pomodomoreApp.swift`, manual testing

---

## Implementation Notes

### WindowManager Architecture
Create a `WindowManager` class to centralize window operations:
- Opening/closing timer window
- Position tracking and persistence
- Always on top state management
- Singleton or AppDelegate property

### UserDefaults Keys
```swift
// Window position
"timerWindowX" // CGFloat
"timerWindowY" // CGFloat
"alwaysOnTop" // Bool
```

### Window Level for Always on Top
```swift
// Use .floating level for always on top
window.level = alwaysOnTop ? .floating : .normal
```

### Menubar Status Update Strategy
- TimerViewModel publishes `timeRemaining` and `currentState`
- AppDelegate observes these via Combine
- Updates menu item text in real-time
- Use NSMenu `update()` or direct item.title changes

### Architecture Guidance
- Keep window management logic separate from timer logic
- Use NotificationCenter or Combine for ViewModel → AppDelegate communication
- Persist settings immediately on change (don't wait for app quit)
- Handle edge cases: window off-screen after monitor change

---

## Testing Strategy

**Manual Tests:**
1. **Show Timer:** Click menubar → verify window opens → click again → verify window comes to front
2. **Always on Top:** Enable toggle → open another app → verify timer stays on top → disable → verify timer goes behind
3. **Position Persistence:**
   - Move window to corner
   - Quit app (Cmd+Q)
   - Relaunch app
   - Verify window opens at same corner position
4. **Menubar Status:**
   - Start timer → verify menubar shows countdown
   - Pause timer → verify menubar shows paused state
   - Reset timer → verify menubar shows 25:00
5. **Full Workflow:**
   - Menubar click → open timer
   - Enable always on top
   - Start countdown
   - Close window (countdown continues)
   - Reopen from menubar → verify state preserved
   - Verify position remembered

**Edge Cases:**
- Window positioned off-screen (second monitor disconnected)
- Multiple rapid menubar clicks
- Always on top toggle during countdown

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

**Plan Created:** January 1, 2025
**Status:** ⏳ Ready to Start
