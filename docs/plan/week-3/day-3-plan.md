# Week 3 Day 3 Plan

**Date:** January 15, 2026
**Day:** Wednesday
**Available Hours:** 8

**Goal:** Sound System Foundation

---

## Definition of Done (Testable)

- [ ] SoundManager singleton can play system sounds
- [ ] SoundType enum defines all required sound categories
- [ ] Sounds are cached for instant playback
- [ ] Sound playback works from any thread safely
- [ ] Build succeeds with 0 errors

---

## Tasks

### Task 1: Create SoundType enum

**What:** Define sound categories for the app

**Why:** Type-safe sound selection for settings UI

**Acceptance:**
- `timerComplete` - main timer finished
- `shortBreakComplete` - break timer finished
- `longBreakComplete` - long break finished
- `tick` - timer ticking (optional)
- All cases have associated display name
- System sound file names (or bundle resources)

**File:** `Models/SoundType.swift` (new)

---

### Task 2: Create SoundManager with AVFoundation

**What:** Core sound playback service using AVFoundation

**Why:** Centralized, efficient sound handling

**Acceptance:**
- `shared` singleton
- `play(_ type: SoundType)` method
- Uses NSSound or AVAudioPlayer for playback
- Caches sound players for instant playback
- Thread-safe (MainActor or proper dispatch)
- Volume control support
- Test method to preview sounds

**File:** `Services/SoundManager.swift` (new)

---

### Task 3: Add sound preview to SoundSettingsView

**What:** UI for testing sounds in settings

**Why:** Users can hear sounds before selecting

**Acceptance:**
- Play button next to each sound option
- Visual feedback during playback
- Current selection clearly marked

**File:** `Views/Dashboard/SoundSettingsView.swift` (update)

---

## Implementation Notes

### SoundType Enum
```swift
enum SoundType: String, CaseIterable, Identifiable {
    case bell
    case chime
    case digital
    case mechanical
    case wooden

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .bell: return "Bell"
        case .chime: return "Chime"
        case .digital: return "Digital"
        case .mechanical: return "Mechanical"
        case .wooden: return "Wooden"
        }
    }

    var systemSoundName: String {
        // Map to macOS system sounds
        switch self {
        case .bell: return "Blow"
        case .chime: return "Glass"
        case .digital: return "Hero"
        case .mechanical: return "Typewriter"
        case .wooden: return "Tink"
        }
    }
}
```

### SoundManager
```swift
@MainActor
class SoundManager {
    static let shared = SoundManager()

    private var soundPlayers: [SoundType: NSSound] = [:]
    private var cachedVolume: Float = 1.0

    func preloadSounds() {
        for type in SoundType.allCases {
            soundPlayers[type] = NSSound(named: type.systemSoundName)
        }
    }

    func play(_ type: SoundType) {
        let player = NSSound(named: type.systemSoundName)
        player?.volume = cachedVolume
        player?.play()
    }

    func setVolume(_ volume: Float) {
        cachedVolume = volume
    }
}
```

### Sound Sources
- **Option A:** Use built-in macOS system sounds (`/System/Library/Sounds/`)
- **Option B:** Bundle custom sounds in app resources
- **Decision:** Start with system sounds for simplicity

### System Sounds Location
```
/System/Library/Sounds/
  - Blow.aiff
  - Glass.aiff
  - Hero.aiff
  - Morse.aiff
  - Ping.aiff
  - Submarine.aiff
  - Tink.aiff
  - Typewriter.aiff
```

---

## Testing Strategy

1. **Build verification:** 0 errors, 0 warnings
2. **Sound playback:**
   - Call `SoundManager.shared.play(.bell)` → sound plays
   - All sound types play without error
   - Volume control affects output
3. **Thread safety:**
   - Call from background thread → no crashes
4. **UI integration:**
   - Preview buttons work in SoundSettingsView
   - No audio glitches during rapid clicks

---

## Execution

| Time | Activity |
|------|----------|
| 10:00 - 10:30 | Create SoundType enum |
| 10:30 - 11:30 | Create SoundManager with AVFoundation |
| 11:30 - 12:00 | Add sound preview to SoundSettingsView |
| 12:00 - 13:00 | Lunch |
| 13:00 - 14:00 | Test and fix any issues |
| 14:00 - 14:30 | Build verification |
| 14:30 - 15:00 | Commit and update progress |

---

## Notes

**Pre-existing files:**
- `Views/Dashboard/SoundSettingsView.swift` (needs preview buttons)

**Dependencies:**
- AVFoundation (built-in)
- NSSound (AppKit, available)

**Future tasks (Day 4):**
- Hook sounds to timer completion events
- UserNotifications integration
- Tick sound support

---

*Created: January 3, 2026*
