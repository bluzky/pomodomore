# Week 5 Plan - Themes + Fonts

**Week:** Week 5 (Jan 13-17, 2026)
**Goal:** Visual Customization - Theme System + Font Selection
**Previous Status:** Statistics and UI polish complete (Week 4)

---

## Context

Weeks 1-4 delivered a fully functional Pomodoro timer with complete statistics tracking, dashboard, settings, and sound system. Week 5 focuses on visual customization: implementing the theme system with 10 code editor-inspired themes and monospace font selection.

**Available:** ~40 hours this week (8h/day)
**Historical Velocity:** Tasks completed in ~20-25% of estimated time
**Adjusted Estimate:** ~8-10 hours actual work expected

---

## Week Goal

Implement comprehensive visual customization system:
- Theme system with 10 themes (Nord, Monokai, Dracula, etc.)
- Theme persistence and live preview
- Font selection system (SF Mono, Menlo, Monaco, JetBrains Mono, etc.)
- Font availability detection (show only installed fonts)
- Appearance settings view with theme/font controls
- Immediate theme/font switching (no restart required)

---

## Daily Breakdown

### DAY 1 (Monday) - Theme Foundation + Color System

**Hours:** ~8 (estimated ~2 actual based on velocity)
**Goal:** Create theme architecture and define all theme colors

**Deliverables:**
- Create `Models/Theme.swift` with theme structure
  - Define ThemeColor variables (23 colors per theme)
  - Create Theme protocol/struct
  - Define all 10 themes with complete color palettes
- Implement theme storage and access
  - ThemeManager singleton service
  - Load theme by name
  - Current theme @Published property
- Define all 10 themes from PRD:
  1. Nord (default)
  2. Monokai
  3. Dracula
  4. Solarized Dark
  5. Tokyo Night
  6. Gruvbox Dark
  7. One Dark
  8. Catppuccin Mocha
  9. GitHub Dark
  10. Solarized Light (light theme option)
- Test: All themes load correctly
- Test: ThemeManager provides color access

**Files:**
- Create `Models/Theme.swift` (new file)
- Create `Services/ThemeManager.swift` (new file)

**Testing:**
- Build clean (0 errors, 0 warnings)
- All 10 themes defined with complete color palettes
- ThemeManager loads theme by name
- Color values match PRD specifications
- Default theme (Nord) loads on app launch
- Theme colors accessible via ThemeManager.shared.currentTheme

**Theme Color Variables (23 per theme):**
```swift
struct ThemeColors {
    // Backgrounds
    let backgroundPrimary: Color       // Main window background
    let backgroundSecondary: Color     // Cards, panels
    let backgroundTertiary: Color      // Hover states

    // Text
    let textPrimary: Color            // Main text
    let textSecondary: Color          // Secondary text
    let textMuted: Color              // Disabled text

    // Accents
    let accentPrimary: Color          // Primary buttons
    let accentSecondary: Color        // Secondary highlights

    // Borders
    let borderPrimary: Color          // Main borders
    let borderSecondary: Color        // Secondary borders

    // Status
    let success: Color                // Success states
    let warning: Color                // Warnings
    let error: Color                  // Errors

    // Timer States
    let timerActive: Color            // Active timer (green)
    let timerPaused: Color            // Paused timer (yellow)
    let timerBreak: Color             // Break timer (cyan)

    // Session Indicators
    let sessionComplete: Color        // Filled circle
    let sessionIncomplete: Color      // Empty circle

    // Effects
    let shadow: Color                 // Drop shadows
}
```

**Implementation Notes:**
- Use SwiftUI Color for all color values
- Initialize colors from hex strings
- Each theme is a struct with name and colors
- ThemeManager holds array of all themes
- Use @Published for reactive UI updates

---

### DAY 2 (Tuesday) - Appearance Settings UI + Theme Integration

**Hours:** ~8 (estimated ~2-3 actual based on velocity)
**Goal:** Build Appearance settings UI AND apply themes to all UI components

