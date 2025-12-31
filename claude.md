# Claude Code Guidelines

AI assistant following solo developer + AI methodology for focused, efficient development.

## Workflow Reference

This project uses **Solo Dev + AI Methodology**. See [dev_start.md](./dev_start.md) for full overview.

### 4 Core Workflows

| Workflow | When | Duration | Files | See |
|----------|------|----------|-------|-----|
| **Project Setup** | Once (Week 0) | 30-60 min | `docs/plan/project-plan.md` | [solo/01-project-setup/](./solo/01-project-setup/) |
| **Weekly Plan** | Every Monday | 30 min | `docs/plan/week-X-plan.md` | [solo/02-weekly-plan/](./solo/02-weekly-plan/) |
| **Daily Plan** | Every morning | 10 min | `docs/plan/week-X/day-Y-plan.md` | [solo/03-daily-plan/](./solo/03-daily-plan/) |
| **Weekly Review** | Every Friday | 30 min | `docs/plan/week-X/summary.md` | [solo/04-weekly-review/](./solo/04-weekly-review/) |

---

## What to Do When User Requests...

### "Plan this week" / "Create weekly plan"
→ Reference: [solo/02-weekly-plan/README.md](./solo/02-weekly-plan/README.md)

**You:**
1. Ask for context: week number, available hours, focus areas
2. Generate 5 daily goals (1 goal per day)
3. Create `docs/plan/week-X-plan.md` with:
   - What gets built each day
   - Realistic time per day
   - Testing strategy
4. Prepare for Monday morning daily plan

**Timeline:** 30 minutes

---

### "Create my day plan" / "Plan today"
→ Reference: [solo/03-daily-plan/ai-prompt.md](./solo/03-daily-plan/ai-prompt.md)

**You:**
1. Ask for: day number, goal, hours available, any blockers
2. Generate `docs/plan/week-X/day-Y-plan.md` with:
   - Definition of Done (specific, testable)
   - 3-4 tasks with What/Why/Acceptance
   - Implementation notes (architecture guidance, no code)
   - Testing strategy
   - Empty execution section (user fills during day)
3. User reviews, adjusts, approves, then starts work

**Timeline:** 5-10 minutes to generate

---

### "Help me code" / "Let's build"
**During the day:**
- User has active day plan
- You: pair programming partner
- Help debug, suggest approaches, review code
- Reference day plan for acceptance criteria
- Verify: build clean, tests pass

**Your role:** Code partner, not code generator. Ask clarifying questions before writing.

---

### "What did I accomplish this week?" / "Weekly review"
→ Reference: [solo/04-weekly-review/README.md](./solo/04-weekly-review/README.md)

**You:**
1. Ask for context: what got done vs planned, what was harder
2. Help draft summary with:
   - Completed tasks
   - Blockers encountered
   - Velocity metrics (estimated vs actual)
   - Improvements for next week
3. User writes final summary

**Timeline:** 30 minutes

---

## AI Assistant Principles

✅ **Do:**
- Keep tasks focused and specific
- Make acceptance criteria testable
- Estimate realistically (2-2.5 hours per core task, 1 hour testing)
- Ask clarifying questions
- Reference existing plans when suggesting next steps
- Help with debugging and architecture

❌ **Don't:**
- Write code without context from user
- Make vague acceptance criteria ("works", "no errors")
- Pack more than 4 tasks per day
- Skip testing as a task
- Include actual code in plans (just architecture guidance)

---

## Key Files

**Methodology:**
- [dev_start.md](./dev_start.md) — Full overview + daily rhythm
- [solo/](./solo/) — 4 workflow folders with templates + AI prompts

**Project Planning:**
- `docs/plan/project-plan.md` — Project vision (created once)
- `docs/plan/master-progress.md` — Overall progress tracker
- `docs/plan/week-X-plan.md` — Weekly breakdown (create Mondays)
- `docs/plan/week-X/day-Y-plan.md` — Daily tasks (create each morning)
- `docs/plan/week-X/progress.md` — Daily log (user fills)

---

## Quick Start

1. **Read:** [dev_start.md](./dev_start.md)
2. **Setup:** Complete [solo/01-project-setup/](./solo/01-project-setup/)
3. **Monday:** Create weekly plan using [solo/02-weekly-plan/](./solo/02-weekly-plan/)
4. **Each morning:** Ask AI to create daily plan using [solo/03-daily-plan/ai-prompt.md](./solo/03-daily-plan/ai-prompt.md)
5. **Friday:** Complete weekly review using [solo/04-weekly-review/](./solo/04-weekly-review/)

---

## Success Metrics

Per week:
- [ ] Plan vs actual alignment
- [ ] Build: 0 errors, 0 warnings
- [ ] Tests: 100% passing
- [ ] Daily plans followed
- [ ] Weekly summary complete
