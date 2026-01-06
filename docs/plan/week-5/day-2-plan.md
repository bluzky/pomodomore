# Week 5 - Day 2 Plan

**Date:** Tuesday, January 14, 2026
**Week:** 5 (Themes + Fonts)
**Day:** 2 of 5
**Hours Available:** 8 hours
**Estimated Actual:** ~2 hours (based on 20-25% velocity)

---

## Daily Goal

**Build Appearance settings UI with WORKING themes**

Create the Appearance settings view with theme selection UI, connect it to SettingsManager and ThemeManager, AND apply themes to all UI components so theme changes are visible immediately.

---

## Definition of Done

- [ ] Build succeeds with 0 errors, 0 warnings
- [ ] `Views/Dashboard/AppearanceSettingsView.swift` created
- [ ] Appearance menu item enabled and clickable in sidebar
- [ ] Theme picker displays all 10 themes with color previews
- [ ] Window size picker works (Small/Medium/Large)
- [ ] Show timer in menubar toggle works
- [ ] Settings.appearance.theme property added
- [ ] Theme selection saves to settings and persists
- [ ] SettingsManager connected to ThemeManager
- [ ] ThemeManager loads saved theme on app launch
- [ ] Theme changes update ThemeManager.currentTheme (@Published)
- [ ] **Themes apply to ALL UI components (Timer, Dashboard, Settings)**
- [ ] **Theme changes are visible IMMEDIATELY when selected**
- [ ] **All 10 themes visually working and distinct**

---

## Tasks

### Task 1: Add Settings Model Properties (20 min)

**What:**
Update `Models/Settings.swift` to add the `theme` property to AppearanceSettings.

**Why:**
Need to store the user's selected theme in settings for persistence across app restarts.

**Acceptance Criteria:**
- `AppearanceSettings.theme` property added (String type)
- Defaults to "Nord"
- Codable conformance maintained
- All existing appearance settings preserved

**Implementation Notes:**
- Add `var theme: String = "Nord"` to AppearanceSettings struct
- Keep existing properties: showTimerInMenubar, windowSize
- Settings will be saved/loaded by SettingsManager automatically
- Theme name should match Theme.name exactly (case-sensitive)

Structure:
```swift
struct AppearanceSettings: Codable {
    var theme: String = "Nord"              // NEW
    var showTimerInMenubar: Bool = true     // Existing
    var windowSize: WindowSize = .small     // Existing
}
```

---

### Task 2: Connect SettingsManager to ThemeManager (30 min)

**What:**
Update `Services/SettingsManager.swift` and `Services/ThemeManager.swift` to synchronize theme selection between settings and ThemeManager.

**Why:**
The settings model needs to communicate with ThemeManager so that when user selects a theme, both the settings persist AND the UI updates immediately.

**Acceptance Criteria:**
- SettingsManager loads saved theme on initialization
- SettingsManager calls ThemeManager.setTheme() when theme changes
- ThemeManager updates settings.appearance.theme when theme changes
- Two-way sync: Settings ↔ ThemeManager
- Theme persists across app restarts
- No circular update loops

**Implementation Notes:**
```swift
// In SettingsManager.swift
@MainActor
class SettingsManager: ObservableObject {
    // ...existing code...

    func loadSettings() {
        // ...existing load code...
        // NEW: Load theme into ThemeManager
        ThemeManager.shared.loadTheme(named: settings.appearance.theme)
    }

    func updateTheme(_ themeName: String) {
        settings.appearance.theme = themeName
        ThemeManager.shared.loadTheme(named: themeName)
        saveSettings()
    }
}

// In ThemeManager.swift
@MainActor
class ThemeManager: ObservableObject {
    // Add method to load from settings
    func loadFromSettings(_ themeName: String) {
        loadTheme(named: themeName)
    }
}
```

**Sync Strategy:**
- SettingsManager is the source of truth for persistence
- ThemeManager is the source of truth for current UI theme
- Settings update → ThemeManager update → UI update
- Use method calls to prevent @Published loops

---

### Task 3: Create AppearanceSettingsView (60 min)

