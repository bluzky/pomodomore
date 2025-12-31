# AI Prompt: Project Setup (Solo Dev)

**Output:** `docs/plan/project-plan.md`

---

## Your Task

Help the solo developer articulate their project vision into a simple project plan.

---

## Input

The developer will describe their project:

```
I'm building [description of app/product]
Timeline: [weeks available]
Core features: [list of must-haves]
Success looks like: [how they'll know it's done]
```

---

## What to Generate

A complete `project-plan.md` with:

1. **What You're Building** (clear 2-3 sentences)
2. **Timeline** (weeks breakdown)
3. **MVP Features** (3-5 must-haves, clear list)
4. **Success Definition** (5+ specific, measurable items)
5. **Known Risks** (3+ real risks + mitigations)
6. **Tech Stack** (language, framework, tools)

---

## Generation Steps

1. If information is missing, ask clarifying questions:
   - "How many weeks do you have?"
   - "What's the deadline?"
   - "What's the minimum feature set?"

2. Organize their vision into the template sections

3. Flesh out details:
   - Break timeline into phases
   - Clarify success metrics
   - Identify real risks

4. Generate complete project-plan.md

---

## Example

**Developer says:**
```
Building MyRec - screen recording for Mac
I have 6 weeks
Core: record screen, capture audio, save MP4
Success: shipped, no crashes, good performance
Risks: audio sync issues, memory on long recordings
```

**AI generates:**
```markdown
# Project Plan

**Project:** MyRec
**Start:** Jan 1, 2025
**Target Ship:** Feb 14, 2025
**Duration:** 6 weeks

## What You're Building

MyRec is a lightweight macOS screen recording application that captures video and audio simultaneously. It enables content creators to record tutorials and presentations with professional quality output saved as MP4.

## Timeline

- **Week 1:** Project setup, architecture design, planning
- **Week 2-3:** UI implementation with controls
- **Week 4-5:** Core recording engine, audio capture, integration
- **Week 6:** Polish, testing, release

## MVP Features (Must-Have)

- [ ] Full-screen recording (H.264/MP4)
- [ ] System audio capture via OS APIs
- [ ] Microphone input with audio mixing
- [ ] Audio/video synchronization (±100ms)
- [ ] Start/Stop recording controls

## Success Definition

- [ ] MVP shipped by Feb 14
- [ ] Can record 1+ hour continuously
- [ ] Build: 0 errors, 0 warnings
- [ ] All tests passing (100%)
- [ ] No known crashes
- [ ] Performance: <5% CPU idle, <30% CPU recording

## Known Risks

| Risk | Mitigation |
|------|-----------|
| Audio/video sync drift | Test daily, profile sync performance |
| Memory bloat on long recordings | Profile weekly, optimize as needed |
| macOS permission handling | Start permission work Week 1 |
| Performance on different Mac models | Test on M1 + Intel early |

## Tech Stack

- **Language:** Swift
- **Framework:** SwiftUI
- **Video:** ScreenCaptureKit
- **Audio:** AVAudioEngine

**Status:** ✅ Ready to start
```

---

## Quality Check

Verify:
- [ ] Description is clear and compelling
- [ ] Timeline is realistic (total weeks match)
- [ ] MVP features are specific (not vague)
- [ ] Success criteria are measurable
- [ ] Risks are real, not hypothetical
- [ ] Tech stack is specified
- [ ] Ready for Week 1

---

## Tips

✅ DO:
- Ask clarifying questions if info is missing
- Make features specific ("record full screen", not "recording works")
- Make success criteria measurable (not "good" but "< 5% CPU")
- Identify real risks

❌ DON'T:
- Over-complicate it
- Add features that aren't MVP
- Make timelines too aggressive
- Include vague risks

---

## Files to Reference

- **Template:** solo/01-project-setup/template.md
