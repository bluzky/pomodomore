# AI Prompt: Weekly Review (Solo Dev)

**Output:** `docs/plan/week-X/summary.md`

---

## Your Task

Help the solo developer reflect on their week and draft a summary.

---

## Input

The developer provides:

```
WEEK DATA:
- Week number
- What they planned to accomplish
- What they actually did
- Hours estimated vs actual
- Any blockers
- Quality metrics (tests, build)
```

---

## What to Generate

Complete `summary.md` with:

1. **What Got Done** (completed vs incomplete)
2. **Metrics** (hours, velocity, quality)
3. **Reflections** (went well, harder, learnings)
4. **Next Week Adjustments** (based on this week)
5. **Grade** (X/5 with reasoning)

---

## Generation Steps

1. Understand what happened this week

2. Organize into clear sections:
   - Completed items (checklist)
   - Incomplete items (what moved to next week)
   - Why incomplete items weren't done

3. Calculate metrics:
   - Hours: actual vs estimated
   - Velocity: how many features/tasks completed
   - Quality: build status, test pass rate

4. Draft reflections:
   - What went well (be specific)
   - What was harder (identify patterns)
   - Key learnings (technical + process)

5. Suggest next week adjustments:
   - If faster → increase scope
   - If slower → adjust estimates
   - If blockers → address them

6. Grade the week objectively (1-5 stars)

---

## Example

**Developer says:**
```
Week 1:
Planned: Set up project, architecture, UI mockups
Actual:
- Project setup: DONE
- Architecture: DONE
- UI mockups: DONE
- Dev planning: DONE

Time: Estimated 40 hours, Actual 38 hours
No blockers
Build: 0 errors, 100% tests
Quality: Excellent
Next: Start Week 2 frontend build
```

**AI generates:**
```markdown
# Week 1 Summary

**Week:** Week 1 (Jan 6-10, 2025)
**Date:** Jan 10, 2025

---

## What Got Done

### Completed ✅
- Project requirements finalized and signed off
- High-level architecture designed (ScreenCaptureKit + AVAudioEngine)
- UI/UX mockups created (5 key screens)
- Development plan for Weeks 2-4 complete
- Team aligned on approach

### Not Completed
None - all planned work done

---

## Metrics

| Metric | Value |
|--------|-------|
| Estimated Hours | 40 |
| Actual Hours | 38 |
| Variance | -5% (2 hours ahead) |
| Velocity | 4 major deliverables |
| Quality | Build: 0 errors, Tests: 100% |
| Blockers | None |

---

## What Went Well

**Clear Requirements**
- Stakeholder meetings were productive
- No ambiguity about MVP scope
- Saved time on rework

**Good Architecture Decisions**
- ScreenCaptureKit choice validated through research
- Audio engine approach well-designed
- Team confident in technical direction

**Realistic Planning**
- Time estimates for Weeks 2-4 based on realistic scope
- Identified key risks early
- Mitigation plans in place

---

## What Was Harder

**Architecture Research**
- Took longer than expected to validate ScreenCaptureKit approach
- Required prototyping to confirm API availability
- Added ~4 hours to Day 3

**Mockup Details**
- UI designers requested more iterations than planned
- iPad vs iPhone sizing needed separate mockups
- Added ~2 hours to Day 4

---

## Key Learnings

**Technical:**
- ScreenCaptureKit has good API surface but limited docs
- Audio mixing will be the complexity point
- Prototyping decisions early saves time

**Process:**
- Detailed mockups prevent rework
- Architecture decisions should be prototype-validated
- Team alignment meetings are worth the time
- 5-day preparation week was right scope

---

## Next Week Adjustments

**Based on Week 1:**
- ✅ Velocity was good (2 hours ahead)
- ✅ Quality high (0 errors, 100% tests)
- ✅ No blockers, good decision-making

**Adjustments for Week 2:**
- Can increase scope slightly (were efficient)
- Don't add more prep work - move to building
- Same time estimates working well
- Team pacing is sustainable

---

## Overall Grade

⭐⭐⭐⭐⭐ (5/5 stars)

**Why:**
✅ All planned work completed on time
✅ Team aligned and confident
✅ Quality decisions made early
✅ No blockers or rework
✅ Ready to start building with clear direction

---

**Completed:** Jan 10, 2025
```

---

## Quality Check

Verify:
- [ ] Completed items listed specifically
- [ ] Incomplete items have reasons
- [ ] Metrics calculated accurately
- [ ] Reflections are specific (not vague)
- [ ] Learnings are actionable
- [ ] Next week adjustments make sense
- [ ] Grade is objective and reasoned

---

## Tips

✅ DO:
- Base reflections on actual data (hours, metrics)
- Be specific about what went well/hard
- Identify patterns and learnings
- Make adjustments data-driven
- Grade objectively

❌ DON'T:
- Write vague reflections ("good work")
- Ignore metrics
- Skip learnings
- Make vague improvements
- Over-complicate

---

## When Developer Says...

**"Everything went smoothly"**
→ Ask: "What specifically saved time? Can we repeat it?"

**"We were slow"**
→ Ask: "Which tasks took longer? Why? How to improve?"

**"Some work didn't get done"**
→ Ask: "Why? Underestimated? Blocker? Deprioritized?"

Make them think about root causes, not just outcomes.

---

## Files to Reference

- **Template:** solo/04-weekly-review/template.md
- **Daily plans:** docs/plan/week-X/day-Y-plan.md (all 5)
- **Progress log:** docs/plan/week-X/progress.md
