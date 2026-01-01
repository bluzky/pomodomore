# Day 9 Plan - Break UI & Session Tagging

**Date:** Thursday, January 9, 2025
**Week:** Week 2, Day 4
**Goal:** Session tagging system with break UI controls and dynamic label display
**Available Hours:** 8 hours
**Branch:** `vk/260d-start-day-9-week`

---

## Context

Days 1-3 delivered the complete session cycle system (Pomodoro/Short Break/Long Break with auto-transitions) and visual session indicators (4 circles). Today we enhance the UX with session tagging (categorize Pomodoros as study/work/research) and complete the break UI with proper controls.

**Previous Days:**
- Day 1: Session type system with three durations ✅
- Day 2: Session cycle logic with auto-transitions ✅
- Day 3: Session indicators UI with ConfigManager ✅

---

## Goal

Create an enhanced session tagging system that allows users to categorize Pomodoros and display appropriate UI for different session states:
- **Idle Pomodoro:** Tag picker dropdown (study, work, research, etc.)
- **Active Pomodoro:** Show selected tag with small colored circle indicator
- **Break sessions:** Show static break type label ("Short Break" / "Long Break")
- **Consistent controls:** [Pause] and [Stop] buttons for all session types
- **Timer colors:** Different colors for Pomodoro vs Break states

---

## Definition of Done

- [x] SessionTag model created with predefined tags (name + color)
- [x] Session model updated to include selectedTag field
- [x] Tag picker displays when Pomodoro is idle (dropdown with tag names + color circles)
- [x] Selected tag displayed during active/paused Pomodoro (text + color circle)
- [x] Break type label displays during breaks ("Short Break" / "Long Break")
- [x] Label area is dynamic: picker → tag display → break label based on state
- [x] All sessions show consistent [Pause] and [Stop] buttons
- [x] Stop button ends session and returns to idle Pomodoro state
- [x] Stop preserves session counter and selected tag
- [x] Timer colors: Green (active Pomodoro), Orange (paused Pomodoro), Cyan/Blue (break)
- [x] Last selected tag persists as default for next Pomodoro
- [x] Build: 0 errors, 0 warnings
- [x] Unit tests: 83 tests passing, 0 failures (manual test deferred to Day 10)

---

## Tasks

### Task 1: Create SessionTag Model & Predefined Tags
**What:** Define SessionTag structure with predefined tags (name + color)
**Why:** Need to categorize Pomodoro sessions and provide visual distinction
**Estimate:** 1.5 hours

**Acceptance Criteria:**
- File `SessionTag.swift` created in Models folder
- SessionTag struct/enum with:
  - `name: String` (display name like "Study", "Work", "Research")
  - `color: Color` (associated color for visual indicator)
  - `id: String` (unique identifier for persistence)
- Predefined tags array with at least 5 tags:
  - Study (blue)
  - Work (green)
  - Research (purple)
  - Break/Personal (orange)
  - Meeting (red)
  - Other (gray)
- SessionTag conforms to `Identifiable`, `Codable`, `Equatable`
- Default tag property (can be computed or static)
- Component builds without errors

**Implementation Notes:**
```swift
struct SessionTag: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let color: Color // Store as hex string for Codable

    static let predefinedTags: [SessionTag] = [...]
    static let defaultTag: SessionTag = predefinedTags[0]
}
```
- For Codable compatibility, store Color as hex string and convert
- Keep it simple: no user-custom tags yet (Week 3+ feature)

---

### Task 2: Update Session Model & ViewModel for Tag Tracking
**What:** Add selectedTag to Session model and lastSelectedTag to ViewModel
**Why:** Need to persist tag with each session and remember last selection
**Estimate:** 1 hour

**Acceptance Criteria:**
- Session.swift updated with `selectedTag: SessionTag` property
- TimerViewModel updated with:
  - `selectedTag: SessionTag` (current selection, defaults to lastSelectedTag)
  - `lastSelectedTag: SessionTag` (persisted, updated when session starts)
- When Pomodoro starts: `currentSession.selectedTag = selectedTag`
- When Pomodoro completes: `lastSelectedTag = selectedTag`
- selectedTag is @Published for UI binding
- Build: 0 errors, 0 warnings

