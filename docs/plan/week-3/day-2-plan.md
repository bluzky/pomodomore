# Week 3 Day 2 Plan

**Date:** January 14, 2026
**Day:** Tuesday
**Available Hours:** 8

**Goal:** Settings Persistence + Dashboard Data

---

## Definition of Done (Testable)

- [ ] Settings auto-save to `~/Library/Application Support/PomodoMore/settings.json` on change (debounced 500ms)
- [ ] Settings load from disk on app launch
- [ ] Dashboard displays real session data (today's sessions, focus minutes, streak)
- [ ] Week chart shows actual session counts per day

---

## Tasks

### Task 1: Create StorageManager.swift

**What:** Create JSON file operations service for settings persistence

**Why:** Centralized file I/O for settings.json

**Acceptance:**
- Save settings to `~/Library/Application Support/PomodoMore/settings.json`
- Load settings on demand
- Create directory if it doesn't exist
- Handle invalid JSON gracefully (return nil)
- Handle missing file gracefully (return nil)

**File:** `Services/StorageManager.swift` (new)

---

### Task 2: Make Settings model Codable

**What:** Add Codable conformance to Settings and nested structs

**Why:** Enable JSON serialization

**Acceptance:**
- `Settings` struct conforms to Codable
- All nested structs (`GeneralSettings`, `PomodoroSettings`, `SoundSettings`, `AppearanceSettings`, `SessionSettings`) conform to Codable
- CodingKeys map camelCase to JSON snake_case

**File:** `Models/Settings.swift` (update)

---

### Task 3: Update SettingsManager with save/load

**What:** Add persistence methods to SettingsManager

**Why:** Connect storage to settings state with auto-save

**Acceptance:**
- `load()` called on shared instance init
- Settings auto-save when changed (debounced 500ms)
- Settings applied to ConfigManager after load
- Graceful fallback to defaults on error

**File:** `Services/SettingsManager.swift` (update)

---

### Task 4: Create StatisticsManager.swift

**What:** Create session data aggregation service

**Why:** Provide Dashboard with real statistics

**Acceptance:**
- `todaySessions`: Count sessions from today's date
- `todayMinutes`: Sum of all pomodoro session durations
- `currentStreak`: Consecutive days with at least 1 session
- `weekSessions`: Array of 7 integers (sessions per day, Mon-Sun)
- Reads from existing `sessions.json`

**File:** `Services/StatisticsManager.swift` (new)

---

### Task 5: Connect Dashboard to real data

**What:** Replace hardcoded Dashboard values with StatisticsManager data

**Why:** Display actual user progress

**Acceptance:**
- Today cards show real session count
- Today cards show real focus minutes
- Today cards show real streak
- Week chart shows actual session bars
- Data updates when Dashboard appears

**File:** `Views/DashboardView.swift` (update)

---

### Task 6: Update PomodomoreApp.swift to load settings on launch

**What:** Initialize SettingsManager before views appear

**Why:** Settings available immediately

**Acceptance:**
- SettingsManager loads settings in `.onAppear` or init
- No race conditions with ConfigManager
- EnvironmentObject available to all views

**File:** `PomodomoreApp.swift` (update)

---

### Task 7: Update ConfigManager with updateFromSettings method

**What:** Apply loaded settings to timer configuration

**Why:** Custom durations take effect

**Acceptance:**
- `updateFromSettings(_:)` method applies all duration values
- Called after SettingsManager loads
- Timer uses new durations immediately

**File:** `Services/ConfigManager.swift` (update)

---

## Implementation Notes

### StorageManager
```swift
class StorageManager {
    static let shared = StorageManager()
    private let fileManager = FileManager.default

    var settingsURL: URL {
        let appSupport = fileManager.urls(for: .applicationSupportDirectory).first!
        let appFolder = appSupport.appendingPathComponent("PomodoMore", isDirectory: true)
        return appFolder.appendingPathComponent("settings.json")
    }

    func save(_ settings: Settings) throws
    func load() -> Settings?
    private func ensureDirectoryExists()
}
```

### StatisticsManager
```swift
class StatisticsManager {
    static let shared = StatisticsManager()

    var todaySessions: Int { ... }
    var todayMinutes: Int { ... }
    var currentStreak: Int { ... }
    var weekSessions: [Int] { ... }

    private func loadSessions() -> [Session]
    private func filterSessions(from: Date, to: Date) -> [Session]
    private func calculateStreak() -> Int
}
```

### Error Handling
- Missing settings file → return defaults
- Invalid JSON → return defaults
- Missing sessions file → return zeros for all stats
- Corrupted sessions data → return zeros, log warning

---

## Testing Strategy

1. **Build verification:** 0 errors, 0 warnings
2. **Settings persistence:**
   - Change settings → Settings auto-save (debounced 500ms)
   - Quit app → Relaunch → Settings restored
   - JSON file created at correct location
   - Invalid JSON file handled gracefully
3. **Dashboard data:**
   - Run a Pomodoro session → Dashboard shows incremented count
   - Multiple sessions → minutes calculate correctly
   - Streak calculation works (consecutive days)
   - Week chart shows correct distribution
4. **Timer integration:**
   - Custom durations applied after load
   - Timer uses loaded values

---

## Execution

| Time | Activity |
|------|----------|
| 10:00 - 10:30 | Create StorageManager.swift |
| 10:30 - 11:00 | Make Settings Codable |
| 11:00 - 11:30 | Update SettingsManager with auto-save |
| 11:30 - 12:00 | Create StatisticsManager.swift |
| 12:00 - 13:00 | Lunch |
| 13:00 - 14:00 | Connect Dashboard to real data |
| 14:00 - 14:30 | Update ConfigManager + App init |
| 14:30 - 15:00 | Test, build, commit |

---

## Notes

- **Pre-existing files:**
  - `Models/Session.swift` (existing - for StatisticsManager)
  - `Services/ConfigManager.swift` (existing - needs update method)
  - `Views/DashboardView.swift` (existing - needs real data connection)
  - `PomodomoreApp.swift` (existing - needs settings load)

- **Existing session storage:** `~/Library/Application Support/PomodoMore/sessions.json`

---

*Created: January 3, 2026*
