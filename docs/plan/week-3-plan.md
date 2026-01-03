# Week 3 Plan

**Week:** Week 3 (Jan 13-17, 2026)
**Goal:** Dashboard + Essential Settings and Sound System

---

## Context

Week 1-2 delivered a fully functional Pomodoro timer with session cycles, breaks, and tagging. Week 3 builds the Dashboard + Settings window with sidebar navigation, integrating statistics dashboard and essential settings (General, Pomodoro, Sound). This creates a unified hub for viewing progress and configuring the app.

**Available:** ~40 hours this week (8h/day)
**Week 1-2 Velocity:** Tasks completed in ~20% of estimated time
**Adjusted Estimate:** ~8-10 hours actual work expected

---

## Daily Breakdown

### DAY 1 (Monday) - Dashboard + Settings Window Foundation

**Hours:** ~8 (estimated ~2-3 actual based on velocity)
**Goal:** Create Dashboard + Settings window with sidebar navigation

**Deliverables:**
- Create Settings model (`Settings.swift`) with all properties
  - General: startOnLogin
  - Pomodoro: durations (pomodoro, short/long break, interval), autoStartNextSession
  - Sound: notificationsEnabled, tickSound, ambientSound
- Create `DashboardSettingsView.swift` as main window (720×520px)
  - Sidebar navigation (160px): Dashboard, General, Pomodoro, Sound, Appearance
  - Content area (560px): Shows selected section
  - Sidebar with icons (📊 Dashboard, ⚙️ Settings header)
  - Active state with arrow indicator (◀) and background highlight
- Create Dashboard view
  - Today section: 3 horizontal cards (Sessions, Minutes, Streak)
  - This Week section: Bar chart placeholder (full implementation Week 5)
  - Week navigation buttons (prev/next)
- Create General settings view (flat layout)
  - Startup section: "Start on login" toggle
  - About section: App name, version, description, links
- Create Pomodoro settings view (flat layout)
  - Session Durations: steppers for all durations
  - Auto-Start toggle
- Create Sound settings view (flat layout)
  - Notifications toggle
  - Tick sound dropdown (placeholder)
  - Ambient sound dropdown (placeholder)
- Add Settings menu item in menubar
- Test: Window opens, sidebar navigation works, all sections display

**Files:**
- Create `Models/Settings.swift` (new file)
- Create `Views/DashboardSettingsView.swift` (new file)
- Create `Views/DashboardView.swift` (new file)
- Create `Views/GeneralSettingsView.swift` (new file)
- Create `Views/PomodoroSettingsView.swift` (new file)
- Create `Views/SoundSettingsView.swift` (new file)
- Create `Services/SettingsManager.swift` (singleton for settings access)
- Update `AppDelegate.swift` (add Settings menu item)

**Testing:**
- Build clean (0 errors, 0 warnings)
- Settings menu item opens Dashboard + Settings window
- Sidebar navigation switches between sections
- Dashboard shows Today cards (hardcoded data for now)
- General settings displays startup toggle and about info
- Pomodoro settings shows duration steppers
- Sound settings shows toggles and dropdowns
- Settings auto-save (no Save/Cancel buttons needed)

**UI Specifications:**
```
╔═══════════════════════════════════════════════════════════════════╗
║  PomodoMore                                                [X]    ║
╠════════════════╦══════════════════════════════════════════════════╣
║                ║                                                  ║
║  📊 Dashboard ◀║  Dashboard / Settings Content                    ║
║                ║                                                  ║
║  ────────────  ║  (Content area shows selected section)          ║
║                ║                                                  ║
║  ⚙️ Settings    ║                                                  ║
║                ║                                                  ║
║  General       ║                                                  ║
║  Pomodoro      ║                                                  ║
║  Sound         ║                                                  ║
║  Appearance    ║  (Appearance greyed out - Week 4)               ║
║                ║                                                  ║
║                ║                                                  ║
╚════════════════╩══════════════════════════════════════════════════╝

Dimensions: 720 × 520 pixels
Sidebar: 160px wide
Content: 560px wide
Modal window
```

