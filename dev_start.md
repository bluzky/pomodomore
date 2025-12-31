
# Solo Dev + AI Methodology

**For:** Single developer building with AI help
**Complexity:** Minimal (no team meetings, no PM sign-offs)
**AI Role:** Your coding partner throughout the day

---

## Overview

You have 4 simple workflows:

| # | Workflow | When | Time | Output |
|---|----------|------|------|--------|
| 1 | **Project Setup** | Once (Week 0) | 1-2 hours | project-plan.md |
| 2 | **Weekly Plan** | Monday | 30 min | week-X-plan.md |
| 3 | **Daily + Execution** | Every morning | 10 min + all day | day-Y-plan.md + progress |
| 4 | **Weekly Review** | Friday evening | 30 min | summary.md |

---

## Quick Start: Your First Week

### Monday 9 AM (30 min)
1. Read: [solo/02-weekly-planning/README.md](./solo/02-weekly-planning/README.md)
2. Create: `week-1-plan.md`
   - 5 days, ~8 hours/day
   - What you'll build each day
   - What "done" means for the week

### Monday 10 AM (10 min)
1. Ask AI to create `day-1-plan.md`
2. Give AI: [solo/03-daily-plan/ai-prompt.md](./solo/03-daily-plan/ai-prompt.md)
3. AI generates: Detailed tasks + acceptance criteria

### Monday 10:30 AM - Friday 5 PM
1. **Work:** Follow day plan, AI is your partner
2. **Track:** Log actual hours at end of day
3. **Verify:** You verify quality (tests pass, build clean)
4. **Next day:** Ask AI to plan tomorrow morning

### Friday 5 PM (30 min)
1. Write: What you accomplished
2. What was harder than expected
3. What to improve next week
4. Update master progress

---

## File Structure

```
solo/
├── 01-project-setup/
│   ├── README.md        ← Do this once
│   ├── template.md
│   └── ai-prompt.md
│
├── 02-weekly-plan/
│   ├── README.md        ← Do this Monday
│   ├── template.md
│   └── ai-prompt.md
│
├── 03-daily-plan/
│   ├── README.md        ← Do this every morning
│   ├── template.md
│   └── ai-prompt.md
│
└── 04-weekly-review/
    ├── README.md        ← Do this Friday
    ├── template.md
    └── ai-prompt.md

docs/plan/
├── project-plan.md      (from Workflow 1)
├── master-progress.md   (track weeks)
├── week-1-plan.md       (from Workflow 2)
├── week-1/
│   ├── progress.md      (day-by-day log)
│   ├── day-1-plan.md
│   ├── day-2-plan.md
│   └── ...
└── week-2/
    └── ... (same)
```

---

## Core Files

Choose where to start:

### Week 0: Project Setup (Do Once)
→ [solo/01-project-setup/](./solo/01-project-setup/README.md)

Create a simple project plan defining:
- What you're building
- Timeline (weeks)
- Success definition
- Key risks

**No AI needed.** You decide the vision.

---

### Monday: Weekly Plan (Every Week)
→ [solo/02-weekly-plan/](./solo/02-weekly-plan/README.md)

Break week into 5 daily goals:
- What gets built each day
- Realistic time per day
- What you'll test

**You can ask AI to help** or do it yourself.

---

### Every Morning: Daily Plan (5-10 min)
→ [solo/03-daily-plan/](./solo/03-daily-plan/README.md)

Create today's detailed plan:
- 3-4 specific tasks
- Acceptance criteria (specific, testable)
- Time estimate

**Ask AI to generate this** using the ai-prompt.

---

### Anytime: Work + Track
During the day:
- Follow the plan
- Work with AI (pair programming)
- Log hours at 5 PM
- Verify quality (tests pass, build clean)

---

### Friday: Weekly Review (30 min)
→ [solo/04-weekly-review/](./solo/04-weekly-review/README.md)

Write down:
- What got done vs planned
- What was harder/easier
- Improvements for next week
- Velocity metrics

**Solo reflection, no meetings.**

---

## How AI Helps (Throughout Day)

### Morning (9-10 AM)
```
You: "Create my day plan for [goal]"
AI: Reads day-plan-prompt.md
AI: Generates 3-4 specific tasks with acceptance criteria
You: Review, adjust, approve
```