**Deliverables:**
- Create `AppearanceSettingsView.swift`
  - Theme section with picker/dropdown
  - Theme preview (show 3-4 color samples)
  - Show timer in menubar toggle (existing setting)
  - Window size picker (existing setting)
- Theme picker implementation
  - Display all 10 themes
  - Show theme name
  - Show small color preview circles
  - Highlight selected theme
  - Clean, flat layout (no section boxes)
- Connect to SettingsManager
  - Add appearance.theme property
  - Save theme selection to settings
  - Auto-save on change (no Save button)
- Enable Appearance menu item in sidebar
  - Remove "greyed out" state
  - Make clickable and functional
- Connect ThemeManager to SettingsManager
  - Load saved theme on app launch
  - Update ThemeManager when user selects theme
- **Apply themes to ALL UI components**
  - TimerView (background, text, buttons, timer colors)
  - DashboardView (cards, chart, navigation)
  - All Settings views (backgrounds, text, controls)
  - Sidebar (background, selection, hover)
  - SessionIndicatorsView (circle colors)
- **Live theme switching (no restart required)**
- Test: Theme selection saves and persists
- Test: All 10 themes visually distinct and working

**Files:**
- Create `Views/Dashboard/AppearanceSettingsView.swift` (new file)
- Update `Views/Dashboard/DashboardSettingsView.swift` (enable Appearance item)
- Update `Models/Settings.swift` (add appearance.theme property)
- Update `Services/SettingsManager.swift` (connect to ThemeManager)
- Update `Services/ThemeManager.swift` (add settings integration)
- Update `App/PomodomoreApp.swift` (inject ThemeManager as @EnvironmentObject)
- **Update all View files to use theme colors:**
  - `Views/Timer/TimerView.swift`
  - `Views/Timer/SessionIndicatorsView.swift`
  - `Views/Dashboard/DashboardView.swift`
  - `Views/Dashboard/GeneralSettingsView.swift`
  - `Views/Dashboard/PomodoroSettingsView.swift`
  - `Views/Dashboard/SoundSettingsView.swift`

**Testing:**
- Build clean (0 errors, 0 warnings)
- Appearance menu item clickable in sidebar
- Appearance settings view displays correctly
- Theme picker shows all 10 themes with color previews
- Theme selection saves to settings.appearance.theme
- Theme persists across app restarts
- ThemeManager.currentTheme updates when theme selected
- Window size and menubar timer toggles work
- Settings auto-save on change
- **Themes apply to all UI components immediately**
- **Timer window changes colors when theme selected**
- **Dashboard changes colors when theme selected**
- **All 10 themes visually distinct**
- **No UI flicker or delay during theme switch**

**UI Layout:**
```
╔═══════════════════════════════════════════════════════╗
║  Appearance                                           ║
╠═══════════════════════════════════════════════════════╣
║                                                       ║
║  Theme                                                ║
║  ┌─────────────────────────────────┐                 ║
║  │ Nord                      ● ● ● │ ← color preview ║
║  └─────────────────────────────────┘                 ║
║                                                       ║
║  Window                                               ║
║  ┌─────────────────────────────────┐                 ║
║  │ Small                           │                 ║
║  └─────────────────────────────────┘                 ║
║                                                       ║
║  ☑ Show timer in menubar                             ║
║                                                       ║
╚═══════════════════════════════════════════════════════╝
```

**Implementation Notes:**
- Use Picker or custom dropdown for theme selection
- Theme preview: HStack with 3-4 Circle() views showing key colors
- Flat layout (no section boxes, just headers like other settings)
- Auto-save on selection change (no Save button)
- Use @EnvironmentObject for SettingsManager and ThemeManager
- Connect both managers: Settings ↔ ThemeManager

---

### DAY 3 (Wednesday) - Font System + Font Picker

**Hours:** ~8 (estimated ~2 actual based on velocity)
**Goal:** Implement font selection system with installed font detection

**Deliverables:**
- Create font detection system
  - Query macOS for installed fonts
  - Filter for supported monospace fonts
  - Mark unavailable fonts in UI