**Implementation Notes:**
- Use SwiftUI `NavigationSplitView` or custom HStack for sidebar
- Sidebar items with @State for selection
- Each section is a separate View
- Today cards: HStack with 3 cards (170px × 80px each)
- Chart: Simple bar view placeholder (full implementation Week 5)
- Flat layout: No section boxes, just headers and spacing
- Settings auto-save (no buttons, changes persist immediately)

---

### DAY 2 (Tuesday) - Settings Persistence + Dashboard Data

**Hours:** ~8 (estimated ~2 actual based on velocity)
**Goal:** Implement settings save/load and connect Dashboard to real data

**Deliverables:**
- Create `StorageManager.swift` for JSON file operations
  - Save settings to `~/Library/Application Support/PomodoMore/settings.json`
  - Load settings on app launch
  - Create directory if it doesn't exist
- Make `Settings` model Codable
- SettingsManager loads settings on app init
- Settings auto-save when settings change (debounced)
- Apply loaded settings to ConfigManager on app launch
- Connect Dashboard to real session data
  - Today: Count sessions from today's date
  - Calculate focus minutes from session data
  - Calculate streak (consecutive days with sessions)
  - Week chart: Display actual session counts per day
- Create `StatisticsManager.swift` to aggregate session data
- Test: Settings persist across app restarts
- Test: Dashboard displays real data

**Files:**
- Create `Services/StorageManager.swift` (new file)
- Create `Services/StatisticsManager.swift` (new file)
- Update `Models/Settings.swift` (add Codable conformance)
- Update `Services/SettingsManager.swift` (add save/load methods)
- Update `Views/DashboardView.swift` (connect to real data)
- Update `PomodoMoreApp.swift` (load settings on launch)
- Update `Services/ConfigManager.swift` (add updateFromSettings method)

**Testing:**
- Build clean (0 errors, 0 warnings)
- Settings auto-save after 500ms debounce when changed
- Change settings → Quit app → Relaunch → Settings restored
- JSON file created at correct location with correct structure
- Invalid JSON file handled gracefully (fall back to defaults)
- Missing settings file handled (create with defaults)
- ConfigManager reflects loaded settings
- Timer uses custom durations correctly
- Dashboard shows real session counts
- Dashboard calculates streak correctly
- Week navigation updates chart data

**settings.json Structure:**
```json
{
  "version": "1.0",

  "general": {
    "startOnLogin": false
  },

  "pomodoro": {
    "pomodoroDuration": 1500,
    "shortBreakDuration": 300,
    "longBreakDuration": 900,
    "longBreakInterval": 4,
    "autoStartNextSession": false
  },

  "sound": {
    "notificationsEnabled": true,
    "tickSound": "None",
    "ambientSound": "None"
  },

  "appearance": {
    "lightTheme": "Nord Light",
    "darkTheme": "Nord Dark",
    "font": "SF Mono",
    "showTimerInMenubar": true
  },

  "session": {
    "lastSelectedTag": "Work"
  }
}
```

---

### DAY 3 (Wednesday) - Sound System Foundation

**Hours:** ~8 (estimated ~1.5-2 actual based on velocity)
**Goal:** Implement sound playback system with AVFoundation

**Deliverables:**
- Create `SoundManager.swift` singleton service
  - AVFoundation integration (AVAudioPlayer)
  - Play system sounds (NSSound or custom audio files)
  - Sound loading and caching
- Define sound types enum (tick, ambient)
- Implement tick sound dropdown options in Sound settings
  - None, Tick 1, Tick 2, Tick 3, Glass, Tink, Pop
- Implement ambient sound dropdown options in Sound settings
  - None, White Noise, Rain, Cafe, Forest, Ocean
- Test: Can play sounds on demand
- Hook dropdowns to settings model

