# Day 2 Plan - Statistics Aggregation Validation

**Date:** January 7, 2026
**Week:** Week 4
**Goal:** Validate statistics aggregation + edge case testing
**Time Estimate:** ~6-7 hours (full day available)

---

## Definition of Done

Day complete when:
- [ ] Build: 0 errors, 0 warnings
- [ ] Today/Week/Month statistics calculate correctly from sessions
- [ ] Session count, minutes, and streak calculations verified
- [ ] Edge cases: date boundaries, timezone handling, empty data
- [ ] Week chart displays correct data (7 days, accurate values)
- [ ] Tag-based filtering works (if implemented)
- [ ] All issues found are documented with tickets

---

## Tasks

### Task 1: Build Verification
**Estimate:** 5 minutes

**What:** Verify project builds cleanly

**Acceptance:**
- [ ] ⌘+B → 0 errors, 0 warnings
- [ ] No SwiftUI preview errors

---

### Task 2: Statistics Aggregation Logic Review
**Estimate:** 60 minutes

**What:** Review StatisticsManager.swift aggregation logic

**Acceptance:**
- [ ] getTodaySessions() returns only sessions from today
- [ ] getWeekSessions() returns sessions within current week (Mon-Sun)
- [ ] calculateTotalMinutes() sums duration correctly
- [ ] calculateStreak() counts consecutive days with sessions
- [ ] calculateAverageSessionsPerDay() handles partial weeks

**Code Review Checklist:**
- [ ] No date calculation bugs (week starting Monday)
- [ ] Timezone-safe date comparisons
- [ ] Duration calculation uses correct units (minutes)
- [ ] Streak calculation handles gaps correctly

**Manual Test Steps:**
1. Complete sessions at different times today
2. Check Today stats update correctly
3. Complete sessions on previous days
4. Check Week stats include all (not just today)

---

### Task 3: Week Chart Data Validation
**Estimate:** 60 minutes

**What:** Verify week chart displays correct 7-day data

**Acceptance:**
- [ ] Chart shows 7 bars (Mon-Sun or Sun-Sat based on locale)
- [ ] Each bar height corresponds to session count
- [ ] Today shows partial data (current day incomplete)
- [ ] Past days show complete data
- [ ] Future days show 0 sessions (no negative or wrong data)

**Manual Test Steps:**
1. Complete 2-3 sessions today
2. Open Dashboard → Week chart
3. Verify today's bar shows 2-3 sessions
4. Verify other days show correct counts
5. Check no bars show negative or inflated values

---

### Task 4: Edge Case Testing - Date Boundaries
**Estimate:** 60 minutes

**What:** Test date boundary conditions

**Acceptance:**
- [ ] Sessions at 11:59 PM count for correct day
- [ ] Sessions at 12:00 AM count for correct day
- [ ] Week boundary: Sunday→Monday transition works
- [ ] Month boundary: Last day of month sessions count correctly
- [ ] Year boundary: Dec 31 → Jan 1 works

**Manual Test Steps:**
1. Simulate sessions at day boundaries (manual data entry if needed)
2. Check Dashboard shows correct day totals
3. Navigate to previous/next week
4. Verify sessions appear in correct week

---

### Task 5: Edge Case Testing - Data Scenarios
**Estimate:** 60 minutes

**What:** Test various data scenarios

**Acceptance:**
- [ ] Single session: Today shows 1, Week shows 1
- [ ] Many sessions in one day: No performance issues
- [ ] Sessions with different sessionTypes (Pomodoro, Short Break, Long Break)
- [ ] Sessions with different tags (Work, Study, etc.)
- [ ] Long duration sessions (>25 min) handled correctly

**Manual Test Steps:**
1. Complete 10+ sessions in one day → Check performance
2. Complete mix of Pomodoro + breaks → Check counts
3. Change tags between sessions → Check filtering
4. Complete extended session (>25 min) → Check duration

---

### Task 6: Streak Calculation Validation
**Estimate:** 45 minutes

**What:** Verify streak calculation is accurate

**Acceptance:**
- [ ] No sessions → streak shows 0
- [ ] One session today → streak = 1
- [ ] Sessions yesterday but not today → streak = previous count
- [ ] Missed yesterday, sessions today → streak = 1
- [ ] 7 consecutive days → streak = 7

**Manual Test Steps:**
1. Clear all sessions → Check streak = 0
2. Complete 1 session → Check streak = 1
3. Manually add sessions for past 5 days → Check streak = 5 or 6
4. Skip a day → Check streak resets correctly

---

### Task 7: Summary + Issue Documentation
**Estimate:** 30 minutes

**What:** Document findings and create tickets for any issues

**Acceptance:**
- [ ] All validations passed documented
- [ ] Issues found have tickets in progress.md
- [ ] Priority assigned to each issue
- [ ] Ready for Day 3 (Data Persistence Test)

---

## Implementation Notes

**Key Code Paths:**
```
StatisticsManager.getTodaySessions() → Calendar.isDateInToday()
StatisticsManager.getWeekSessions() → Calendar.dateComponents(.weekOfYear)
StatisticsManager.calculateStreak() → Compare consecutive dates
DashboardView → statistics.todaySessions / .weekMinutes / .currentStreak
```

**Debug Tips:**
- Add print statements in StatisticsManager to see calculations
- Use Xcode debugger to step through aggregation logic
- Check Console.app for debug logs

---

## Testing Strategy

**Validation Approach:**
1. **Logic Review:** Read through StatisticsManager code
2. **Manual Testing:** Complete sessions, observe Dashboard
3. **Edge Cases:** Boundary dates, missing data, overflow
4. **Cross-Verify:** Calculate expected values manually vs app display

**Expected Values (Manual Calculation):**
- Today Sessions: Count of sessions where completionTime.date == today
- Week Sessions: Count where completionTime.week == current.week
- Total Minutes: Sum of durationMinutes for filtered sessions
- Streak: Count of consecutive days with ≥1 session

---

## Execution (Fill During Day)

**Start:** January 7, 2026

**Progress Updates:**

-

**Actual Time:**

**Tasks:**
- [ ] Task 1: Build Verification
- [ ] Task 2: Statistics Aggregation Logic Review
- [ ] Task 3: Week Chart Data Validation
- [ ] Task 4: Edge Case Testing - Date Boundaries
- [ ] Task 5: Edge Case Testing - Data Scenarios
- [ ] Task 6: Streak Calculation Validation
- [ ] Task 7: Summary + Issue Documentation

**Quality Checklist:**
- [ ] Build: 0 errors, 0 warnings
- [ ] All statistics calculations verified
- [ ] Edge cases documented
- [ ] No critical issues found

**Blockers/Notes:**

---

**Status:** ⏳ PENDING
**Next:** Day 3 - Data Persistence Test
