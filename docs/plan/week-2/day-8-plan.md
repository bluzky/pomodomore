# Day 8 Plan - Session Indicators UI

**Date:** Wednesday, January 8, 2025
**Week:** Week 2, Day 3
**Goal:** Add visual session progress indicators (4 circles)
**Available Hours:** ___
**Branch:** `vk/260d-start-day-8-week`

---

## Context

Days 1-2 delivered the session type system (Pomodoro, Short Break, Long Break) and automatic cycle logic (4 Pomodoros → Long Break). Today we add visual feedback showing cycle progress with 4 circles that fill as Pomodoros complete.

**Previous Days:**
- Day 1: Session type system with three durations ✅
- Day 2: Session cycle logic with auto-transitions ✅

---

## Goal

Create a session indicator component displaying 4 circles at the bottom of the timer window that:
- Show empty circles (○) for upcoming Pomodoros
- Show filled circles (●) for completed Pomodoros
- Update in real-time as sessions complete
- Reset after Long Break completes

---

## Definition of Done

- [ ] SessionIndicatorsView component created and renders 4 circles
- [ ] Circles display correctly: empty (○) for pending, filled (●) for completed
- [ ] Indicators integrated into TimerView at bottom, centered
- [ ] Circles update when completedSessions changes in ViewModel
- [ ] Circles reset to empty after Long Break completes
- [ ] Visual spacing and alignment look good (12pt diameter, 8pt spacing)
- [ ] Build: 0 errors, 0 warnings
- [ ] Manual test: Circles fill progressively (●○○○ → ●●○○ → ●●●○ → ●●●●)
- [ ] Manual test: Circles reset after Long Break (●●●● → ○○○○)

---

## Tasks

### Task 1: Create SessionIndicatorsView Component
**What:** New SwiftUI view component displaying 4 circles
**Why:** Need reusable UI component for session progress visualization
**Estimate:** 1.5 hours

**Acceptance Criteria:**
- File `SessionIndicatorsView.swift` created in Views folder
- View displays exactly 4 circles in horizontal row
- Takes `completedSessions: Int` as parameter (0-4)
- Circles render as:
  - Index 0-3: filled (●) if index < completedSessions, empty (○) otherwise
  - Circle size: 12pt diameter
  - Spacing: 8pt between circles
  - Colors: Filled (primary theme color), Empty (secondary/border color)
- Component builds without errors

**Implementation Notes:**
- Use `HStack` for horizontal layout
- Use `Circle()` shape with `.fill()` or `.stroke()` based on state
- Consider using `ForEach(0..<4)` to generate circles
- Color filled circles with existing theme primary color
- Color empty circles with gray or border color for contrast

---

### Task 2: Integrate Indicators into TimerView
**What:** Add SessionIndicatorsView to bottom of timer window
**Why:** Users need to see session progress while timer runs
**Estimate:** 1 hour

**Acceptance Criteria:**
- SessionIndicatorsView added to TimerView layout
- Positioned at bottom of timer window, horizontally centered
- Proper spacing from timer countdown (16-20pt vertical spacing)
- Indicators bind to `viewModel.completedSessions`
- View updates automatically when completedSessions changes
- Layout doesn't break with different session states
- Build: 0 errors, 0 warnings

**Implementation Notes:**
- Update TimerView.swift VStack layout
- Add SessionIndicatorsView below controls/buttons
- Use `.padding()` for proper spacing
- Pass `completedSessions` from ViewModel to component
- Test layout in different states (idle, running, paused)

**Layout Target:**
```
  25:00
  [Pause] [Reset]
  ●●○○              <- Session indicators here
```

---

### Task 3: Verify Real-Time Updates
**What:** Test that indicators update correctly during session cycle
**Why:** Ensure UI stays in sync with ViewModel state
**Estimate:** 0.5 hours

**Acceptance Criteria:**
- Start with 0 sessions: displays ○○○○
- Complete 1st Pomodoro: displays ●○○○
- Complete 2nd Pomodoro: displays ●●○○
- Complete 3rd Pomodoro: displays ●●●○
- Complete 4th Pomodoro: displays ●●●●
- Complete Long Break: displays ○○○○
- Updates happen immediately when state changes
- No visual glitches or lag

**Implementation Notes:**
- Use shortened durations for testing:
  - Pomodoro: 10 seconds
  - Short Break: 5 seconds
  - Long Break: 8 seconds