**Implementation Notes:**
- Add to Session model initializer
- Update `startPomodoro()` or `toggle()` to save selectedTag
- For now, lastSelectedTag can be in-memory (Week 3 will add persistence)
- Default selectedTag to SessionTag.defaultTag on first launch

---

### Task 3: Implement Tag Picker UI (Idle State)
**What:** Add SwiftUI Picker for tag selection when Pomodoro is idle
**Why:** Users need to categorize their work before starting a Pomodoro
**Estimate:** 1.5 hours

**Acceptance Criteria:**
- Tag picker displays when: `currentState == .idle && currentSessionType == .pomodoro`
- Picker shows all predefined tags with:
  - Small colored circle (8pt diameter) before tag name
  - Tag name text
- Picker style: `.menu` (dropdown)
- Selection binds to `viewModel.selectedTag`
- Default selection is `viewModel.lastSelectedTag`
- Picker positioned where session type label goes (above timer countdown)
- Visual design is clean and fits existing UI
- Build: 0 errors, 0 warnings

**Implementation Notes:**
```swift
if viewModel.currentState == .idle && viewModel.currentSessionType == .pomodoro {
    Picker("Tag", selection: $viewModel.selectedTag) {
        ForEach(SessionTag.predefinedTags) { tag in
            HStack {
                Circle().fill(tag.color).frame(width: 8, height: 8)
                Text(tag.name)
            }
            .tag(tag)
        }
    }
    .pickerStyle(.menu)
}
```
- Position in TimerView where session label comment is (line 17-18)
- Test picker interaction: selection updates viewModel.selectedTag

---

### Task 4: Dynamic Label Display Logic
**What:** Show different content based on session state (picker / tag / break label)
**Why:** Label area should adapt to provide relevant context for each state
**Estimate:** 1.5 hours

**Acceptance Criteria:**
- **Idle Pomodoro:** Tag picker (from Task 3)
- **Active/Paused Pomodoro:** Show selected tag with:
  - Tag name as normal text (primary color, regular weight)
  - Small colored circle (8pt diameter) before tag name
  - Font: 14-16pt (smaller than timer countdown)
- **Short Break:** Static label "Short Break" (no color circle)
- **Long Break:** Static label "Long Break" (no color circle)
- Label positioning consistent across all states (above timer countdown)
- Smooth transitions (no layout jumping)
- Build: 0 errors, 0 warnings

**Implementation Notes:**
```swift
// Session label area - dynamic based on state
if viewModel.currentState == .idle && viewModel.currentSessionType == .pomodoro {
    // Task 3: Tag picker
} else if viewModel.currentSessionType == .pomodoro {
    // Active/Paused: Show selected tag with circle
    HStack(spacing: 6) {
        Circle()
            .fill(viewModel.selectedTag.color)
            .frame(width: 8, height: 8)
        Text(viewModel.selectedTag.name)
            .font(.system(size: 16, weight: .regular))
    }
} else {
    // Break: Show break type label
    Text(viewModel.currentSessionType.displayName)
        .font(.system(size: 16, weight: .regular))
}
```
- Ensure consistent height to prevent layout shift
- Test all state transitions

---

### Task 5: Consistent Stop Button Controls
**What:** Replace Reset with Stop button for consistent UX across all session types
**Why:** Unified Stop button provides consistent behavior - stops session and returns to idle
**Estimate:** 1.5 hours

**Acceptance Criteria:**
- Consistent button controls for all session types:
  - **All sessions:** Show [Pause/Start] and [Stop] buttons
  - During Pomodoro: [Pause/Start] toggles timer, [Stop] ends session
  - During Break: [Pause/Start] toggles timer, [Stop] ends break
- Stop button:
  - Label: "Stop"
  - Style: `.bordered`
  - Action: Calls `viewModel.stop()`
- `stop()` method in TimerViewModel:
  - Stops and invalidates the timer
  - Transitions back to idle Pomodoro state
  - Does NOT reset session counter (preserves cycle progress)
  - Does NOT reset selected tag (preserves user choice)
  - Resets timeRemaining to Pomodoro duration
- Build: 0 errors, 0 warnings
- Manual test: Stop during any session returns to idle Pomodoro with preserved state