**Files:**
- Create `Services/SoundManager.swift` (new file)
- Create `Models/SoundType.swift` (enum for sound categories)
- Update `Views/SoundSettingsView.swift` (add functional dropdowns)
- Add `Resources/Sounds/` (sound files or use system sounds)

**Testing:**
- Build clean (0 errors, 0 warnings)
- SoundManager initializes without errors
- Can play system sound successfully
- Tick sound dropdown shows options
- Ambient sound dropdown shows options
- Selecting sounds updates settings model
- Multiple sounds can play sequentially
- No memory leaks from audio players

**Implementation Notes:**
- Use NSSound for system sounds (Glass, Tink, Pop, etc.)
- For custom sounds, use AVAudioPlayer with bundled .wav/.mp3 files
- Cache loaded sounds for performance
- Use @MainActor for UI thread safety
- Handle audio session properly (won't interfere with other apps)
- Use system volume (no custom volume control)

**SoundManager Architecture:**
```swift
class SoundManager {
    static let shared = SoundManager()

    func playSound(_ sound: SoundType)
    func playTick()
    func startAmbient(_ sound: AmbientSound)
    func stopAmbient()
    func stopAllSounds()
}

enum SoundType {
    case tick(String)      // "Tick 1", "Tick 2", etc.
    case ambient(String)   // "White Noise", "Rain", etc.
}

enum AmbientSound: String, Codable {
    case none
    case whiteNoise = "White Noise"
    case rain = "Rain"
    case cafe = "Cafe"
    case forest = "Forest"
    case ocean = "Ocean"
}
```

---

### DAY 4 (Thursday) - Notifications + Sound Integration

**Hours:** ~8 (estimated ~1.5-2 actual based on velocity)
**Goal:** Integrate macOS notifications and connect sounds to timer

**Deliverables:**
- Create `NotificationManager.swift` for macOS notifications
  - Request notification permission on first launch
  - Show notification on Pomodoro completion
  - Show notification on Break completion
  - Notifications include session count
- Hook tick sound to timer
  - Play tick every second during active Pomodoro (if enabled)
  - Stop tick when paused or completed
- Hook ambient sound to timer
  - Start ambient sound when Pomodoro starts (if selected)
  - Loop continuously during Pomodoro
  - Stop ambient sound during breaks
- Hook notifications to timer completion
  - Show notification when Pomodoro completes
  - Show notification when Break completes
- Update Sound settings to reflect integration
  - Test all toggles and dropdowns
- Test: Notifications permission handling
- Test: All sounds work with timer

**Files:**
- Create `Services/NotificationManager.swift` (new file)
- Update `ViewModels/TimerViewModel.swift` (add sound/notification calls)
- Update `Services/SoundManager.swift` (add tick timer and ambient looping)
- Update `Views/SoundSettingsView.swift` (verify all controls work)

**Testing:**
- Build clean (0 errors, 0 warnings)
- Pomodoro completion shows notification
- Break completion shows notification
- Notifications respect toggle in settings
- Tick sound plays during active Pomodoro when enabled
- Tick sound stops when paused or timer completes
- Ambient sound plays during Pomodoro when selected
- Ambient sound stops during breaks
- No sound/notification spam (only on completion)
- Permission denied handled gracefully

**Notification Content:**
```
Pomodoro Complete!
Time for a 5-minute break. (3 of 4 complete)

Break Complete!
Ready to start another Pomodoro?
```

---

### DAY 5 (Friday) - Integration Testing + Polish

**Hours:** ~8 (estimated ~2-3 actual based on velocity)
**Goal:** Complete integration testing, polish, and documentation

**Deliverables:**
- Implement "Start on login" functionality
  - Add to macOS login items when toggled on
  - Remove from login items when toggled off
  - Persist setting in settings.json
- Full integration testing:
  - Complete Pomodoro cycle with all features
  - Dashboard updates in real-time
  - Settings changes apply immediately
  - Test with sounds/notifications enabled and disabled
  - Test notification permissions (allowed/denied)
  - Test streak calculation edge cases
- Polish UI:
  - Ensure spacing matches mockups
  - Verify colors and fonts
  - Test sidebar hover states
  - Verify settings auto-save behavior
- Create Week 3 summary document
- Build: 0 errors, 0 warnings
- All tests passing

**Files:**
- Update `Views/GeneralSettingsView.swift` (implement login items)
- Create `Services/LoginItemsManager.swift` (helper for login items)
- All existing files (polish and bug fixes)
- Create `docs/plan/week-3/summary.md`

**Testing Strategy:**
- Run full Pomodoro cycle with all features enabled:
  - Custom timer durations (use test durations: 10s Pomodoro, 5s Break)
  - Notifications on each transition
  - Tick sound during Pomodoro
  - Ambient sound during Pomodoro (stops on break)
  - Dashboard updates after each session
  - Streak increments correctly
- Test settings persistence:
  - Change all settings → Quit → Relaunch → Verify all restored
  - Verify ConfigManager updates when settings change
  - Verify timer uses new durations after save
- Test edge cases:
  - Notification permission denied → Graceful handling
  - Sound files missing → No crash, log warning
  - Pause timer → Tick and ambient sounds stop
  - Window closed → Settings saved, Dashboard accessible
  - No sessions today → Dashboard shows 0 correctly
  - Long streak → Streak displays correctly
- Build verification: 0 errors, 0 warnings
- Test on macOS 12.0+ (minimum requirement)

**Success Criteria:**
- Dashboard + Settings window fully functional
- All 4 sections working (Dashboard, General, Pomodoro, Sound)
- Sidebar navigation smooth
- Dashboard shows real data (today + week)
- Settings persist across restarts
- All sounds play at appropriate times
- Notifications work correctly
- Start on login works
- No crashes or audio glitches
- Clean build with 0 warnings
- Week 3 summary created

---

## Total: ~40 hours estimated, ~8-10 hours actual expected

---

## Success Metrics

By Friday EOD:
- [ ] Dashboard + Settings window implemented (720×520px, sidebar navigation)
- [ ] Dashboard view with Today cards and This Week chart
- [ ] General settings (startup, about)
- [ ] Pomodoro settings (durations, auto-start)
- [ ] Sound settings (notifications, tick, ambient)
- [ ] Settings persist to settings.json and load on app launch
- [ ] Sound system working (tick sound, ambient sound)
- [ ] macOS notifications on timer completion
- [ ] Start on login functionality
- [ ] Dashboard displays real session data
- [ ] All settings apply immediately when saved
- [ ] Build: 0 errors, 0 warnings
- [ ] No crashes during operation
- [ ] Week 3 summary created

---

## Out of Scope (Week 4+)

**Week 4 Focus:**
- Appearance settings section implementation
- Theme system (Nord, Monokai, Dracula, light/dark)
- Font selection (SF Mono, Menlo, Monaco)
- Show timer in menubar toggle
- Theme/font persistence and application

**Week 5 Focus:**
- Full statistics implementation (detailed charts)
- Session data persistence (sessions.json)
- Session tracking improvements
- Weekly/monthly views
- MVP completion

---

## Architecture Notes

### Settings Model (Complete)
```swift
struct Settings: Codable {
    var version: String = "1.0"

    // General
    var general: GeneralSettings

    // Pomodoro
    var pomodoro: PomodoroSettings

    // Sound
    var sound: SoundSettings

    // Appearance (Week 4)
    var appearance: AppearanceSettings

    // Session (internal)
    var session: SessionSettings
}

struct GeneralSettings: Codable {
    var startOnLogin: Bool = false
}

struct PomodoroSettings: Codable {
    var pomodoroDuration: Int = 1500        // 25 min
    var shortBreakDuration: Int = 300       // 5 min
    var longBreakDuration: Int = 900        // 15 min
    var longBreakInterval: Int = 4          // sessions
    var autoStartNextSession: Bool = false
}

struct SoundSettings: Codable {
    var notificationsEnabled: Bool = true
    var tickSound: String = "None"
    var ambientSound: String = "None"
}

struct AppearanceSettings: Codable {
    var lightTheme: String = "Nord Light"
    var darkTheme: String = "Nord Dark"
    var font: String = "SF Mono"
    var showTimerInMenubar: Bool = true
}

struct SessionSettings: Codable {
    var lastSelectedTag: String = "Work"
}
```

### Window Structure
```
DashboardSettingsView (720×520)
├── Sidebar (160px)
│   ├── Dashboard section
│   ├── Separator
│   └── Settings sections
│       ├── General
│       ├── Pomodoro
│       ├── Sound
│       └── Appearance (Week 4)
└── Content Area (560px)
    ├── DashboardView (when Dashboard selected)
    ├── GeneralSettingsView (when General selected)
    ├── PomodoroSettingsView (when Pomodoro selected)
    ├── SoundSettingsView (when Sound selected)
    └── AppearanceSettingsView (Week 4)
```

### Storage Location
```
~/Library/Application Support/PomodoMore/
  ├── settings.json
  └── sessions.json (existing from Week 2)
```

### Sound Integration Points
```
TimerViewModel:
  - onStart() → SoundManager.startTick() if enabled
             → SoundManager.startAmbient() if selected
  - onPause() → SoundManager.stopTick()
             → SoundManager.stopAmbient()
  - onComplete() → SoundManager.stopTick()
                → SoundManager.stopAmbient()
                → NotificationManager.send(...)
```

### Dashboard Data Flow
```
StatisticsManager:
  - Reads sessions from sessions.json
  - Aggregates data:
    - Today: Filter by current date
    - This Week: Filter by week range
    - Streak: Count consecutive days
  - Provides computed properties:
    - todaySessions: Int
    - todayMinutes: Int
    - currentStreak: Int
    - weekSessions: [Int] (7 days)
```

---

## Testing Strategy

**Daily Testing:**
- Manual testing after each feature implementation
- Build verification (0 errors, 0 warnings)
- Feature isolation testing (one feature at a time)

**End-to-End Testing (Day 5):**
- Full cycle with custom settings
- Settings persistence verification
- Dashboard data accuracy
- All sounds and notifications working together
- Edge cases:
  - Settings corruption → Fallback to defaults
  - Notification permission denied → No crash
  - Sound files missing → Graceful degradation
  - No session data → Dashboard shows zeros
  - Rapid sidebar switching → No UI glitches
  - Rapid timer start/stop → No audio glitches

---

## Risks & Mitigations

| Risk | Mitigation |
|------|-----------|
| Dashboard + Settings too complex for Day 1 | Focus on basic structure first, polish later |
| AVFoundation audio session conflicts | Use proper audio session category (ambient), test with other apps |
| Notification permission denied by user | Check permission status, show helpful message in settings |
| Settings file corruption | Validate JSON on load, fall back to defaults on error |
| Ambient sound looping gaps | Use AVAudioPlayer numberOfLoops = -1 for seamless looping |
| Sound playback latency | Preload and cache sounds on SoundManager init |
| Settings not applying immediately | Reload ConfigManager and notify observers when settings change |
| Sidebar navigation state issues | Use @State and clear selection logic |
| Dashboard data calculation errors | Comprehensive unit tests for StatisticsManager |
| Login items permission on macOS | Request permission gracefully, handle denial |

---

## Dependencies

**Required macOS Frameworks:**
- AVFoundation (audio playback)
- UserNotifications (completion notifications)
- FileManager (settings persistence)
- ServiceManagement (login items - macOS 13+) or LSSharedFileList (macOS 12)

**System Requirements:**
- macOS 12.0+ (existing requirement)
- User notification permissions (request on first launch)
- Login items permission (optional feature)

---

**Created:** January 2, 2026
**Updated:** January 2, 2026
**Status:** ✅ Ready to Start
