# Week 5 - Day 3 Plan

**Date:** Wednesday, January 15, 2026
**Week:** 5 (Themes + Fonts)
**Day:** 3 of 5
**Hours Available:** 8 hours
**Estimated Actual:** ~2 hours (based on 20-25% velocity)

---

## Daily Goal

**Implement font system with font selection UI and apply fonts to all UI text elements.**

---

## Definition of Done

- [ ] Build succeeds with 0 errors, 0 warnings
- [ ] `Models/AppFont.swift` created with font definitions
- [ ] `Services/FontManager.swift` created with font detection and selection
- [ ] Font picker added to AppearanceSettingsView
- [ ] Font selection saves to settings and persists
- [ ] SettingsManager connected to FontManager
- [ ] FontManager loads saved font on app launch
- [ ] Font changes update FontManager.currentFont (@Published)
- [ ] **Fonts apply to ALL UI text elements**
- [ ] **Font changes are visible IMMEDIATELY when selected**
- [ ] All fonts render correctly at all sizes
- [ ] Missing font fallback to SF Mono works

---

## Tasks

### Task 1: Create AppFont.swift Model (20 min)

**What:**
Create `Models/AppFont.swift` with supported fonts list and availability checking.

**Why:**
Define all supported fonts in one place for easy access and filtering.

**Acceptance Criteria:**
- `AppFont` struct with name, displayName, isInstalled properties
- List of 7 supported fonts (SF Mono, Menlo, Monaco, JetBrains Mono, Fira Code, Source Code Pro, IBM Plex Mono)
- Font availability checker using NSFont
- System fonts (SF Mono, Menlo, Monaco) marked as always available

**Implementation Notes:**
```swift
struct AppFont: Identifiable {
    let id: String
    let name: String           // Font family name
    let displayName: String    // Display name
    let isInstalled: Bool

    static let supportedFonts: [AppFont] = [
        AppFont(name: "SF Mono", displayName: "SF Mono", isInstalled: true),
        AppFont(name: "Menlo", displayName: "Menlo", isInstalled: true),
        // ... rest of fonts
    ]
}

struct FontAvailabilityChecker {
    static func isFontInstalled(_ fontName: String) -> Bool {
        NSFont(name: fontName, size: 12) != nil
    }
}
```

**Files:**
- Create `Models/AppFont.swift` (new file)

---

### Task 2: Create FontManager.swift Service (30 min)

**What:**
Create `Services/FontManager.swift` singleton service for font loading and selection.

**Why:**
Centralize font management and provide reactive updates to all views when font changes.

**Acceptance Criteria:**
- FontManager singleton with @Published currentFont
- Load font by name with fallback to SF Mono
- Check if font is installed before applying
- Get all available fonts (filter out uninstalled)
- Get all fonts with availability status
- Handle missing font gracefully

**Implementation Notes:**
```swift
@MainActor
class FontManager: ObservableObject {
    static let shared = FontManager()

    @Published var currentFont: String = "SF Mono"
    @Published var currentFontObject: AppFont

    private let fallbackFont = "SF Mono"

    private init() {
        currentFontObject = AppFont(name: "SF Mono", displayName: "SF Mono", isInstalled: true)
    }

    func loadFont(named fontName: String) {
        let availableFont = findAvailableFont(named: fontName) ?? fallbackFont
        currentFont = availableFont
        // Update AppFont object for UI
    }

    func getAvailableFonts() -> [AppFont] {
        FontAvailabilityChecker.getAvailableFonts()
    }

    func isFontInstalled(_ fontName: String) -> Bool {
        FontAvailabilityChecker.isFontInstalled(fontName)
    }

    private func findAvailableFont(named fontName: String) -> String? {
        let available = FontAvailabilityChecker.getAvailableFonts()
        return available.first { $0.name == fontName && $0.isInstalled }?.name
    }
}
```

**Files:**
- Create `Services/FontManager.swift` (new file)

---

### Task 3: Connect FontManager to SettingsManager (20 min)

**What:**
Update SettingsManager and Settings model to support font selection.

**Why:**
Persist font preference and load it on app startup.

**Acceptance Criteria:**
- SettingsManager loads saved font on initialization
- SettingsManager calls FontManager.loadFont() when font changes
- FontManager updates settings when font changes
- Two-way sync: Settings ↔ FontManager
- Font persists across app restarts