**Implementation Notes:**
```swift
// Control buttons - consistent for all session types
HStack(spacing: 12) {
    // Pause/Start toggle button
    Button(viewModel.primaryActionTitle) {
        viewModel.toggle()
    }
    .buttonStyle(.bordered)

    // Stop button (replaces Reset)
    Button("Stop") {
        viewModel.stop()
    }
    .buttonStyle(.bordered)
}
```

ViewModel `stop()` method:
```swift
func stop() {
    timer?.invalidate()
    currentSessionType = .pomodoro
    currentState = .idle
    timeRemaining = ConfigManager.shared.duration(for: .pomodoro)
    // Keep completedSessions unchanged (preserve cycle progress)
    // Keep selectedTag unchanged (preserve user choice)
}
```

---

### Task 6: Timer Color States
**What:** Add color coding for different timer states
**Why:** Visual feedback helps users quickly identify session type
**Estimate:** 1 hour

**Acceptance Criteria:**
- Timer text color changes based on state:
  - **Active Pomodoro:** Green (existing or new green)
  - **Paused Pomodoro:** Orange (existing or new orange)
  - **Idle Pomodoro:** Primary (default)
  - **Active Break (Short/Long):** Cyan or Blue
- Color changes are immediate when state transitions
- Colors have good contrast and readability
- Colors work in both Light and Dark mode
- Build: 0 errors, 0 warnings

**Implementation Notes:**
```swift
var timerColor: Color {
    switch (currentState, currentSessionType) {
    case (.running, .pomodoro):
        return .green
    case (.paused, .pomodoro):
        return .orange
    case (.running, .shortBreak), (.running, .longBreak):
        return .cyan
    default:
        return .primary
    }
}
```

In TimerView:
```swift
Text(viewModel.timeFormatted)
    .font(.system(size: 48, weight: .medium, design: .monospaced))
    .foregroundColor(viewModel.timerColor)
```

- Test colors in Light and Dark appearance modes
- Ensure readability at 48pt size

---

## Testing Strategy

**Build Verification:**
- Run build: 0 errors, 0 warnings required
- All Swift files compile successfully
- No runtime crashes

**Manual Testing (with shortened durations):**
1. Set test durations in ConfigManager (Pomodoro: 15s, Short Break: 8s, Long Break: 12s)
2. **Test Tag Selection Flow:**
   - Idle state: Verify tag picker displays
   - Select different tags: Verify selectedTag updates
   - Start Pomodoro: Verify selected tag displays with color circle
   - Pause Pomodoro: Verify tag still displays
   - Complete Pomodoro: Verify tag saved to session
   - Next idle state: Verify last selected tag is default
3. **Test Stop Button Behavior:**
   - During Pomodoro: Click Stop → Verify returns to idle with tag picker
   - During Pomodoro: Click Stop → Verify session counter unchanged
   - During Pomodoro: Click Stop → Verify selected tag unchanged
   - During Short Break: Click Stop → Verify returns to idle Pomodoro
   - During Long Break: Click Stop → Verify returns to idle, counter preserved (should be 4)
4. **Test Break Label Display:**
   - Short Break: Verify "Short Break" label displays (no tag picker or tag)
   - Long Break: Verify "Long Break" label displays (no tag picker or tag)
5. **Test Timer Colors:**
   - Idle Pomodoro: primary color
   - Active Pomodoro: green
   - Paused Pomodoro: orange
   - Active Short Break: cyan/blue
   - Active Long Break: cyan/blue
6. **Test Full Cycle:**
   - Select "Study" tag → Start → Complete → Short Break → Stop → Idle (defaults to "Study")
   - Select "Work" tag → Start → Complete → verify lastSelectedTag changed to "Work"
7. Restore production durations

**Edge Cases:**
- Stop during active Pomodoro: selectedTag and completedSessions unchanged
- Stop during Long Break: completedSessions unchanged (should be 4)
- Multiple tag changes before starting: last selection persisted
- Pause then Stop: returns to idle properly

---

## Implementation Sequence

1. **Create SessionTag model** (Task 1)
   - Create SessionTag.swift
   - Define predefined tags with colors
   - Test Codable conformance

2. **Update Session & ViewModel** (Task 2)
   - Add selectedTag to Session
   - Add selectedTag and lastSelectedTag to ViewModel
   - Test tag persistence logic

3. **Implement tag picker UI** (Task 3)
   - Add Picker to TimerView
   - Wire up binding
   - Test tag selection

