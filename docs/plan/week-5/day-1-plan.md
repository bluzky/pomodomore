# Week 5 - Day 1 Plan

**Date:** Monday, January 13, 2026
**Week:** 5 (Themes + Fonts)
**Day:** 1 of 5
**Hours Available:** 8 hours
**Estimated Actual:** ~2 hours (based on 20-25% velocity)

---

## Daily Goal

**Create theme foundation and define all 10 theme color palettes**

Build the core theme architecture with complete color definitions for all 10 code editor-inspired themes, and implement the ThemeManager service for theme loading and management.

---

## Definition of Done

- [ ] Build succeeds with 0 errors, 0 warnings
- [ ] `Models/Theme.swift` created with Theme struct and ThemeColors
- [ ] All 10 themes defined with complete 23-color palettes
- [ ] `Services/ThemeManager.swift` created as ObservableObject
- [ ] ThemeManager loads themes by name
- [ ] Default theme (Nord) loads on app initialization
- [ ] Theme colors accessible via `ThemeManager.shared.currentTheme`
- [ ] Color values match design specifications
- [ ] All themes compile without errors

---

## Tasks

### Task 1: Create Theme Model (45 min)

**What:**
Create `Models/Theme.swift` with the core theme data structures.

**Why:**
Establishes the foundation for the entire theme system. This structure will be used throughout the app to provide consistent theming.

**Acceptance Criteria:**
- ThemeColors struct contains all 23 color properties
- Theme struct contains name and colors
- Color extension supports hex string initialization (e.g., `Color(hex: "#2E3440")`)
- All color properties have descriptive names matching their usage
- Struct is clean and follows Swift naming conventions

**Implementation Notes:**
- Use SwiftUI `Color` for all color values
- ThemeColors should be a struct with 23 color properties:
  - Backgrounds: primary, secondary, tertiary (3)
  - Text: primary, secondary, muted (3)
  - Accents: primary, secondary (2)
  - Borders: primary, secondary (2)
  - Status: success, warning, error (3)
  - Timer States: active, paused, break (3)
  - Session Indicators: complete, incomplete (2)
  - Effects: shadow (1)
- Create Color extension for hex initialization
- Make structures immutable (use `let` for all properties)

---

### Task 2: Define All 10 Themes (60 min)

**What:**
Define complete color palettes for all 10 themes as static properties on the Theme struct.

**Why:**
Provides the actual visual designs for users to choose from. These are carefully selected code editor themes that developers love.

**Acceptance Criteria:**
- All 10 themes defined: Nord, Monokai, Dracula, Solarized Dark, Tokyo Night, Gruvbox Dark, One Dark, Catppuccin Mocha, GitHub Dark, Solarized Light
- Each theme has all 23 colors defined
- Color values are accurate to the original theme designs
- Themes are defined as static properties (e.g., `Theme.nord`)
- `allThemes` static array contains all 10 themes
- Each theme compiles without errors