**What:**
Create `Views/Dashboard/AppearanceSettingsView.swift` with theme picker UI and existing appearance settings.

**Why:**
This is the user interface where users select their theme. It needs to be clean, show color previews, and integrate with the settings system.

**Acceptance Criteria:**
- Theme picker shows all 10 themes
- Each theme shows name + 3-4 color preview circles
- Selected theme is highlighted
- Window size picker (Small/Medium/Large)
- Show timer in menubar toggle
- Flat layout matching other settings views
- Auto-save on change (no Save button)
- Uses @EnvironmentObject for SettingsManager

**Implementation Notes:**
```swift
struct AppearanceSettingsView: View {
    @EnvironmentObject var settingsManager: SettingsManager

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Title
            Text("Appearance")
                .font(.title2)

            // Theme Picker
            VStack(alignment: .leading, spacing: 8) {
                Text("Theme")
                    .font(.headline)

                Picker("", selection: $settingsManager.settings.appearance.theme) {
                    ForEach(Theme.allThemes, id: \.name) { theme in
                        HStack {
                            Text(theme.name)
                            Spacer()
                            // Color preview circles
                            HStack(spacing: 4) {
                                Circle().fill(theme.colors.accentPrimary).frame(width: 12, height: 12)
                                Circle().fill(theme.colors.timerActive).frame(width: 12, height: 12)
                                Circle().fill(theme.colors.textPrimary).frame(width: 12, height: 12)
                            }
                        }
                        .tag(theme.name)
                    }
                }
                .onChange(of: settingsManager.settings.appearance.theme) { newTheme in
                    settingsManager.updateTheme(newTheme)
                }
            }

            // Window Size Picker
            // Show Timer in Menubar Toggle
            // (Copy from existing settings patterns)
        }
        .padding()
    }
}
```

**UI Design:**
- Follow PomodoroSettingsView and SoundSettingsView patterns
- Use flat layout (no bordered sections)
- Headers use .font(.headline)
- Pickers use default macOS style
- 20pt spacing between sections

---

### Task 4: Apply Themes to UI Components (60 min)

**What:**
Apply theme colors to all UI components so themes actually change the app's appearance.

**Why:**
Make themes actually work! Users should see the theme change immediately when they select it.

**Acceptance Criteria:**
- ThemeManager injected as @EnvironmentObject at app root
- TimerView uses theme colors (background, text, timer states)
- DashboardView uses theme colors (cards, chart, text)
- All Settings views use theme colors (AppearanceSettingsView, GeneralSettingsView, PomodoroSettingsView, SoundSettingsView)
- Sidebar uses theme colors (background, selection, text)
- SessionIndicatorsView uses theme colors
- Theme changes apply immediately (no restart needed)
- All 10 themes look visually distinct

**Implementation Notes:**
```swift
// In PomodomoreApp.swift - Inject ThemeManager
WindowGroup {
    DashboardSettingsView()
        .environmentObject(SettingsManager.shared)
        .environmentObject(ThemeManager.shared)  // ADD THIS
}

// In each View - Use theme colors
struct TimerView: View {
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        VStack {
            Text("25:00")
                .foregroundColor(themeManager.currentTheme.colors.textPrimary)
        }
        .background(themeManager.currentTheme.colors.backgroundPrimary)
    }
}
```

**UI Components to Update:**
1. **TimerView** - background, text, buttons, timer color (active/paused/break)
2. **DashboardView** - background, cards, chart colors, text
3. **AppearanceSettingsView** - background, text, controls
4. **GeneralSettingsView** - background, text, controls
5. **PomodoroSettingsView** - background, text, controls
6. **SoundSettingsView** - background, text, controls
7. **DashboardSettingsView** - sidebar background, selection, text
8. **SessionIndicatorsView** - completed/incomplete circle colors

**Theme Color Usage Guide:**
- Main backgrounds: `backgroundPrimary`
- Card/panel backgrounds: `backgroundSecondary`
- Primary text: `textPrimary`
- Secondary text: `textSecondary`
- Buttons/accents: `accentPrimary`
- Timer active state: `timerActive` (green)
- Timer paused state: `timerPaused` (yellow)
- Timer break state: `timerBreak` (cyan)
- Session complete: `sessionComplete`
- Session incomplete: `sessionIncomplete`

