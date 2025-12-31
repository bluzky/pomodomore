# Day 3 Plan

**Date:** January 2, 2025 (Wednesday)
**Goal:** Implement timer countdown mechanism and state management
**Time Estimate:** ~8 hours

---

## Definition of Done

Today is complete when:

- [ ] TimerViewModel.swift created with timer state management
- [ ] Timer counts down from 25:00 to 00:00
- [ ] Display updates every second showing MM:SS format
- [ ] Timer automatically stops at 00:00
- [ ] State machine works: idle → running → completed
- [ ] Timer accuracy verified (no drift over 25 minutes)
- [ ] Build: 0 errors, 0 warnings

---

## Tasks

### Task 1: Create TimerState.swift - Define Timer States
**Estimate:** ~1 hour

**What:** Create enum to represent all possible timer states
**Why:** Need clear state definitions for state machine logic and UI updates
**Acceptance:**
- [ ] TimerState.swift created
- [ ] Enum with states: idle, running, paused, completed
- [ ] Each state documented with comment explaining when it applies
- [ ] State is a simple enum (no associated values needed yet)

---

### Task 2: Create TimerViewModel.swift - State Management Foundation
**Estimate:** ~2.5 hours

**What:** Build ObservableObject view model to manage timer state and time remaining
**Why:** Central state management for timer logic, separated from UI concerns
**Acceptance:**
- [ ] TimerViewModel.swift created as ObservableObject
- [ ] @Published var currentState: TimerState = .idle
- [ ] @Published var timeRemaining: Int (seconds, starts at 1500 = 25min)
- [ ] Computed property timeFormatted: String (returns "MM:SS" format)
- [ ] Property totalTime: Int = 1500 (25 minutes in seconds)
- [ ] Initialize with default values (25:00, idle state)

---

### Task 3: Implement Countdown Timer Logic
**Estimate:** ~2.5 hours

**What:** Add Timer.publish mechanism to decrement timeRemaining every second
**Why:** Core timer functionality - must be accurate and reliable
**Acceptance:**
- [ ] Use Combine's Timer.publish(every: 1.0, on: .main, in: .common)
- [ ] Timer decrements timeRemaining by 1 every second
- [ ] Timer only runs when currentState == .running
- [ ] Timer automatically cancels when timeRemaining reaches 0
- [ ] State changes to .completed when timer reaches 0
- [ ] No timer drift (verify with print statements)
- [ ] Timer subscription properly managed (no memory leaks)

---

### Task 4: Add Start/Stop/Reset Methods (No UI Wiring Yet)
**Estimate:** ~1.5 hours

**What:** Create methods to control timer state transitions
**Why:** Encapsulate state machine logic, ready for button wiring on Day 4
**Acceptance:**
- [ ] func start() - sets state to .running, starts countdown
- [ ] func pause() - sets state to .paused, stops countdown
- [ ] func reset() - sets state to .idle, resets timeRemaining to 1500
- [ ] State transitions are safe (can't start when already running, etc.)
- [ ] Methods print state changes to console for debugging
- [ ] Timer cancellation handled properly in pause/reset

---

### Task 5: Wire TimerViewModel to TimerView & Test
**Estimate:** ~1.5 hours

**What:** Connect TimerViewModel to TimerView, replace static "25:00" with live countdown
**Why:** Verify timer logic works and updates UI correctly
**Tests:**
- [ ] Update TimerView.swift to use @StateObject var viewModel = TimerViewModel()
- [ ] Replace static "25:00" text with Text(viewModel.timeFormatted)
- [ ] Timer display updates every second when running
- [ ] MM:SS format displays correctly (e.g., "25:00", "24:59", "00:01", "00:00")
- [ ] Timer stops at 00:00 and state changes to .completed
- [ ] Run timer for 30+ seconds to verify no drift or skipped seconds
- [ ] Call viewModel.start() from console/debug to test countdown
**Build:**
- [ ] Product → Clean Build Folder
- [ ] Build: 0 errors, 0 warnings
- [ ] Timer counts down smoothly without UI glitches

---

## Implementation Notes

**Known challenges:**
- Timer accuracy: Combine Timer.publish may have slight drift; acceptable for MVP
- State transitions: Need to prevent invalid transitions (e.g., can't pause when idle)
- Memory management: Must properly cancel timer subscription to avoid leaks

**Architecture:**
- **TimerState.swift**: Simple enum defining 4 states
- **TimerViewModel.swift**: ObservableObject managing timer logic (MVVM pattern)
- **TimerView.swift**: Updated to observe and display viewModel state
- No button wiring yet - that's Day 4 (today just verifies countdown works)

**State Machine:**
```
idle → running → completed
  ↑       ↓
  └─── paused
```

**Timer Logic Approach:**
```swift
// TimerViewModel.swift
import Combine

class TimerViewModel: ObservableObject {
    @Published var currentState: TimerState = .idle
    @Published var timeRemaining: Int = 1500 // 25 min in seconds

    private var timerCancellable: AnyCancellable?
    private let totalTime: Int = 1500

    var timeFormatted: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    func start() {
        guard currentState != .running else { return }
        currentState = .running

        timerCancellable = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }

    private func tick() {
        guard timeRemaining > 0 else {
            complete()
            return
        }
        timeRemaining -= 1
    }

    private func complete() {
        currentState = .completed
        timerCancellable?.cancel()
    }

    func pause() {
        guard currentState == .running else { return }
        currentState = .paused
        timerCancellable?.cancel()
    }

    func reset() {
        currentState = .idle
        timeRemaining = totalTime
        timerCancellable?.cancel()
    }
}
```

**Files:**
- **Create:** `pomodomore/TimerState.swift` (enum)
- **Create:** `pomodomore/TimerViewModel.swift` (view model)
- **Modify:** `pomodomore/TimerView.swift` (connect to view model)

**Testing Strategy:**

Manual verification:
1. Add debug button to call `viewModel.start()` OR call from Xcode console
2. Watch timer count down from 25:00
3. Verify updates every second (no skips, no drift)
4. Verify stops at 00:00
5. Check state changes (print to console)
6. Run for 60+ seconds to verify accuracy

For faster testing during development:
- Temporarily set totalTime = 10 (test 10-second countdown)
- Restore to 1500 before committing

---

## Execution (Fill During/After Work)

**Start:** _____

**Progress:**
_[Log timestamps and progress here]_

**Actual Time:** _____ (estimate: ~8 hours)

**Tasks:**
- [ ] Task 1: Create TimerState.swift
- [ ] Task 2: Create TimerViewModel.swift foundation
- [ ] Task 3: Implement countdown timer logic
- [ ] Task 4: Add start/pause/reset methods
- [ ] Task 5: Wire to TimerView and test

**Quality:**
- [ ] Build: 0 errors, 0 warnings
- [ ] Timer counts down accurately
- [ ] State transitions work correctly
- [ ] No memory leaks (timer cancels properly)

**Blockers:** _____

**Learnings:** _____

---

**Complete:** _____
