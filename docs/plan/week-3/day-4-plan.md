# Day 4 Plan

**Week:** Week 3
**Day:** Thursday
**Goal:** Integrate macOS notifications and connect sounds to timer

---

## Definition of Done

- [ ] NotificationManager implemented with permission handling
- [ ] TimerViewModel sends notifications on session completion
- [ ] Tick sound plays every second during Pomodoro (when enabled)
- [ ] Ambient sound loops during Pomodoro (when selected)
- [ ] Tick and ambient stop on pause/break
- [ ] Build: 0 errors, 0 warnings
- [ ] All features work together without conflicts

---

## Tasks

### Task 1: Create NotificationManager.swift

**What:** Create notification service for macOS user notifications

**Why:** Need to notify users when timer completes

**Acceptance:**
- NotificationManager.swift created
- Requests permission on first launch
- Shows notification on Pomodoro completion with session count
- Shows notification on Break completion
- Returns success/failure status

**Files:**
- Create `Services/NotificationManager.swift`

**Implementation Notes:**
- Use UserNotifications framework
- Request authorization with `.alert`, `.sound`, `.badge`
- Create centered notifications for macOS
- Notification title: "Pomodoro Complete!" or "Break Complete!"
- Notification body: "Time for a 5-minute break. (3 of 4 complete)"

---

### Task 2: Hook notifications to timer completion

**What:** Update TimerViewModel to send notifications

**Why:** Connect notification system to timer events

**Acceptance:**
- onPomodoroComplete() sends notification with session count
- onBreakComplete() sends notification
- Notifications respect settings.notificationsEnabled toggle

**Files:**
- Update `ViewModels/TimerViewModel.swift`

**Implementation Notes:**
- Check `settingsManager.settings.sound.notificationsEnabled` before sending
- Pass session count: `completedSessions + 1` of `longBreakInterval`
- Break notification includes suggestion to start next Pomodoro

---

### Task 3: Integrate tick sound with timer (looping)

**What:** Play tick sound loop during Pomodoro

**Why:** Continuous ticking loop creates steady audio backdrop for focus

**Acceptance:**
- Tick sound loops continuously during active Pomodoro (if enabled)
- Tick stops immediately when timer paused
- Tick stops when Pomodoro completes
- No tick during breaks
- Supports 7 tick sound variations (tick 1.mp3 through tick 7.mp3)

**Files:**
- Update `Services/SoundManager.swift` (looping support)
- Update `ViewModels/TimerViewModel.swift`

**Implementation Notes:**
- Tick sounds bundled at: `Resources/Sounds/ticks/tick X.mp3`
- Use AVAudioPlayer with `numberOfLoops = -1` for seamless loop
- SoundManager.startTickLoop(sound: String) / stopTickLoop()
- Check `settingsManager.settings.sound.tickSound != "None"`
- Same looping approach as ambient sounds

---

### Task 4: Integrate ambient sound with timer

**What:** Play ambient sound loop during Pomodoro

**Why:** Background audio helps focus during work sessions

**Acceptance:**
- Ambient sound starts when Pomodoro starts (if selected)
- Ambient loops continuously during Pomodoro
- Ambient stops when Pomodoro pauses or completes
- Ambient does NOT play during breaks

**Files:**
- Update `Services/SoundManager.swift` (looping support)
- Update `ViewModels/TimerViewModel.swift`

**Implementation Notes:**
- Use AVAudioPlayer with `numberOfLoops = -1` for infinite loop
- SoundManager.startAmbient(sound: String) / stopAmbient()
- Check `settingsManager.settings.sound.ambientSound != "None"`
- Handle transitions: Pomodoro → Ambient, Break → No sound

---

### Task 5: Test all integrations

**What:** Verify all features work together correctly

**Why:** Catch edge cases and conflicts

**Acceptance:**
- Full Pomodoro cycle with sounds and notifications
- Pause/resume behavior correct
- Break transitions correct
- Settings toggle behavior correct
- No audio glitches or spam

**Testing Steps:**
1. Start Pomodoro → tick plays, ambient starts (if enabled)
2. Pause → tick stops, ambient stops
3. Resume → tick and ambient resume
4. Pomodoro complete → notification shows, sounds stop
5. Break complete → notification shows
6. Repeat for full cycle (4 Pomodoros + 1 long break)
7. Toggle sounds off in settings → verify no sounds play
8. Toggle notifications off → verify no notifications

---

## Implementation Notes

### NotificationManager Architecture:
```swift
class NotificationManager {
    static let shared = NotificationManager()

    func requestPermission() async -> Bool
    func showPomodoroComplete(sessionsCompleted: Int, totalInSet: Int) async
    func showBreakComplete() async
}
```

### Timer Integration Points:
```swift
TimerViewModel:
  - onStart():
    - if Pomodoro: SoundManager.startTickLoop(soundName) if enabled
    - if Pomodoro: SoundManager.startAmbient(soundName) if selected
  - onPause():
    - SoundManager.stopTickLoop()
    - SoundManager.stopAmbient()
  - onPomodoroComplete():
    - SoundManager.stopTickLoop()
    - SoundManager.stopAmbient()
    - NotificationManager.showPomodoroComplete(...)
  - onBreakComplete():
    - NotificationManager.showBreakComplete()
```

### Tick Sounds Location:
```
pomodomore/Resources/Sounds/ticks/
  - tick 1.mp3
  - tick 2.mp3
  - tick 3.mp3
  - tick 4.mp3
  - tick 5.mp3
  - tick 6.mp3
  - tick 7.mp3
```

### Audio Session Handling:
- Use AVAudioSession.sharedInstance().setCategory(.ambient)
- This allows sounds to mix with other apps and not prevent system sounds
- Set `.mixWithOthers` option if needed

---

## Testing Strategy

**Manual Testing:**
1. Test with all sound/notification settings ON
2. Test with all settings OFF
3. Test mixed (sounds ON, notifications OFF)
4. Test edge cases (permission denied, no sound selected)

**Build Verification:**
- `xcodebuild -project Pomodomore.xcodeproj build`
- Expected: 0 errors, 0 warnings

---

## Execution

*User fills in during the day:*

**Start Time:** ___:___

**Task 1:** ___
**Progress:** ⬜ Not started / 🔄 In progress / ✅ Complete
**Notes:**

**Task 2:** ___
**Progress:** ⬜ Not started / 🔄 In progress / ✅ Complete
**Notes:**

**Task 3:** ___
**Progress:** ⬜ Not started / 🔄 In progress / ✅ Complete
**Notes:**

**Task 4:** ___
**Progress:** ⬜ Not started / 🔄 In progress / ✅ Complete
**Notes:**

**Task 5:** ___
**Progress:** ⬜ Not started / 🔄 In progress / ✅ Complete
**Notes:**

---

**End Time:** ___:___
**Total Time:** ___