**Implementation Notes:**
```swift
// In SettingsManager.swift
func loadSettings() {
    // ... existing code ...
    // NEW: Load font into FontManager
    FontManager.shared.loadFont(named: settings.appearance.font)
}

func updateFont(_ fontName: String) {
    settings.appearance.font = fontName
    FontManager.shared.loadFont(named: fontName)
    // Settings will auto-save due to @Published binding
}
```

**Files:**
- Update `Services/SettingsManager.swift` (add updateFont method, call from loadSettings)
- Update `Services/FontManager.swift` (add settings integration method)

---

### Task 4: Add Font Picker to AppearanceSettingsView (40 min)

**What:**
Add font selection UI to the Appearance settings view.

**Why:**
Allow users to select their preferred monospace font from available options.

**Acceptance Criteria:**
- Font picker shows all 7 fonts
- Installed fonts are selectable
- Uninstalled fonts show "(Not Installed)" label and are disabled
- Font preview shows font name in its own font
- Selected font is highlighted
- Uses existing SettingsPickerRow pattern

**UI Design:**
```
Font
┌────────────────────────────────────────┐
│ JetBrains Mono                    ● ● ● │  ← color preview
└────────────────────────────────────────┘

SF Mono (Not Installed)             ○ ○ ○ │  ← disabled, not installed
```

**Implementation Notes:**
```swift
struct AppearanceSettingsView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var fontManager: FontManager

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Theme picker (existing)
            SettingsPickerRow(...)

            // NEW: Font picker
            SettingsPickerRow(
                label: "Font",
                selection: $settingsManager.settings.appearance.font,
                options: fontManager.getAvailableFonts(),
                optionLabel: { font in
                    HStack {
                        Text(font.displayName)
                        if !font.isInstalled {
                            Text("(Not Installed)")
                                .foregroundColor(.secondary)
                                .font(.caption)
                        }
                    }
                }
            )
            .onChange(of: settingsManager.settings.appearance.font) { _, newValue in
                settingsManager.updateFont(newValue)
            }

            // Window size picker (existing)
            SettingsToggleRow(...)
        }
    }
}
```

**Files:**
- Update `Views/Dashboard/AppearanceSettingsView.swift` (inject FontManager, add font picker)

---

### Task 5: Apply Fonts to All UI Text Elements (60 min)

**What:**
Update all views to use the custom font from FontManager.

**Why:**
Make font selection actually change the appearance of text throughout the app.

**Acceptance Criteria:**
- Timer countdown uses selected font (36-48pt)
- All buttons and labels use selected font
- All settings text uses selected font
- Dashboard stats use selected font
- Font changes apply immediately (no restart)
- All fonts render correctly at all sizes

**Implementation Strategy:**
Use a custom ViewModifier for consistent font application:

```swift
// Utilities/AppFontModifier.swift
struct AppFontModifier: ViewModifier {
    let size: CGFloat
    let weight: Font.Weight

    func body(content: Content) -> some View {
        content.font(.custom(FontManager.shared.currentFont, size: size))
            .fontWeight(weight)
    }
}

extension View {
    func appFont(size: CGFloat, weight: Font.Weight = .regular) -> some View {
        modifier(AppFontModifier(size: size, weight: weight))
    }
}
```

**Files to Update:**
1. `Views/Timer/TimerView.swift` - timer text, buttons
2. `Views/Dashboard/DashboardView.swift` - stats, labels
3. `Views/Dashboard/DashboardSettingsView.swift` - sidebar, headers
4. `Views/Dashboard/GeneralSettingsView.swift` - all text
5. `Views/Dashboard/PomodoroSettingsView.swift` - all text
6. `Views/Dashboard/SoundSettingsView.swift` - all text
7. `Views/Dashboard/AppearanceSettingsView.swift` - all text
8. `Views/Dashboard/AboutView.swift` - all text
9. `Views/Dashboard/SettingsRowComponents.swift` - picker labels, toggle labels

**Font Sizes:**
- Timer countdown: 36-48pt
- Timer labels: 11-12pt
- Buttons: 10-12pt
- Settings headers: 14-16pt
- Settings labels: 13pt
- Sidebar items: 13pt
- Dashboard stats: 24-32pt

---

### Task 6: Testing and Verification (30 min)

**What:**
Build, run, and test font system thoroughly.