- Define supported fonts (7 fonts):
  1. SF Mono (default) - Native macOS
  2. Menlo - Classic macOS
  3. Monaco - Traditional Mac
  4. JetBrains Mono - Developer font
  5. Fira Code - Ligatures
  6. Source Code Pro - Adobe
  7. IBM Plex Mono - IBM
- Create FontManager service
  - Get installed fonts from system
  - Load font by name
  - Handle missing font fallback (use SF Mono)
  - @Published current font property
- Add font picker to AppearanceSettingsView
  - Display all fonts
  - Show "(Not Installed)" for unavailable fonts
  - Disable unavailable fonts (can't select)
  - Font preview (show font name in its own font)
- Connect to SettingsManager
  - Save font selection to settings.appearance.font
  - Load saved font on app launch
- Test: Font detection works correctly
- Test: Font loading handles missing fonts gracefully

**Files:**
- Create `Models/AppFont.swift` (new file)
- Create `Services/FontManager.swift` (new file)
- Update `Views/Dashboard/AppearanceSettingsView.swift` (add font picker)
- Update `Models/Settings.swift` (add appearance.font property)
- Update `Services/SettingsManager.swift` (connect to FontManager)

**Testing:**
- Build clean (0 errors, 0 warnings)
- FontManager detects installed fonts correctly
- Only installed fonts show as available
- Missing fonts show "(Not Installed)" label and are disabled
- Font selection saves to settings
- Font persists across app restarts
- Fallback to SF Mono if selected font unavailable
- Font picker displays correctly in Appearance settings

---

### DAY 4 (Thursday) - Font Integration + Testing

**Hours:** ~8 (estimated ~2 actual based on velocity)
**Goal:** Apply fonts globally and test all theme + font combinations

**Deliverables:**
- Create font application system
  - Global font modifier or @Environment
  - Apply selected font to all text in app
  - Preserve font sizes and weights
- Update all views to use custom font:
  - Timer countdown (48pt bold)
  - Buttons and labels (14pt, 12pt)
  - Settings text (13pt)
  - Dashboard stats (various sizes)
  - Menubar text
- Implement live font switching
  - No restart required
  - All UI updates immediately when font changes
  - Font persists across app restarts
- Handle missing font scenario:
  - If saved font not installed, show message in Appearance settings
  - Fallback to SF Mono
  - Preserve user preference in settings
- Full integration testing:
  - Test all theme combinations
  - Test all installed fonts
  - Test theme + font combinations
  - Test persistence (restart app multiple times)

**Files:**
- Create `Utilities/FontModifier.swift` (ViewModifier for fonts)
- Update all View files (apply custom font)
- Update `Services/FontManager.swift` (add live switching)
- Update `Services/SettingsManager.swift` (connect to FontManager)
- Update `Views/Dashboard/AppearanceSettingsView.swift` (add missing font message)

**Testing:**
- Build clean (0 errors, 0 warnings)
- Font applies to all text in app
- Timer countdown uses selected font (48pt bold)
- All UI text uses selected font
- Font changes apply immediately when selected
- Font persists after app restart
- Missing font shows helpful message
- Fallback to SF Mono if font unavailable
- All fonts readable at all sizes
- Fonts render correctly in tiny window mode
- Theme + font combinations look good together
- No layout breaks with different fonts

---

### DAY 5 (Friday) - Font Integration + Final Polish

**Hours:** ~8 (estimated ~2-3 actual based on velocity)
**Goal:** Apply fonts globally and polish theme/font system

**Deliverables:**
- Create font application system
  - Global font modifier or @Environment
  - Apply selected font to all text in app
  - Preserve font sizes and weights
- Update all views to use custom font:
  - Timer countdown (48pt bold)
  - Buttons and labels (14pt, 12pt)
  - Settings text (13pt)
  - Dashboard stats (various sizes)
  - Menubar text
- Implement live font switching
  - No restart required
  - All UI updates immediately when font changes
  - Font persists across app restarts
- Handle missing font scenario:
  - If saved font not installed, show message in Appearance settings
  - Fallback to SF Mono
  - Preserve user preference in settings
- Full integration testing:
  - Test all theme combinations
  - Test all installed fonts
  - Test theme + font combinations
  - Test system appearance switching
  - Test persistence (restart app multiple times)
- Polish and edge cases:
  - Verify all themes have good contrast
  - Ensure fonts render clearly at all sizes
  - Test tiny window mode with all themes/fonts
  - Fix any visual issues or layout breaks
- Build: 0 errors, 0 warnings
- Create Week 5 summary document

**Files:**
- Create `Utilities/FontModifier.swift` (ViewModifier for fonts)
- Update all View files (apply custom font)
- Update `Services/FontManager.swift` (add live switching)
- Update `Services/SettingsManager.swift` (connect to FontManager)
- Update `Views/Dashboard/AppearanceSettingsView.swift` (add missing font message)
- Create `docs/plan/week-5/summary.md`

**Testing:**
- Build clean (0 errors, 0 warnings)
- Font applies to all text in app
- Timer countdown uses selected font (48pt bold)
- All UI text uses selected font
- Font changes apply immediately when selected
- Font persists after app restart
- Missing font shows helpful message
- Fallback to SF Mono if font unavailable
- All fonts readable at all sizes
- Fonts render correctly in tiny window mode
- Theme + font combinations look good together
- No layout breaks with different fonts
- Color contrast meets accessibility standards
- Performance smooth with theme/font switching

**Success Criteria:**
- 10 themes fully implemented and working
- 7 fonts supported with availability detection
- Appearance settings view complete
- Theme changes apply immediately
- Font changes apply immediately
- Settings persist across restarts
- System appearance (light/dark) switches themes
- All UI elements themed and fonted correctly
- No crashes or visual glitches
- Clean build with 0 warnings
- Week 5 summary created

**Font Application Strategy:**
```swift
// Global font modifier
extension View {
    func appFont(size: CGFloat, weight: Font.Weight = .regular) -> some View {
        self.font(.custom(FontManager.shared.currentFont, size: size))
            .fontWeight(weight)
    }
}

// Usage
Text("25:00")
    .appFont(size: 48, weight: .bold)
```

**Missing Font Message:**
```
⚠️ Font Not Available
Previously selected font 'JetBrains Mono' is not installed.
Using 'SF Mono' instead.

To use JetBrains Mono, install it system-wide and restart the app.
```

---

## Total: ~40 hours estimated, ~8-10 hours actual expected

---

## Success Metrics

By Friday EOD:
- [ ] Theme system implemented (10 themes) ✅ Day 1
- [ ] All themes defined with complete color palettes ✅ Day 1
- [ ] ThemeManager service working ✅ Day 1
- [ ] Appearance settings view created ✅ Day 2
- [ ] Theme picker with color previews ✅ Day 2
- [ ] Theme applies to all UI elements ✅ Day 2
- [ ] Live theme switching (no restart) ✅ Day 2
- [ ] Theme persistence working ✅ Day 2
- [ ] All themes visually distinct and readable ✅ Day 2
- [ ] Font system implemented (7 fonts) ✅ Day 3
- [ ] Font detection working (show only installed fonts) ✅ Day 3
- [ ] FontManager service working ✅ Day 3
- [ ] Font picker with availability detection ✅ Day 3
- [ ] Font applies to all text ✅ Day 4
- [ ] Live font switching (no restart) ✅ Day 4
- [ ] Font persistence working ✅ Day 3-4
- [ ] Missing font fallback working ✅ Day 3-4
- [ ] All fonts render clearly ✅ Day 4
- [ ] Build: 0 errors, 0 warnings ✅ Every day
- [ ] Week 5 summary created ✅ Day 5

---

## Out of Scope (Week 6+)

**Week 6 Focus:**
- Polish + bug fixes
- Edge case handling (sleep/wake, date change)
- UI animations and transitions
- Performance optimization
- Final testing pass
- Production readiness

**Future Enhancements:**
- Custom theme creation/import
- Theme sharing/marketplace
- Font size customization per UI element
- Non-monospace font support
- Font weight customization
- Additional themes

---

## Architecture Notes

### Theme Structure
```swift
struct Theme {
    let name: String
    let colors: ThemeColors

    static let nord = Theme(
        name: "Nord",
        colors: ThemeColors(
            backgroundPrimary: Color(hex: "#2E3440"),
            backgroundSecondary: Color(hex: "#3B4252"),
            // ... all 23 colors
        )
    )

    static let allThemes = [nord, monokai, dracula, ...]
}
```

### Font Structure
```swift
struct AppFont {
    let name: String
    let isInstalled: Bool

    static let supportedFonts = [
        "SF Mono",
        "Menlo",
        "Monaco",
        "JetBrains Mono",
        "Fira Code",
        "Source Code Pro",
        "IBM Plex Mono"
    ]
}
```

### Settings Integration
```swift
struct AppearanceSettings: Codable {
    var lightTheme: String = "Nord"       // Used in light mode
    var darkTheme: String = "Nord"        // Used in dark mode
    var font: String = "SF Mono"
    var showTimerInMenubar: Bool = true
    var windowSize: WindowSize = .small
}
```

### Theme Application Flow
```
User selects theme → SettingsManager → ThemeManager
                                          ↓
                                  @Published currentTheme
                                          ↓
                                  All Views update (SwiftUI)
                                          ↓
                                  Settings saved to JSON
```

### Font Application Flow
```
User selects font → SettingsManager → FontManager
                                         ↓
                                 Check if installed
                                         ↓
                                 @Published currentFont
                                         ↓
                                 All Views update (custom modifier)
                                         ↓
                                 Settings saved to JSON
```

---

## Testing Strategy

**Daily Testing:**
- Build verification (0 errors, 0 warnings)
- Feature isolation (test each theme/font individually)
- Visual inspection (ensure colors/fonts look correct)

**End-to-End Testing (Day 5):**
- All 10 themes tested individually
- All installed fonts tested
- Theme + font combinations
- System appearance switching (light/dark)
- Settings persistence (restart app multiple times)
- Edge cases:
  - Missing font handling
  - Corrupt theme data (fallback to default)
  - Rapid theme/font switching
  - Tiny window mode with all themes/fonts
  - Long font names in UI
  - Theme contrast validation
  - Font readability at small sizes

**Visual Quality Checklist:**
- [ ] All themes have sufficient contrast
- [ ] Text readable in all themes
- [ ] Timer colors distinct (active/paused/break)
- [ ] Session indicators visible in all themes
- [ ] Dashboard chart readable
- [ ] Buttons clearly visible
- [ ] All fonts readable at timer size (48pt)
- [ ] All fonts readable at UI size (12-14pt)
- [ ] No layout breaks with any font
- [ ] Tiny mode works with all themes/fonts

---

## Risks & Mitigations

| Risk | Mitigation |
|------|-----------|
| Too many themes to test thoroughly | Automate color contrast checks, focus on top 3-4 themes |
| Font detection unreliable | Use NSFontManager API, test on multiple macOS versions |
| Theme switching causes UI flicker | Use @Published + Combine for smooth updates |
| Font sizes break layout | Use dynamic spacing, test all fonts in all views |
| Missing font not handled gracefully | Validate font on load, show helpful message |
| Theme colors don't meet contrast standards | Validate with accessibility tools, adjust as needed |
| System appearance switching broken | Test light/dark mode transitions thoroughly |
| Performance issues with theme changes | Cache theme colors, use efficient color lookups |

---

## Dependencies

**Required macOS APIs:**
- NSFontManager (font detection)
- NSFont (font availability checking)
- NSAppearance (system light/dark mode detection)
- Combine (@Published for reactive updates)
- SwiftUI (Color, @EnvironmentObject)

**Existing Services to Integrate:**
- SettingsManager (save/load theme and font preferences)
- StorageManager (persist settings to JSON)
- All View files (apply theme colors and fonts)

---

**Created:** January 6, 2026
**Status:** ✅ Ready to Start
