# Week 5 - Day 4 Plan

**Date:** Wednesday, January 8, 2026
**Week:** 5 (Themes + Fonts + UX Improvements)
**Day:** 4 of 6
**Hours Available:** 8 hours
**Estimated Actual:** ~3-4 hours (based on 15-20% velocity)

---

## Daily Goal

**Implement session completion floating view to improve workflow with celebration and manual control over session transitions.**

---

## Definition of Done

- [ ] Build succeeds with 0 errors, 0 warnings
- [ ] CompletionState model created
- [ ] CompletionView SwiftUI component created with celebration UI
- [ ] CompletionButton reusable component created
- [ ] CompletionWindow NSWindow created (centered, floating, 400x320)
- [ ] TimerViewModel modified to use completion state instead of auto-transition
- [ ] WindowManager extended to manage completion window
- [ ] Completion view shows after Pomodoro completion
- [ ] Completion view shows after break completion
- [ ] Auto-start break setting respected (auto-shows break countdown if ON)
- [ ] All buttons work correctly (Start Break, Skip Break, Start Next Pomodoro, Cancel)
- [ ] Break countdown displays in completion view when break is running
- [ ] TimerWindow hides when CompletionWindow shows
- [ ] Themes and fonts apply correctly to completion view

---

## Tasks

### Task 1: Create CompletionState Model (15 min)

**What:**
Create `Models/CompletionState.swift` with enum representing completion window states.

**Why:**
Clean state management to control when and what the completion window displays.

**Acceptance Criteria:**
- Enum with 4 cases: hidden, pomodoroComplete, breakComplete, breakRunning(timeRemaining: Int)
- Simple, lightweight model with no dependencies
- Builds without errors

**Implementation:**
```swift
enum CompletionState {
    case hidden                           // No completion window
    case pomodoroComplete                 // Show Pomodoro completion options
    case breakComplete                    // Show break completion options
    case breakRunning(timeRemaining: Int) // Break counting down in view
}
```

**Files:**
- Create `pomodomore/Models/CompletionState.swift` (new file, ~15 lines)

---

### Task 2: Create CompletionButton Component (20 min)

**What:**
Create reusable button component for completion view with primary and secondary styles.

**Why:**
Consistent button styling across the completion view, themed with current colors.

**Acceptance Criteria:**
- Two styles: primary (accent background, white text), secondary (light background, primary text)
- Size: ~120-140px width, 36px height
- Corner radius: 8px
- Font: 14pt medium weight via FontManager
- Colors from ThemeManager
- Plain button style with proper theming

**Implementation:**
```swift
struct CompletionButton: View {
    enum Style { case primary, secondary }
    let title: String
    let style: Style
    let action: () -> Void
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        Button(action: action) {
            Text(title)
                .appFont(size: 14, weight: .medium)
                .foregroundColor(textColor)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(backgroundColor)
                .cornerRadius(8)
        }
        .buttonStyle(.plain)
    }
}
```

**Files:**
- Create `pomodomore/Views/Completion/CompletionButton.swift` (new file, ~60 lines)

---

### Task 3: Create CompletionView SwiftUI Component (60 min)

**What:**
Create main completion view UI with celebration messages, session info, and action buttons.

**Why:**
This is the core user interface that shows after session completion with contextual actions.

**Acceptance Criteria:**
- Frame: 400x320 with themed background
- Three sections: Header (emoji + message), Content (progress/countdown/message), Buttons (actions)
- Handles all CompletionState cases:
  - `.pomodoroComplete`: "Great! Session complete 🎉" + 3 buttons
  - `.breakComplete`: "Break complete ☕" + 2 buttons
  - `.breakRunning(time)`: "Break Time ☕" + countdown + 1 button
- Session progress indicator (X/4 complete)
- Countdown timer formatted (MM:SS)
- Calls TimerViewModel methods for actions
- Uses ThemeManager colors and FontManager fonts
- Rounded corners with shadow for depth

**Key UI Elements:**
- Celebration emoji: 🎉 (Pomodoro), ☕ (break running), ✅ (break complete)
- Countdown font: 42pt medium weight
- Message font: 20pt semibold
- Button layout: HStack with 12px spacing
- Padding: 32px all around