**Implementation Notes:**
Theme reference colors (from original themes):
1. **Nord** (default, dark blue-gray)
2. **Monokai** (dark with vibrant colors)
3. **Dracula** (dark purple theme)
4. **Solarized Dark** (precision colors, dark)
5. **Tokyo Night** (dark blue-purple)
6. **Gruvbox Dark** (retro warm dark)
7. **One Dark** (Atom's default dark)
8. **Catppuccin Mocha** (pastel dark)
9. **GitHub Dark** (GitHub's dark mode)
10. **Solarized Light** (precision colors, light)

Start with Nord as the reference implementation, then adapt others.

---

### Task 3: Create ThemeManager Service (30 min)

**What:**
Implement `Services/ThemeManager.swift` as a singleton ObservableObject that manages the current theme.

**Why:**
Provides centralized theme management with reactive updates. When the theme changes, all UI will automatically update via SwiftUI's observation.

**Acceptance Criteria:**
- ThemeManager is a singleton (`static let shared`)
- Conforms to ObservableObject
- Has `@Published var currentTheme: Theme`
- Provides `loadTheme(named: String)` method
- Provides `setTheme(_ theme: Theme)` method
- Initializes with Nord theme by default
- Safe handling of invalid theme names (fallback to Nord)

**Implementation Notes:**
```swift
class ThemeManager: ObservableObject {
    static let shared = ThemeManager()

    @Published var currentTheme: Theme = .nord

    private init() {
        // Initialize with default theme
    }

    func loadTheme(named name: String) {
        // Find theme by name, fallback to Nord
    }

    func setTheme(_ theme: Theme) {
        // Update currentTheme
    }
}
```

- Use `@Published` for reactive updates
- Make init private (singleton pattern)
- Theme lookup should be case-insensitive
- Log theme changes for debugging

---

### Task 4: Testing & Verification (15 min)

**What:**
Build the project and verify all themes are working correctly.

**Why:**
Ensures the foundation is solid before moving to Day 2. Catches any structural issues early.

**Acceptance Criteria:**
- Project builds with 0 errors, 0 warnings
- All 10 themes accessible via `Theme.allThemes`
- ThemeManager.shared initializes successfully
- Can load each theme by name
- Default theme (Nord) loads correctly
- All color values compile and are valid SwiftUI Colors

**Testing Steps:**
1. Build project (Cmd+B)
2. Verify no compilation errors
3. Add temporary test code in App init to verify:
   - ThemeManager.shared exists
   - currentTheme is Nord by default
   - All themes in Theme.allThemes
   - loadTheme() switches theme correctly
4. Remove test code after verification
5. Final clean build

---

## Implementation Order

1. Create `Models/Theme.swift` → Define ThemeColors struct
2. Add Color hex initializer extension
3. Define Theme struct
4. Implement Nord theme first (complete reference)
5. Implement remaining 9 themes (copy structure from Nord)
6. Add `allThemes` static array
7. Create `Services/ThemeManager.swift`
8. Implement ThemeManager singleton
9. Add theme loading logic
10. Build and test
11. Verify all themes load correctly

---

## Files to Create

- `Models/Theme.swift` (new file, ~200-300 lines)
- `Services/ThemeManager.swift` (new file, ~50-80 lines)

---

## Files to Update

None for Day 1 (foundation only)

---

## Testing Strategy

**Build Testing:**
- Clean build (Cmd+Shift+K, then Cmd+B)
- No errors, no warnings

**Theme Loading:**
- Verify ThemeManager.shared.currentTheme is Nord by default
- Test loadTheme() with each theme name
- Test loadTheme() with invalid name (should fallback to Nord)

**Color Verification:**
- Spot-check hex color values for accuracy
- Verify all 23 colors exist in each theme
- Ensure Color(hex:) extension works correctly

**Integration:**
- ThemeManager accessible from anywhere via .shared
- Theme switching updates @Published property
- No crashes or runtime errors

---

## Success Criteria

By end of day:
- ✅ Models/Theme.swift complete with all structures
- ✅ All 10 themes fully defined with 23 colors each
- ✅ ThemeManager service implemented and working
- ✅ Build: 0 errors, 0 warnings
- ✅ Default theme (Nord) loads successfully
- ✅ All themes accessible and valid
- ✅ Ready for Day 2 (Font System)

---

## Notes & Reminders

- **Focus:** Build the foundation correctly. Day 2-5 depend on this structure.
- **Color accuracy:** Use official theme color palettes where available
- **Naming:** Keep color property names semantic (describe usage, not appearance)
- **Immutability:** Use structs and `let` properties for themes
- **Singleton:** ThemeManager should be a singleton accessed via `.shared`
- **No UI yet:** Day 1 is pure data structures and service layer
- **Test early:** Build frequently to catch issues immediately

---

## Execution Section

*Fill this in as you work through the day*

**Start Time:** _______

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

**Blockers:**

**End Time:** _______

**Actual Hours:** _______

**Status:** [ ] Complete [ ] In Progress [ ] Blocked

---

**Created:** January 6, 2026
**Status:** Ready to Start