### During Day (10 AM - 5 PM)
```
You: "I'm stuck on [problem]"
AI: Helps debug, suggests approach
You: Code, test, verify
AI: Reviews code if needed
```

### End of Day (5 PM)
```
You: Update progress.md manually
(Takes 5 minutes)
```

### Friday (5 PM)
```
You: Can ask AI to help draft summary
AI: Analyzes week metrics, suggests improvements
You: Write final summary
```

---

## What's Different from Team Version

❌ **No team meetings** — You decide scope
❌ **No PM sign-off** — You verify quality
❌ **No standup** — Just you and AI
✅ **Shorter templates** — Remove team sections
✅ **AI as partner** — Not gatekeeper
✅ **Focus on velocity** — Personal metrics
✅ **Faster feedback** — Instant with AI

---

## Your Daily Rhythm

```
9:00 AM  ← Ask AI to plan day
9:15 AM  ← Review plan, start work
9:30 AM  ← Begin implementation
         ← Work with AI as needed
5:00 PM  ← Complete day, log hours
5:15 PM  ← Next morning prep (AI help)
```

**That's it.** No meetings, no sign-offs, just build.

---

## Key Files to Use with AI

When you need AI help:

| What You Need | File | How to Use |
|---------------|------|-----------|
| Weekly plan | solo/02-weekly-plan/ai-prompt.md | Ask AI to generate |
| Daily plan | solo/03-daily-plan/ai-prompt.md | Ask AI to generate |
| Code help | Day plan + context | Ask directly |
| Weekly review | solo/04-weekly-review/ai-prompt.md | Ask AI to help draft |

---

## Simplifications vs Team Version

| Team Version | Solo Version |
|--------------|-------------|
| 5 workflows | 4 workflows |
| PM sign-off | Self-verification |
| Team retrospective | Solo reflection |
| Detailed templates | Short templates |
| Weekly team meeting | 30-min solo plan |
| Complex daily tracking | Simple log |

---

## Getting Started Now

### Step 1: This Week (Project Setup)
```
30 min: Read solo/01-project-setup/README.md
30 min: Create docs/plan/project-plan.md
Done!
```

### Step 2: Next Monday (Weekly Plan)
```
30 min: Read solo/02-weekly-plan/README.md
20 min: Create docs/plan/week-1-plan.md (or ask AI)
10 min: Prepare day-1 plan
Start coding!
```

### Step 3: Every Day (Daily Work)
```
10 min: Ask AI to create day-Y-plan.md
All day: Work + use AI as partner
5 min:  Log actual hours
```

### Step 4: Every Friday (Review)
```
30 min: Write week summary
Review: What went well/hard/better
Plan: Next week improvements
```

---

## Metrics You Track (Solo Dev)

**Weekly:**
- Estimated vs actual hours (velocity)
- What you accomplished vs planned
- Build quality (errors/warnings)
- Test coverage

**Over Time:**
- Is velocity stable?
- Are estimates improving?
- Are tasks getting done faster?
- Is quality improving?

---

## Success Looks Like

✅ Each week produces working code
✅ Days are independently testable
✅ Build stays clean (0 errors)
✅ Tests pass (100%)
✅ Velocity is predictable
✅ You know what's next without thinking
✅ AI is always ready to help
✅ No meetings, all execution

---

## Print This

Keep visible:
- [SOLO_QUICK_REF.md](./SOLO_QUICK_REF.md) (create this next)

---

## Next: Create Simplified Files

I'll now create:
- `solo/` directory with 4 workflows
- Simplified templates (50% smaller)
- AI prompts optimized for solo dev
- Quick reference card

Ready? Let me create the files.

---

## Questions?

**Q: Do I still need daily planning?**
A: Yes, but AI generates it in 2 minutes. Worth the structure.

**Q: Can I skip the weekly review?**
A: You can, but 30 minutes of reflection saves rework next week.

**Q: What if I work 10 hours a day?**
A: Adjust daily targets. Same process, just more hours.

**Q: Do I need all this documentation?**
A: No, but it helps AI help you better. Worth the overhead.

---

**Ready to build? Start with [solo/01-project-setup/](./solo/01-project-setup/README.md)**