**Files:**
- Create `pomodomore/Views/Completion/CompletionView.swift` (new file, ~200 lines)

---

### Task 4: Create CompletionWindow NSWindow (30 min)

**What:**
Create NSWindow wrapper for CompletionView following TimerWindow pattern.

**Why:**
Need a separate floating window that appears centered on screen, independent of TimerWindow.

**Acceptance Criteria:**
- NSWindow subclass with borderless style
- Window level: .floating (always on top)
- Size: 400x320
- Always centered on screen via `.center()`
- Transparent background, has shadow
- Not movable by background
- Uses NSHostingController to host CompletionView
- Injects SettingsManager, ThemeManager, FontManager as environment objects
- Respects dark/light mode appearance

**Pattern:**
Follow `TimerWindow.swift` structure but with centered positioning and non-draggable.

**Files:**
- Create `pomodomore/Views/Completion/CompletionWindow.swift` (new file, ~60 lines)

---

### Task 5: Modify TimerViewModel (45 min)

**What:**
Add completion state management and action methods to TimerViewModel.

**Why:**
Central state machine needs to control when completion view shows and respond to user actions.

**Acceptance Criteria:**
- Add `@Published var completionState: CompletionState = .hidden`
- Modify `complete()` method (line 257-312):
  - Remove `transitionToNextSession()` call at line 311
  - Check `autoStartBreak` setting
  - If Pomodoro completes + auto-start ON: set `.breakRunning(time)` and start break
  - If Pomodoro completes + auto-start OFF: set `.pomodoroComplete`
  - If break completes: set `.breakComplete`
- Update `tick()` method to update `.breakRunning(timeRemaining)` state
- Add 4 new public methods:
  - `startBreakFromCompletion()`: Start break, set state to `.breakRunning`
  - `skipBreakFromCompletion()`: Skip to idle Pomodoro, set state to `.hidden`
  - `startNextPomodoroFromCompletion()`: Transition to idle Pomodoro, set state to `.hidden`
  - `dismissCompletionView()`: Set state to `.hidden`

**Files:**
- Update `pomodomore/ViewModels/TimerViewModel.swift` (~100 lines modified/added)

---

### Task 6: Extend WindowManager (40 min)

**What:**
Add completion window management to WindowManager with Combine observer.

**Why:**
WindowManager needs to show/hide completion window based on TimerViewModel.completionState changes.

**Acceptance Criteria:**
- Import Combine framework
- Add `private(set) var completionWindow: CompletionWindow?` property
- Add `private var cancellables = Set<AnyCancellable>()` property
- Add `showCompletionWindow()` method:
  - Hides TimerWindow
  - Creates/shows CompletionWindow centered
  - Activates app
- Add `hideCompletionWindow()` method:
  - Hides CompletionWindow
  - Shows TimerWindow if session is active (not idle)
- Add Combine observer in `init()`:
  - Watch `timerViewModel.$completionState`
  - Show window when state is not .hidden
  - Hide window when state is .hidden

**Files:**
- Update `pomodomore/Services/WindowManager.swift` (~60 lines added)

---

### Task 7: Testing and Integration (30 min)

**What:**
Build, run, and test all completion flows thoroughly.

**Acceptance Criteria:**
- Build: 0 errors, 0 warnings
- Pomodoro completes (auto-start OFF) → Completion view shows with 3 buttons
- Pomodoro completes (auto-start ON) → Completion view shows with break counting down
- Click "Start Break" → Break starts, countdown visible in completion view
- Break completes → Completion view shows "Break complete" with 2 buttons
- Click "Skip Break" → View hides, timer shows idle Pomodoro
- Click "Start Next Pomodoro" → View hides, timer shows idle Pomodoro
- Click "Cancel" → View hides, returns to previous state
- 4th Pomodoro → Shows correct long break message
- Long break completes → Counter resets to 0
- Theme changes → Completion view updates
- Font changes → Completion view updates
- Window always centered on screen
- TimerWindow hides when completion view shows