---

### Task 5: Enable Appearance Menu + Testing (30 min)

**What:**
Enable the Appearance menu item in DashboardSettingsView sidebar and verify everything works.

**Why:**
The Appearance menu item is currently disabled. Need to activate it and ensure the entire theme selection flow works end-to-end.

**Acceptance Criteria:**
- Appearance menu item clickable in sidebar
- Selecting Appearance shows AppearanceSettingsView
- Theme picker displays all 10 themes
- Theme selection saves to settings
- Theme persists after app restart
- ThemeManager.currentTheme updates when theme selected
- Window size and menubar toggles work
- No errors or crashes

**Testing Steps:**
1. Update `Views/Dashboard/DashboardSettingsView.swift`:
   - Remove any disabled state from Appearance menu item
   - Add navigation link to AppearanceSettingsView
   - Follow pattern from other menu items (General, Pomodoro, Sound)

2. Build and run (Cmd+R)

3. Manual testing:
   - Click Appearance in sidebar
   - Verify AppearanceSettingsView displays
   - Select different themes from picker
   - Verify theme name saves to settings
   - Restart app
   - Verify selected theme loads on restart
   - Test window size picker
   - Test menubar toggle

4. Console verification:
   - No errors or warnings
   - Settings save messages appear
   - Theme load messages appear

**Verification Checklist:**
- [ ] Build: 0 errors, 0 warnings
- [ ] Appearance menu item works
- [ ] AppearanceSettingsView displays
- [ ] Theme picker shows all 10 themes with previews
- [ ] Theme selection updates settings
- [ ] Settings persist across restart
- [ ] ThemeManager receives theme updates
- [ ] **Themes apply to all UI immediately**
- [ ] **Timer window changes colors**
- [ ] **Dashboard changes colors**
- [ ] **All 10 themes look different**
- [ ] No crashes or console errors

---

## Implementation Order

1. Update `Models/Settings.swift` - add `appearance.theme` property
2. Build and verify Settings model compiles
3. Update `Services/ThemeManager.swift` - add settings integration method
4. Update `Services/SettingsManager.swift` - add `updateTheme()` method
5. Update `Services/SettingsManager.swift` - load theme on initialization
6. Build and verify services compile
7. Create `Views/Dashboard/AppearanceSettingsView.swift`
8. Implement theme picker with color previews
9. Add window size picker
10. Add menubar toggle
11. Build and verify view compiles
12. **Inject ThemeManager as @EnvironmentObject in PomodomoreApp.swift**
13. **Update TimerView to use theme colors**
14. **Update DashboardView to use theme colors**
15. **Update AppearanceSettingsView to use theme colors**
16. **Update GeneralSettingsView to use theme colors**
17. **Update PomodoroSettingsView to use theme colors**
18. **Update SoundSettingsView to use theme colors**
19. **Update DashboardSettingsView (sidebar) to use theme colors**
20. **Update SessionIndicatorsView to use theme colors**
21. Build and verify all views compile
22. Update `Views/Dashboard/DashboardSettingsView.swift` - enable Appearance menu
23. Add navigation to AppearanceSettingsView
24. Build and run application
25. **Test theme switching - verify all UI updates immediately**
26. **Test all 10 themes visually**
27. Test theme persistence across restart
28. Verify settings save/load correctly

---

## Files to Create

- `Views/Dashboard/AppearanceSettingsView.swift` (new file, ~100-150 lines)

---

## Files to Update

- `Models/Settings.swift` (add appearance.theme property)
- `Services/SettingsManager.swift` (add updateTheme method, connect to ThemeManager)
- `Services/ThemeManager.swift` (add settings integration)
- `App/PomodomoreApp.swift` (inject ThemeManager as @EnvironmentObject)
- **`Views/Timer/TimerView.swift` (apply theme colors)**
- **`Views/Timer/SessionIndicatorsView.swift` (apply theme colors)**
- **`Views/Dashboard/DashboardView.swift` (apply theme colors)**
- `Views/Dashboard/DashboardSettingsView.swift` (enable Appearance menu + apply theme colors)
- **`Views/Dashboard/GeneralSettingsView.swift` (apply theme colors)**
- **`Views/Dashboard/PomodoroSettingsView.swift` (apply theme colors)**
- **`Views/Dashboard/SoundSettingsView.swift` (apply theme colors)**