- Manually click through full cycle
- Observe indicators update at each transition
- Restore production durations after testing

---

### Task 4: Edge Case Testing & Polish
**What:** Test edge cases and refine visual appearance
**Why:** Ensure indicators work in all scenarios and look polished
**Estimate:** 1 hour

**Acceptance Criteria:**
- Test Reset during cycle: indicators remain unchanged
- Test Stop during break: indicators remain unchanged
- Test manual session changes: indicators update correctly
- Verify alignment on different window sizes
- Colors have good contrast and visibility
- Spacing is visually balanced
- Build: 0 errors, 0 warnings
- All previous tests still pass

**Test Cases:**
1. Reset during Pomodoro at ●●○○ → stays ●●○○
2. Pause/Resume during Pomodoro → no change to indicators
3. Stop during Short Break at ●●○○ → stays ●●○○
4. Window resize → indicators stay centered
5. Different macOS appearance modes (Light/Dark) → colors visible

**Polish Checklist:**
- [ ] Circle borders crisp and clean
- [ ] Filled circles clearly distinguishable from empty
- [ ] Vertical alignment with other UI elements
- [ ] Proper padding from window edges

---

## Testing Strategy

**Build Verification:**
- Run build: 0 errors, 0 warnings required
- All Swift files compile successfully

**Manual Testing (with shortened durations):**
1. Set test durations in code (Pomodoro: 10s, Short Break: 5s, Long Break: 8s)
2. Start fresh timer (should show ○○○○)
3. Complete 1st Pomodoro → verify ●○○○
4. Complete Short Break → verify still ●○○○
5. Complete 2nd Pomodoro → verify ●●○○
6. Complete 3rd Pomodoro → verify ●●●○
7. Complete 4th Pomodoro → verify ●●●●
8. Complete Long Break → verify ○○○○
9. Test Reset during cycle → indicators unchanged
10. Restore production durations

**Visual Testing:**
- Check spacing and alignment
- Verify colors in Light and Dark mode
- Test window at different sizes

---

## Implementation Sequence

1. **Create SessionIndicatorsView component** (Task 1)
   - Create new file
   - Implement circle rendering logic
   - Test component in isolation (preview)

2. **Integrate into TimerView** (Task 2)
   - Add to layout
   - Wire up ViewModel binding
   - Verify build

3. **Test real-time updates** (Task 3)
   - Set test durations
   - Run full cycle manually
   - Verify all transitions

4. **Edge cases and polish** (Task 4)
   - Test edge cases
   - Refine visual appearance
   - Final build verification

---

## Files to Modify/Create

**New Files:**
- `pomodomore/Views/SessionIndicatorsView.swift` (new component)

**Modified Files:**
- `pomodomore/Views/TimerView.swift` (integrate indicators)
- `pomodomore/ViewModels/TimerViewModel.swift` (verify completedSessions exposed)

**Reference Files:**
- `pomodomore/Models/SessionType.swift` (session type durations)
- `pomodomore/Models/Session.swift` (session model)

---

## Success Criteria

End of day checklist:
- [ ] SessionIndicatorsView.swift created and functional
- [ ] 4 circles render correctly (empty and filled states)
- [ ] Indicators integrated into TimerView
- [ ] Circles update in real-time during session cycle
- [ ] Circles reset after Long Break
- [ ] Visual spacing and alignment polished
- [ ] Build: 0 errors, 0 warnings
- [ ] Manual testing completed with all scenarios passing
- [ ] Production durations restored

---

## Notes & Learnings

### Architecture Decisions
_[Document any architectural choices made during implementation]_

### Challenges Encountered
_[Note any unexpected issues and solutions]_

### Code Patterns Used
_[Document useful SwiftUI patterns for future reference]_

---

## Execution Log

_[Fill this section during the day as you work]_

**Start Time:** ___
**End Time:** ___
**Actual Hours:** ___

**Progress:**
- [ ] Task 1: Create SessionIndicatorsView Component
- [ ] Task 2: Integrate Indicators into TimerView
- [ ] Task 3: Verify Real-Time Updates
- [ ] Task 4: Edge Case Testing & Polish

**Blockers:**
_[List any blockers encountered]_

**Wins:**
_[Celebrate small wins during the day]_

---

**Next Day:** Day 9 - Break UI & Controls (session type labels, Stop button, color changes)
