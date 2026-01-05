# Day 1 Plan - Session Storage Validation

**Date:** January 6, 2026
**Week:** Week 4
**Goal:** Validate session storage + Dashboard integration
**Time Estimate:** ~2 hours (based on velocity)

---

## Definition of Done

Day complete when:
- [ ] Build: 0 errors, 0 warnings
- [ ] Session saving verified (TimerViewModel → StorageManager → sessions.json)
- [ ] Session loading verified (StorageManager → StatisticsManager → Dashboard)
- [ ] Dashboard shows real data from storage
- [ ] Edge cases tested (empty storage, malformed data)
- [ ] Console shows no errors or warnings during testing

---

## Tasks

### Task 1: Build Verification
**Estimate:** 5 minutes

**What:** Verify project builds cleanly

**Acceptance:**
- [ ] ⌘+B → 0 errors, 0 warnings
- [ ] No SwiftUI preview errors

---

### Task 2: Session Storage Flow Test
**Estimate:** 30 minutes

**What:** Verify sessions are saved to sessions.json when timer completes

**Acceptance:**
- [ ] Run app, complete a Pomodoro session
- [ ] Check `~/Library/Application Support/PomodoMore/sessions.json` exists
- [ ] File contains valid JSON with session data
- [ ] Session includes: sessionType, completionTime, sessionNumber, selectedTag
- [ ] Console shows "Session saved to storage" message

**Manual Test Steps:**
1. Open app from Xcode (⌘+R)
2. Start and complete a Pomodoro (wait 25 min or adjust duration for testing)
3. Check console for save message
4. Open `~/Library/Application Support/PomodoMore/sessions.json` in editor
5. Verify JSON structure

---

### Task 3: Dashboard Data Display Test
**Estimate:** 30 minutes

**What:** Verify Dashboard shows data loaded from storage

**Acceptance:**
- [ ] Open Dashboard (⌘+,)
- [ ] Today cards show correct session count
- [ ] Week chart displays data
- [ ] Statistics match saved sessions
- [ ] Console shows "StatisticsManager: Loaded X sessions"

**Manual Test Steps:**
1. Complete 3 Pomodoro sessions
2. Open Dashboard
3. Verify "Today" shows "3 sessions"
4. Verify "Minutes" shows ~75 minutes
5. Verify chart shows 3 bars for today

---

### Task 4: Edge Case Testing
**Estimate:** 30 minutes

**What:** Test edge cases for robustness

**Acceptance:**
- [ ] Empty sessions.json → Dashboard shows 0, 0, 0
- [ ] Malformed sessions.json → Graceful handling, no crash
- [ ] Missing sessions.json → App starts normally
- [ ] Date boundary → Week navigation works correctly

**Manual Test Steps:**
1. Delete sessions.json → Open app → Check Dashboard shows zeros
2. Corrupt sessions.json (add invalid JSON) → Open app → No crash
3. Complete session at 11:59 PM → Check it counts for correct day
4. Test week navigation (prev week button)

---

### Task 5: Code Review + Fixes
**Estimate:** 30 minutes

**What:** Review code for issues, fix any found

**Acceptance:**
- [ ] No force-unwrap (!) on session loading
- [ ] No silently swallowing errors
- [ ] Error messages are helpful
- [ ] Console debug logs can be disabled for release

**Checklist:**
- [ ] StorageManager.loadSessions() handles all error cases
- [ ] StatisticsManager.getSessions() caching works correctly
- [ ] Dashboard refreshes when new sessions are saved

---

## Implementation Notes

**File Locations:**
- Sessions JSON: `~/Library/Application Support/PomodoMore/sessions.json`
- Settings JSON: `~/Library/Application Support/PomodoMore/settings.json`

**Debug Logging:**
- Enable: Set `isDebug = true` at top of files
- Disable: Set `isDebug = false` before release

**Key Code Paths:**
```
TimerViewModel.complete() → storageManager.saveSessions()
StatisticsManager.getSessions() → storageManager.loadSessions()
DashboardView → statistics.todaySessions / weekSessions
```

---

## Testing Strategy

**Unit Testing:**
- Not required today (focus on integration testing)
- Manual testing covers all code paths

**Manual Testing Approach:**
1. **Session Saving:**
   - Complete Pomodoro → Check sessions.json
   - Complete another → Check file grows

2. **Dashboard Loading:**
   - Open Dashboard → Check Today cards
   - Complete session → Dashboard updates on reopen

3. **Edge Cases:**
   - No file → Shows zeros
   - Corrupted file → No crash
   - Many sessions → Performance OK

---

## Execution (Fill During Day)

**Start:** January 6, 2026

**Progress Updates:**

-

**Actual Time:**

**Tasks:**
- [ ] Task 1: Build Verification
- [ ] Task 2: Session Storage Flow Test
- [ ] Task 3: Dashboard Data Display Test
- [ ] Task 4: Edge Case Testing
- [ ] Task 5: Code Review + Fixes

**Quality Checklist:**
- [ ] Build: 0 errors, 0 warnings
- [ ] All manual tests passed
- [ ] Edge cases handled gracefully

**Blockers/Notes:**

---

**Status:** ⏳ PENDING
**Next:** Day 2 - Statistics Aggregation Validation