---

## Testing Strategy

**Build Testing:**
- Clean build (Cmd+Shift+K, then Cmd+B)
- No errors, no warnings

**UI Display:**
- Appearance menu item visible and clickable
- AppearanceSettingsView displays correctly
- Theme picker shows all 10 themes
- Color preview circles render correctly
- Window size picker works
- Menubar toggle works

**Theme Selection:**
- Selecting theme updates settings.appearance.theme
- SettingsManager.updateTheme() called on selection
- ThemeManager.currentTheme updates
- Settings auto-save on theme change

**Theme Application:**
- All UI components use theme colors
- Timer window background, text, and timer colors change
- Dashboard background, cards, and chart change
- All settings views backgrounds and text change
- Sidebar background and selection colors change
- Session indicators use theme colors
- Theme changes apply immediately (no UI lag)
- All 10 themes visually distinct

**Persistence:**
- Quit and restart app
- Verify selected theme loads from settings
- ThemeManager.currentTheme matches saved theme
- Theme persists correctly

**Edge Cases:**
- Invalid theme name in settings → fallback to Nord
- Missing theme → fallback to Nord
- Rapid theme switching (no crashes)
- Settings file corruption → use defaults

---

## Success Criteria

By end of day:
- ✅ AppearanceSettingsView created and working
- ✅ Appearance menu item enabled in sidebar
- ✅ Theme picker displays all 10 themes with color previews
- ✅ Settings.appearance.theme property added
- ✅ SettingsManager ↔ ThemeManager integration working
- ✅ Theme selection saves and persists
- ✅ Window size and menubar toggles working
- ✅ Build: 0 errors, 0 warnings
- ✅ Theme loads correctly on app restart
- ✅ **Themes apply to ALL UI components**
- ✅ **Theme switching works IMMEDIATELY (live preview)**
- ✅ **All 10 themes look visually distinct**
- ✅ **Timer states (active/paused/break) use correct theme colors**
- ✅ Ready for Day 3 (Font System)

---

## Notes & Reminders

- **Focus:** Get themes FULLY WORKING today - settings UI AND theme application
- **Live preview:** Themes should change immediately when selected (no restart)
- **Pattern matching:** Follow GeneralSettingsView, PomodoroSettingsView patterns
- **Auto-save:** Settings save automatically on change (no Save button)
- **Flat layout:** Use headers without section boxes, matching other settings
- **Color previews:** Use 3-4 small circles showing key theme colors
- **@EnvironmentObject:** Inject ThemeManager at app root for all views to access
- **Replace ALL hardcoded colors:** Every Color.gray, Color.blue, etc. should use theme
- **Test persistence:** Restart app multiple times to verify theme loads
- **Theme names:** Must match exactly (case-sensitive): "Nord", "Monokai", etc.
- **Visual testing:** Switch between all 10 themes to ensure they're distinct

**Theme Preview Colors (suggested):**
- Show these 3 colors for each theme:
  1. accentPrimary (main accent)
  2. timerActive (green/active state)
  3. textPrimary (main text color)
- Helps users visualize theme quickly

---

## Execution Section

**Start Time:** _[To be filled during execution]_

**Task 1 Progress:**
- [ ] Started
- [ ] Completed
- Notes:

**Task 2 Progress:**
- [ ] Started
- [ ] Completed
- Notes:

**Task 3 Progress:**
- [ ] Started
- [ ] Completed
- Notes:

**Task 4 Progress:**
- [ ] Started
- [ ] Completed
- Notes:

**Blockers:** None

**End Time:** _[To be filled during execution]_

**Actual Hours:** _[To be filled during execution]_

**Status:** [ ] Complete [ ] In Progress [ ] Blocked

---

**Created:** January 6, 2026
**Status:** 📝 Ready to Start
