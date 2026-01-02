# Project Plan

**Project:** PomodoMore - macOS Pomodoro Timer
**Start:** December 31, 2024
**Target Ship:** Week 6-8 (MVP by Week 4)
**Duration:** 6-8 weeks

---

## What You're Building

PomodoMore is a lightweight macOS menubar application implementing the Pomodoro Technique for time management. It lives in the system tray with customizable work/break intervals, tracks productivity statistics with weekly charts, and offers ambient sound support with 10 developer-focused themes and customizable monospace fonts. Designed for knowledge workers, students, and remote workers who want a non-intrusive, native macOS Pomodoro experience with complete privacy (local-only data storage).

---

## Timeline

- **Week 1-2:** Core timer functionality + menubar integration
- **Week 3:** Essential settings + sound system + notifications
- **Week 4:** Theme/font customization
- **Week 5:** Statistics tracking + data persistence → **MVP Ship**
- **Week 6:** Polish, bug fixes, edge cases
- **Week 7-8:** Testing, refinement → **Final Release v1.0**

---

## MVP Features (Must-Have)

- [ ] Menubar app with system tray integration (LSUIElement = YES, no dock icon)
- [ ] Timer functionality (Pomodoro 25min, Short Break 5min, Long Break 15min)
- [ ] Timer window with controls (Start/Pause/Stop/Reset based on state)
- [ ] Session tracking with visual indicators (4 circles showing progress)
- [ ] Basic settings dialog (timer durations, long break interval)
- [ ] Theme system (minimum: Nord, Monokai, Dracula themes)
- [ ] Font selection (minimum: SF Mono, Menlo, Monaco)
- [ ] Statistics window with weekly bar chart
- [ ] Local data persistence (settings.json, sessions.json)
- [ ] Session cycle logic (4 Pomodoros → Long Break, then reset)
- [ ] "Always on Top" toggle functionality
- [ ] Window position memory

---

## Success Definition

When complete:
- [ ] Build: 0 errors, 0 warnings
- [ ] All core features implemented and working
- [ ] Timer accuracy within 100ms per minute
- [ ] Settings persist across app restarts
- [ ] Statistics accurately track completed sessions
- [ ] Works on macOS 12.0+ (Monterey minimum)
- [ ] Memory footprint <50 MB
- [ ] CPU usage <1% when idle
- [ ] All 3 base themes render correctly with proper contrast
- [ ] Window position remembered correctly
- [ ] No crashes during normal operation
- [ ] System sleep/wake handled gracefully

---

## Known Risks

| Risk | Mitigation |
|------|-----------|
| Timer accuracy drift over long sessions | Use Timer.publish with strict scheduling, test 60+ min sessions |
| SwiftUI + AppKit menubar integration complexity | Research NSStatusBar early, prototype Week 1 |
| Theme system color management at scale | Define color protocol/struct early, use centralized theme manager |
| Statistics chart rendering performance | Use lightweight bar chart view, limit data range to weekly |
| System sleep/wake timer interruption | Implement NSWorkspace notifications, pause/resume logic |
| Font availability across macOS versions | Fallback to SF Mono default, validate font existence before use |
| Window positioning across multiple displays | Store position as percentage, validate on display change |
| macOS 12.0 compatibility vs newer APIs | Test on Monterey VM, avoid macOS 13+ only features |

---

## Tech Stack

- **Language:** Swift 5.5+
- **Framework:** SwiftUI + AppKit (hybrid)
- **macOS:** 12.0+ (Monterey minimum)
- **Architecture:** MVVM pattern
- **Data Storage:** JSON files (UserDefaults for simple settings, FileManager for sessions)
- **Audio:** AVFoundation for sound playback
- **Key APIs:**
  - NSStatusBar (menubar)
  - Timer.publish (countdown)
  - UserNotifications (completion alerts)
  - NSWorkspace (sleep/wake detection)
  - FileManager (data persistence)

---

## Architecture Notes

### App Structure
```
PomodoMore/
├── App/
│   ├── PomodoMoreApp.swift (main entry, LSUIElement setup)
│   └── AppDelegate.swift (menubar + lifecycle)
├── Models/
│   ├── TimerState.swift (enum: idle, running, paused, break)
│   ├── Session.swift (session data model)
│   └── Settings.swift (user preferences model)
├── ViewModels/
│   ├── TimerViewModel.swift (timer logic + state)
│   └── StatisticsViewModel.swift (session data aggregation)
├── Views/
│   ├── TimerWindow.swift (main timer display)
│   ├── SettingsView.swift (settings dialog)
│   ├── StatisticsView.swift (weekly chart)
│   └── AboutView.swift (about dialog)
├── Services/
│   ├── StorageManager.swift (JSON read/write)
│   ├── SoundManager.swift (audio playback)
│   └── ThemeManager.swift (theme switching)
└── Resources/
    ├── Themes/ (theme definitions)
    └── Sounds/ (system sound references)
```

### Data Flow
1. User action → View → ViewModel
2. ViewModel updates Model
3. ViewModel publishes changes via @Published
4. View reacts to state changes
5. StorageManager persists to disk

---

**Status:** ✅ Ready to start - Project Plan Complete