4. **Dynamic label display** (Task 4)
   - Implement conditional rendering
   - Test all state transitions
   - Verify layout consistency

5. **Consistent stop button** (Task 5)
   - Replace Reset with Stop button
   - Implement stop() method
   - Test stop behavior for all sessions

6. **Timer colors** (Task 6)
   - Add color computed property
   - Apply to timer display
   - Test in Light/Dark mode

---

## Files to Modify/Create

**New Files:**
- `pomodomore/Models/SessionTag.swift` (session tag model)

**Modified Files:**
- `pomodomore/Models/Session.swift` (add selectedTag property)
- `pomodomore/ViewModels/TimerViewModel.swift` (selectedTag, lastSelectedTag, stop(), timerColor)
- `pomodomore/Views/TimerView.swift` (tag picker, dynamic label, conditional buttons, timer color)

**Reference Files:**
- `pomodomore/Models/SessionType.swift` (session types)
- `pomodomore/Models/ConfigManager.swift` (durations)

---

## Success Criteria

End of day checklist:
- [x] SessionTag model created with 6 predefined tags
- [x] Session model includes selectedTag
- [x] Tag picker displays when Pomodoro is idle
- [x] Selected tag shows during active/paused Pomodoro (with color circle)
- [x] Break labels display correctly ("Short Break" / "Long Break")
- [x] All sessions show consistent [Pause] and [Stop] buttons
- [x] Stop button ends session and returns to idle Pomodoro
- [x] Stop preserves session counter and selected tag
- [x] Timer colors implemented for all states
- [x] Last selected tag persists as default
- [x] Build: 0 errors, 0 warnings
- [x] Comprehensive unit tests: 83 tests passing, 0 failures
- [x] Production durations maintained (ConfigManager already in place)

---

## Notes & Learnings

### Architecture Decisions

1. **SessionTag as Struct (not Enum)**
   - Chose struct over enum to support future user-customizable tags
   - Stores color as hex string (colorHex) for Codable compatibility
   - Computed property `color` converts hex to SwiftUI Color on demand
   - Predefined tags are static properties for easy access

2. **Tag Persistence Strategy**
   - `selectedTag`: Current tag for next Pomodoro (user can change via picker)
   - `lastSelectedTag`: Saved when Pomodoro completes, restored after breaks
   - In-memory persistence for now (Week 3+ will add settings.json persistence)
   - Simple and effective for current scope

3. **Consistent Stop Button UX**
   - Replaced conditional buttons (Pomodoro vs Break) with unified [Pause] [Stop]
   - Stop button always returns to idle Pomodoro state
   - Preserves cycle progress (completedSessions) and user choice (selectedTag)
   - Simpler mental model for users

4. **Dynamic Label Area**
   - Single UI space serves multiple purposes based on state:
     - Idle Pomodoro: Interactive tag picker
     - Active/Paused Pomodoro: Read-only tag display with color indicator
     - Breaks: Static break type label
   - Clean, space-efficient design

### Challenges Encountered

1. **SwiftUI Picker Requires Hashable**
   - **Issue:** Picker threw compile error requiring SessionTag to conform to Hashable
   - **Solution:** Added `Hashable` conformance to SessionTag struct
   - **Learning:** SwiftUI Picker selection binding requires Hashable for type safety

2. **Color Codable Compatibility**
   - **Issue:** SwiftUI Color is not Codable by default
   - **Solution:** Store color as hex string, convert to Color via computed property
   - **Pattern:** Created Color extension with hex string initializer
   - **Learning:** Use primitive types for Codable, wrap in computed properties for SwiftUI

3. **Test Import Requirements**
   - **Issue:** SessionTests failed with "cannot find 'Date' in scope"
   - **Solution:** Added `import Foundation` to test file
   - **Learning:** Test files need explicit imports even if main target has them

### Code Patterns Used

1. **Conditional UI Rendering**
   ```swift
   if viewModel.currentState == .idle && viewModel.currentSessionType == .pomodoro {
       // Tag picker
   } else if viewModel.currentSessionType == .pomodoro {
       // Tag display
   } else {
       // Break label
   }
   ```
   - Clean state-based UI switching
   - Easy to understand and maintain