**Acceptance Criteria:**
- Build: 0 errors, 0 warnings
- Font picker shows all 7 fonts
- Installed fonts are selectable
- Uninstalled fonts are disabled with label
- Font selection saves to settings
- Font persists after app restart
- All UI text uses selected font
- Font changes apply immediately
- Missing font fallback works (SF Mono)
- All fonts render clearly at all sizes
- Tiny window mode works with all fonts

**Testing Steps:**
1. Build project (Cmd+B)
2. Run app (Cmd+R)
3. Open Settings → Appearance
4. Verify font picker shows all fonts
5. Select different installed fonts
6. Verify timer text changes immediately
7. Verify settings text changes immediately
8. Verify dashboard text changes immediately
9. Quit and restart app
10. Verify selected font persists
11. Test with uninstalled fonts (verify disabled state)

---

## Files to Create

- `Models/AppFont.swift` (new file, ~80 lines)
- `Services/FontManager.swift` (new file, ~100 lines)
- `Utilities/AppFontModifier.swift` (new file, ~50 lines)

---

## Files to Update

- `Services/SettingsManager.swift` (add updateFont method)
- `Views/Dashboard/AppearanceSettingsView.swift` (inject FontManager, add font picker)
- `Views/Timer/TimerView.swift` (apply custom fonts)
- `Views/Dashboard/DashboardView.swift` (apply custom fonts)
- `Views/Dashboard/DashboardSettingsView.swift` (apply custom fonts)
- `Views/Dashboard/GeneralSettingsView.swift` (apply custom fonts)
- `Views/Dashboard/PomodoroSettingsView.swift` (apply custom fonts)
- `Views/Dashboard/SoundSettingsView.swift` (apply custom fonts)
- `Views/Dashboard/AboutView.swift` (apply custom fonts)
- `Views/Dashboard/SettingsRowComponents.swift` (apply custom fonts)

---

## Implementation Order

1. Create `Models/AppFont.swift`
2. Create `Services/FontManager.swift`
3. Build and verify AppFont compiles
4. Update `Services/SettingsManager.swift` (add updateFont)
5. Update `Services/SettingsManager.swift` (call FontManager from loadSettings)
6. Build and verify services compile
7. Update `AppearanceSettingsView.swift` (inject FontManager, add font picker)
8. Build and verify AppearanceSettingsView compiles
9. Create `Utilities/AppFontModifier.swift`
10. Update TimerView to use appFont modifier
11. Update DashboardView to use appFont modifier
12. Update DashboardSettingsView to use appFont modifier
13. Update all Settings views to use appFont modifier
14. Build and verify all views compile
15. Run app and test font selection
16. Test font persistence across restart
17. Verify all fonts render correctly

---

## Success Criteria

By end of day:
- ✅ AppFont.swift created with 7 fonts
- ✅ FontManager.swift created with detection and selection
- ✅ Font picker in Appearance settings works
- ✅ SettingsManager ↔ FontManager integration working
- ✅ Font selection saves and persists
- ✅ Build: 0 errors, 0 warnings
- ✅ Font loads correctly on app restart
- ✅ **Fonts apply to ALL UI text elements**
- ✅ **Font switching works IMMEDIATELY (live preview)**
- ✅ All fonts render clearly at all sizes
- ✅ Ready for Day 4 (Final polish)

---

## Notes & Reminders

- **Focus:** Get fonts FULLY WORKING today - selection UI AND font application
- **Live preview:** Fonts should change immediately when selected (no restart)
- **Pattern matching:** Follow existing ThemeManager pattern for FontManager
- **Auto-save:** Settings save automatically on change (no Save button)
- **Fallback:** Always fallback to SF Mono if selected font unavailable
- **System fonts:** SF Mono, Menlo, Monaco are always available on macOS
- **Font modifier:** Create reusable ViewModifier for consistent font application
- **Test persistence:** Restart app multiple times to verify font loads
- **Font names:** Must match exactly (case-sensitive): "SF Mono", "JetBrains Mono", etc.
- **Visual testing:** Switch between fonts to ensure they're distinct and readable
- **Disabled state:** Uninstalled fonts should be clearly marked and disabled

**Font Preview:**
- Show font name in its own font to give users a preview
- Example: "JetBrains Mono" displayed in JetBrains Mono font

**Missing Font Message:**
```
⚠️ Font Not Available
Previously selected font 'JetBrains Mono' is not installed.
Using 'SF Mono' instead.

To use JetBrains Mono, install it system-wide and restart the app.
```

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

**Task 5 Progress:**
- [ ] Started
- [ ] Completed
- Notes:

**Task 6 Progress:**
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