**Testing Steps:**
1. Build project (Cmd+B)
2. Run app (Cmd+R)
3. Start and complete a Pomodoro (or set timer to 1 minute for quick test)
4. Verify completion window appears centered
5. Test all button actions
6. Toggle auto-start break setting and test both flows
7. Complete 4 Pomodoros to test long break flow
8. Change theme and verify completion view updates
9. Change font and verify countdown updates

---

## Files to Create (4 new files)

1. `pomodomore/Models/CompletionState.swift` (~15 lines)
2. `pomodomore/Views/Completion/CompletionButton.swift` (~60 lines)
3. `pomodomore/Views/Completion/CompletionView.swift` (~200 lines)
4. `pomodomore/Views/Completion/CompletionWindow.swift` (~60 lines)

---

## Files to Update (2 files)

1. `pomodomore/ViewModels/TimerViewModel.swift` (~100 lines modified/added)
2. `pomodomore/Services/WindowManager.swift` (~60 lines added)

---

## Implementation Order

1. Create CompletionState.swift (no dependencies)
2. Create CompletionButton.swift (simple component)
3. Create CompletionView.swift (uses CompletionState, CompletionButton)
4. Create CompletionWindow.swift (wraps CompletionView)
5. Build and verify no errors with new files
6. Modify TimerViewModel (add state and methods)
7. Build and verify TimerViewModel changes
8. Modify WindowManager (add window management)
9. Build and verify integration
10. Run app and test all flows

---

## Success Criteria

By end of day:
- ✅ CompletionState model created
- ✅ CompletionButton component created
- ✅ CompletionView UI created with all states
- ✅ CompletionWindow created (centered, floating)
- ✅ TimerViewModel modified with completion state
- ✅ WindowManager extended with completion window management
- ✅ All completion flows tested and working
- ✅ Auto-start break setting respected
- ✅ Themes and fonts apply correctly
- ✅ Build: 0 errors, 0 warnings
- ✅ Ready for Day 5 (final polish and Week 5 summary update)

---

## Notes & Reminders

- **Focus:** Complete session completion workflow improvement
- **Pattern:** Follow existing window patterns (TimerWindow, DashboardSettingsView)
- **State management:** Use Combine observer pattern for reactive updates
- **Critical change:** Remove `transitionToNextSession()` call in `complete()` method (line 311)
- **Auto-start logic:** Check `settingsManager.settings.pomodoro.autoStartBreak` in `complete()`
- **Window coordination:** TimerWindow hides when CompletionWindow shows
- **Centering:** CompletionWindow always centered via `.center()` call
- **Testing:** Test both auto-start ON and OFF flows
- **Session counter:** Preserve completedSessions counter through all flows
- **Sounds:** Ensure completion sound and break sounds play correctly

**Key User Flows:**

**Flow 1 (Auto-start OFF):**
Pomodoro completes → View shows with buttons → Click "Start Break" → Break runs in view → Break completes → Click "Start Next Pomodoro" → View hides

**Flow 2 (Auto-start ON):**
Pomodoro completes → View shows with break already running → Break completes → Click "Start Next Pomodoro" → View hides

**Flow 3 (Skip):**
Pomodoro completes → View shows → Click "Skip Break" → View hides, timer shows idle Pomodoro

---

## Execution Section

**Start Time:** _[To be filled during execution]_

**Task 1 Progress:**
- [ ] Started
- [ ] Completed
- Notes:

**Task 2 Progress:**
- [ ] Started
- [ ] Completed
- Notes:

**Task 3 Progress:**
- [ ] Started
- [ ] Completed
- Notes:

**Task 4 Progress:**
- [ ] Started
- [ ] Completed
- Notes:

**Task 5 Progress:**
- [ ] Started
- [ ] Completed
- Notes:

**Task 6 Progress:**
- [ ] Started
- [ ] Completed
- Notes:

**Task 7 Progress:**
- [ ] Started
- [ ] Completed
- Notes:

**Blockers:** None anticipated

**End Time:** _[To be filled during execution]_

**Actual Hours:** _[To be filled during execution]_

**Status:** [ ] Complete [ ] In Progress [ ] Blocked

---

**Created:** January 8, 2026
**Status:** 📝 Ready to Start