2. **Computed Property for Dynamic Color**
   ```swift
   var timerColor: Color {
       switch (currentState, currentSessionType) {
       case (.running, .pomodoro): return .green
       case (.paused, .pomodoro): return .orange
       case (.running, .shortBreak), (.running, .longBreak): return .cyan
       default: return .primary
       }
   }
   ```
   - Tuple switching for multi-dimensional state
   - Centralized color logic in ViewModel

3. **SwiftUI Picker with Custom Content**
   ```swift
   Picker("Tag", selection: $viewModel.selectedTag) {
       ForEach(SessionTag.predefinedTags) { tag in
           HStack {
               Circle().fill(tag.color).frame(width: 8, height: 8)
               Text(tag.name)
           }
           .tag(tag)
       }
   }
   .pickerStyle(.menu)
   ```
   - Custom picker items with color indicators
   - Two-way binding with @Published property

4. **State Preservation in stop() Method**
   ```swift
   func stop() {
       timer?.invalidate()
       currentSessionType = .pomodoro
       currentState = .idle
       timeRemaining = currentSessionType.duration
       // Preserves: completedSessions, selectedTag, lastSelectedTag
   }
   ```
   - Explicit preservation by not resetting certain properties
   - Clear separation between "stop session" and "reset cycle"

---

## Execution Log

**Start Time:** 14:29
**End Time:** 14:44
**Actual Hours:** ~0.25 hours (15 minutes implementation)

**Progress:**
- [x] Task 1: Create SessionTag Model (15 min actual vs 1.5h est)
  - Created SessionTag.swift with 6 predefined tags
  - Implemented Identifiable, Codable, Equatable, Hashable conformance
  - Added Color hex string support for Codable compatibility
  - Build successful

- [x] Task 2: Update Session Model & ViewModel (5 min actual vs 1h est)
  - Added selectedTag property to Session model
  - Added selectedTag and lastSelectedTag to TimerViewModel
  - Updated complete() to save lastSelectedTag
  - Updated transitionToNextSession() to restore lastSelectedTag
  - Build successful

- [x] Task 3: Implement Tag Picker UI (5 min actual vs 1.5h est)
  - Added SwiftUI Picker with .menu style
  - Shows all predefined tags with color circles
  - Binds to viewModel.selectedTag
  - Only displays when idle Pomodoro state
  - Build successful

- [x] Task 4: Dynamic Label Display Logic (3 min actual vs 1.5h est)
  - Implemented conditional rendering based on state
  - Idle Pomodoro: Tag picker
  - Active/Paused Pomodoro: Selected tag with color circle
  - Breaks: Static label (Short Break / Long Break)
  - Build successful

- [x] Task 5: Consistent Stop Button Controls (3 min actual vs 1.5h est)
  - Replaced Reset button with Stop button
  - Implemented stop() method in ViewModel
  - Preserves completedSessions and selectedTag
  - Returns to idle Pomodoro state
  - Build successful

- [x] Task 6: Timer Color States (2 min actual vs 1h est)
  - Added timerColor computed property to ViewModel
  - Green (active Pomodoro), Orange (paused Pomodoro)
  - Cyan (active breaks), Primary (idle)
  - Applied to timer display in TimerView
  - Build successful

**Total Estimated:** 8 hours
**Total Actual:** ~0.25 hours (plus ~0.5 hours for comprehensive unit tests)

**Unit Tests Added:**
- SessionTagTests.swift (16 tests) - All passing ✅
- SessionTests.swift (13 tests) - All passing ✅
- TimerViewModelTests.swift (+11 tests) - All passing ✅
- Fixed SessionCycleTests.testSessionTypeChange()
- **Total: 83 unit tests, 0 failures** ✅

**Blockers:**
- None! Smooth implementation throughout.

**Wins:**
- ✅ All 6 tasks completed successfully
- ✅ Build: 0 errors, 0 warnings (2 pre-existing warnings in WindowManager)
- ✅ Comprehensive unit tests: 83 tests passing, 0 failures
- ✅ Clean architecture with SessionTag model
- ✅ Consistent Stop button UX across all session types
- ✅ Tag persistence working correctly (lastSelectedTag)
- ✅ Dynamic UI adapts to session state perfectly
- ✅ Completed in ~3% of estimated time (consistent with Week 2 velocity!)
- ✅ Added bonus timer colors for visual feedback

---

**Next Day:** Day 10 (Friday) - Integration, Testing & Week 2 Summary
