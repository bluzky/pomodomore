# Day 2 Plan

**Date:** January 1, 2025
**Goal:** Create timer window UI with layout (no functionality yet)
**Time Estimate:** ~8 hours

---

## Definition of Done

Today is complete when:

- [ ] Timer window appears (320×200px, draggable)
- [ ] Large timer display shows "25:00" (static placeholder)
- [ ] Three buttons rendered: [Start] [Pause] [Reset] (non-functional)
- [ ] Session indicators: ○ ○ ○ ○ (4 static circles)
- [ ] Window has close button and closes properly
- [ ] Window is positioned correctly on screen
- [ ] Build: 0 errors, 0 warnings

---

## Tasks

### Task 1: Create TimerWindow.swift with NSWindow Configuration
**Estimate:** ~2 hours

**What:** Create custom NSWindow subclass for the timer window with proper sizing, styling, and positioning
**Why:** Need a dedicated window that can be shown/hidden from menubar, with specific size and behavior
**Acceptance:**
- [ ] TimerWindow.swift created with NSWindow subclass
- [ ] Window size: 320×200 points (fixed, not resizable)
- [ ] Window style: titled, closable, miniaturizable (no resize)
- [ ] Window level: normal (we'll add "always on top" Day 5)
- [ ] Window appears centered on screen by default
- [ ] Window is draggable by any part of its content area
- [ ] Clicking close button hides window (doesn't quit app)

---

### Task 2: Create TimerView.swift - Main Timer Display
**Estimate:** ~2.5 hours

**What:** Build SwiftUI view for timer display showing "25:00" in large format
**Why:** Core visual element - needs to be readable and prominent
**Acceptance:**
- [ ] TimerView.swift created as SwiftUI view
- [ ] Large text showing "25:00" (static for now)
- [ ] Font: System font, size ~48pt, monospaced
- [ ] Text color: Primary (will add state colors Day 4)
- [ ] Centered horizontally in window
- [ ] Proper spacing from window edges

---

### Task 3: Add Control Buttons (Start/Pause/Reset)
**Estimate:** ~2 hours

**What:** Create three buttons in horizontal layout below timer display
**Why:** User needs controls for timer interaction (wired up Day 4)
**Acceptance:**
- [ ] Three buttons: [Start] [Pause] [Reset]
- [ ] Buttons horizontally aligned and evenly spaced
- [ ] Button style: standard macOS buttons (.bordered or similar)
- [ ] Buttons centered below timer display
- [ ] Buttons are tappable (action prints to console for now)
- [ ] Proper spacing between buttons (~12pt)

---

### Task 4: Add Session Indicator Circles
**Estimate:** ~1.5 hours

**What:** Create 4 circular indicators to show Pomodoro session progress
**Why:** Visual feedback for session count (1 filled circle per completed pomodoro)
**Acceptance:**
- [ ] 4 circles displayed horizontally
- [ ] Circles: unfilled/outlined (stroke only)
- [ ] Circle size: ~12pt diameter
- [ ] Circles positioned at bottom of window
- [ ] Even spacing between circles
- [ ] All circles same color (gray/secondary)
- [ ] Static for now (state management Day 3+)

---

### Task 5: Window Integration & Testing
**Estimate:** ~1 hour

**What:** Connect timer window to menubar menu, add "Open Timer" menu item, test full UI
**Why:** Need way to open window from menubar for testing
**Tests:**
- [ ] Add "Open Timer" menu item to menubar menu
- [ ] Clicking "Open Timer" shows timer window
- [ ] Window displays all UI elements correctly
- [ ] Window is draggable
- [ ] Close button hides window (doesn't quit app)
- [ ] Can re-open window after closing
- [ ] All text is readable and properly sized
**Build:**
- [ ] Product → Clean Build Folder
- [ ] Build: 0 errors, 0 warnings
- [ ] Window renders without visual glitches

---

## Implementation Notes

**Known challenges:**
- NSWindow + SwiftUI: Use NSHostingController to host SwiftUI view in NSWindow
- Window positioning: Use `center()` for initial placement, save position for Day 5
- Close behavior: Override `windowShouldClose` to hide instead of destroy window

**Architecture:**
- **TimerWindow.swift**: NSWindow subclass managing window lifecycle
- **TimerView.swift**: SwiftUI view containing all UI elements
- **AppDelegate**: Manages TimerWindow instance, shows/hides from menu

**Layout Structure:**
```
┌─────────────────────────────┐
│   Timer Window (320×200)    │
│                             │
│         25:00               │ ← Large timer display
│                             │
│   [Start] [Pause] [Reset]   │ ← Control buttons
│                             │
│      ○  ○  ○  ○             │ ← Session indicators
└─────────────────────────────┘
```

**Files:**
- **Create:** `pomodomore/TimerWindow.swift` (NSWindow subclass)
- **Create:** `pomodomore/TimerView.swift` (SwiftUI view)
- **Modify:** `pomodomore/AppDelegate.swift` (add window management, menu item)

**Key Code Patterns:**

```swift
// TimerWindow.swift
class TimerWindow: NSWindow {
    init() {
        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 320, height: 200),
            styleMask: [.titled, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )

        self.center()
        self.title = "Pomodoro Timer"
        self.isReleasedWhenClosed = false

        // Host SwiftUI view
        let timerView = TimerView()
        self.contentView = NSHostingView(rootView: timerView)
    }
}

// TimerView.swift (SwiftUI)
struct TimerView: View {
    var body: some View {
        VStack(spacing: 20) {
            // Timer display
            Text("25:00")
                .font(.system(size: 48, weight: .medium, design: .monospaced))

            // Control buttons
            HStack(spacing: 12) {
                Button("Start") { print("Start tapped") }
                Button("Pause") { print("Pause tapped") }
                Button("Reset") { print("Reset tapped") }
            }

            // Session indicators
            HStack(spacing: 8) {
                ForEach(0..<4) { _ in
                    Circle()
                        .stroke(Color.secondary, lineWidth: 2)
                        .frame(width: 12, height: 12)
                }
            }
        }
        .padding()
        .frame(width: 320, height: 200)
    }
}

// AppDelegate.swift additions
var timerWindow: TimerWindow?

func showTimerWindow() {
    if timerWindow == nil {
        timerWindow = TimerWindow()
    }
    timerWindow?.makeKeyAndOrderFront(nil)
    NSApp.activate(ignoringOtherApps: true)
}
```

---

## Testing Strategy

**Manual Tests:**
1. Launch app → Click "Open Timer" in menubar
2. Verify window appears centered with correct size
3. Verify all UI elements render correctly
4. Click each button → Check console output
5. Drag window by content area → Moves smoothly
6. Click close button → Window hides
7. Re-open window → Appears in same position

**Visual Checks:**
- Timer text is large and readable
- Buttons are properly sized and aligned
- Circles are visible and evenly spaced
- No text clipping or overflow
- Window chrome looks native

---

## Execution (Fill During/After Work)

**Start:** _____

**Progress:**
_[Log timestamps and progress here]_

**Actual Time:** _____ (estimate: ~8 hours)

**Tasks:**
- [ ] Task 1: Create TimerWindow.swift
- [ ] Task 2: Create TimerView.swift
- [ ] Task 3: Add Control Buttons
- [ ] Task 4: Add Session Indicators
- [ ] Task 5: Window Integration & Testing

**Quality:**
- [ ] Build: 0 errors, 0 warnings
- [ ] All UI elements visible
- [ ] Window behavior correct

**Blockers:** _____

**Learnings:** _____

---

**Complete:** _____
