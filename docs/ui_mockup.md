
# UI Mockups - macOS Pomodoro App
**ASCII Visual Reference Guide**

---

## Table of Contents
1. [Menubar / System Tray](#menubar--system-tray)
2. [Timer Window](#timer-window)
3. [Settings Dialog](#settings-dialog)
4. [Statistics Window](#statistics-window)
5. [About Dialog](#about-dialog)
6. [Notifications](#notifications)
7. [Interactive States](#interactive-states)

---

## Menubar / System Tray

### State 1: Idle (No Timer Running)
```
┌─────────────────────────────────────────┐
│  🍎   [🍅] ▼  📶  🔋  🔍  🕐 2:45 PM   │
└─────────────────────────────────────────┘
      Tomato icon in menubar
      No timer display (setting disabled)
```

### State 2: Timer Running (Timer Display Enabled)
```
┌─────────────────────────────────────────┐
│  🍎  [🍅 24:35] ▼  📶  🔋  🕐 2:45 PM  │
└─────────────────────────────────────────┘
     Timer shown in menubar (SF Mono 12pt)
```

### State 3: Menu Expanded (Idle)
```
┌─────────────────────────────────────────┐
│  🍎   [🍅] ▼  📶  🔋  🕐 2:45 PM        │
└──────┬──────────────────────────────────┘
       │
       ┌────────────────────────┐
       │ Start                  │
       │ Reset                  │
       ├────────────────────────┤
       │ Statistics...          │
       │ ☐ Always on Top        │
       │ Settings...            │
       ├────────────────────────┤
       │ About                  │
       │ Quit                   │
       └────────────────────────┘
```

### State 4: Menu Expanded (Timer Running - Pomodoro)
```
┌─────────────────────────────────────────┐
│  🍎  [🍅 24:35] ▼  📶  🔋  🕐 2:45 PM  │
└──────┬──────────────────────────────────┘
       │
       ┌────────────────────────┐
       │ Pause                  │ ← Pause during Pomodoro
       │ Reset                  │
       ├────────────────────────┤
       │ Statistics...          │
       │ ☑ Always on Top        │ ← Checked
       │ Settings...            │
       ├────────────────────────┤
       │ About                  │
       │ Quit                   │
       └────────────────────────┘
```

### State 5: Menu Expanded (Break Running)
```
┌─────────────────────────────────────────┐
│  🍎  [🍅 04:35] ▼  📶  🔋  🕐 2:45 PM  │
└──────┬──────────────────────────────────┘
       │
       ┌────────────────────────┐
       │ Stop                   │ ← Stop during Break
       ├────────────────────────┤
       │ Statistics...          │
       │ ☑ Always on Top        │
       │ Settings...            │
       ├────────────────────────┤
       │ About                  │
       │ Quit                   │
       └────────────────────────┘

No Reset option during breaks
Only Stop to end break early
```

---

## Timer Window

### Window 1: Pomodoro Session (Active)
```
╔═══════════════════════════════════════╗
║                              [X]      ║
║                                       ║
║            24:35                      ║
║      (large, #A3BE8C green)           ║
║                                       ║
║    [Pause]          [Reset]           ║
║                                       ║
║    Completed: ● ● ○ ○                 ║
║                                       ║
╚═══════════════════════════════════════╝

Colors (Nord Theme):
- Background: #2E3440
- Timer Text: #A3BE8C (active green)
- Session Dots (filled): #A3BE8C
- Session Dots (empty): #4C566A
- Buttons: #88C0D0 (accent)
- Text: #ECEFF4

Dimensions: 320 × 200 pixels
Font: SF Mono (user-selected)
```

### Window 2: Pomodoro Session (Paused)
```
╔═══════════════════════════════════════╗
║                              [X]      ║
║                                       ║
║            24:35                      ║
║      (large, #EBCB8B orange)          ║
║                                       ║
║    [Start]          [Reset]           ║
║                                       ║
║    Completed: ● ● ○ ○                 ║
║                                       ║
╚═══════════════════════════════════════╝

Timer Color: #EBCB8B (paused orange)
Button shows "Start" instead of "Pause"
```

### Window 3: Short Break Session
```
╔═══════════════════════════════════════╗
║  Short Break                 [X]      ║
║                                       ║
║            05:00                      ║
║      (large, #88C0D0 cyan)            ║
║                                       ║
║           [Stop]                      ║
║                                       ║
║    Completed: ● ● ● ○                 ║
║                                       ║
╚═══════════════════════════════════════╝

Session Label: "Short Break" (top left)
Timer Color: #88C0D0 (break cyan)
Only Stop button available during breaks
Stop returns to Pomodoro timer with Start button
Third dot is now filled (break session active)
```

### Window 4: Long Break Session
```
╔═══════════════════════════════════════╗
║  Long Break                  [X]      ║
║                                       ║
║            15:00                      ║
║      (large, #88C0D0 cyan)            ║
║                                       ║
║           [Stop]                      ║
║                                       ║
║    Completed: ● ● ● ●                 ║
║                                       ║
╚═══════════════════════════════════════╝

Session Label: "Long Break" (top left)
Only Stop button available during breaks
Stop returns to Pomodoro timer with Start button
All 4 dots filled (4th pomodoro completed)
After long break completes, dots reset to ○ ○ ○ ○
```

### Window 5: Pomodoro Completion (00:00)
```
╔═══════════════════════════════════════╗
║                              [X]      ║
║                                       ║
║            00:00                      ║
║      (large, #A3BE8C green)           ║
║      Pomodoro Complete!               ║
║                                       ║
║    [Start Break]    [Skip Break]      ║
║                                       ║
║    Completed: ● ● ● ○                 ║
║                                       ║
╚═══════════════════════════════════════╝

Pomodoro session just completed
Sound plays at 00:00
User can start appropriate break or skip
If skipped, shows Pomodoro timer with [Start] button
```

### Window 6: Break Completion (00:00)
```
╔═══════════════════════════════════════╗
║  Short Break                 [X]      ║
║                                       ║
║            00:00                      ║
║      (large, #88C0D0 cyan)            ║
║      Break Complete!                  ║
║                                       ║
║         [Start Pomodoro]              ║
║                                       ║
║    Completed: ● ● ● ●                 ║
║                                       ║
╚═══════════════════════════════════════╝

Break session just completed
Sound plays at 00:00
Dot filled for completed break
Returns to Pomodoro timer ready to start
```

### Window 7: Pomodoro Ready (After Break Stopped/Completed)
```
╔═══════════════════════════════════════╗
║                              [X]      ║
║                                       ║
║            25:00                      ║
║      (large, #ECEFF4 default)         ║
║                                       ║
║           [Start]                     ║
║                                       ║
║    Completed: ● ● ● ○                 ║
║                                       ║
╚═══════════════════════════════════════╝

Ready to start next Pomodoro
Shows after:
- Break is stopped early (Stop button)
- Break completes naturally
- User skips break after Pomodoro
Timer shows default duration, neutral color
```

### Window 8: Minimal Size Reference
```
╔═══════════════════════════╗
║                   [X]     ║
║       24:35               ║
║   [Pause]  [Reset]        ║
║   ● ● ○ ○                 ║
╚═══════════════════════════╝

Minimum: 280 × 180 pixels
Compact mode for corner placement
Shows Pomodoro session (Pause + Reset buttons)
```

---

## Dashboard + Settings Window

### Window Specifications
- **Dimensions:** 720 × 520 pixels
- **Sidebar Width:** 160px
- **Content Area:** 560px
- **Layout:** Sidebar navigation with content area
- **Modal:** Yes (blocks interaction with other windows)
- **Font:** SF Mono 12pt (or user-selected)
- **Theme:** Nord (or user-selected)

### Window Structure Overview
```
╔═══════════════════════════════════════════════════════════════════╗
║  PomodoMore                                                [X]    ║
╠════════════════╦══════════════════════════════════════════════════╣
║                ║                                                  ║
║   SIDEBAR      ║              CONTENT AREA                        ║
║   (160px)      ║              (560px)                             ║
║                ║                                                  ║
║  Dashboard     ║  Shows selected section:                         ║
║  ──────────    ║  - Dashboard (statistics)                        ║
║  Settings:     ║  - General settings                              ║
║    General     ║  - Pomodoro settings                             ║
║    Pomodoro    ║  - Sound settings                                ║
║    Sound       ║  - Appearance settings                           ║
║    Appearance  ║                                                  ║
║                ║  [Cancel] [Save] shown for settings sections     ║
║                ║                                                  ║
╚════════════════╩══════════════════════════════════════════════════╝
```

---

### 1. Dashboard View (Default)
```
╔═══════════════════════════════════════════════════════════════════╗
║  PomodoMore                                                [X]    ║
╠════════════════╦══════════════════════════════════════════════════╣
║                ║                                                  ║
║  📊 Dashboard ◀║  Dashboard                                       ║
║                ║                                                  ║
║  ────────────  ║  Today                                           ║
║                ║                                                  ║
║  ⚙️ Settings    ║  ┌──────────┐  ┌──────────┐  ┌──────────────┐  ║
║                ║  │    4     │  │   100    │  │   🔥 3 days  │  ║
║  General       ║  │ Sessions │  │ Minutes  │  │    Streak    │  ║
║  Pomodoro      ║  └──────────┘  └──────────┘  └──────────────┘  ║
║  Sound         ║                                                  ║
║  Appearance    ║                                                  ║
║                ║  This Week                                       ║
║                ║                                                  ║
║                ║  [◄ Prev]  Jan 13-19, 2026  [Next ►]             ║
║                ║                                                  ║
║                ║   Sessions                                       ║
║                ║   16 ┤                                           ║
║                ║      │                                           ║
║                ║   12 ┤           ████                            ║
║                ║      │     ████  ████                            ║
║                ║    8 ┤     ████  ████      ████                  ║
║                ║      │     ████  ████      ████                  ║
║                ║    4 ┤     ████  ████      ████  ████            ║
║                ║      │     ████  ████      ████  ████            ║
║                ║    0 └─────┴─────┴─────┴─────┴─────┴─────       ║
║                ║         M    T    W    T    F    S    S          ║
║                ║                                                  ║
║                ║   Total: 18 sessions  •  450 minutes             ║
║                ║                                                  ║
║                ║                                                  ║
╚════════════════╩══════════════════════════════════════════════════╝

Dashboard (read-only view):
- No Cancel/Save buttons
- Today section with 3 horizontal cards
- This Week section with bar chart
- Week navigation (prev/next)
- Total summary at bottom
```

#### Today Cards Detail
```
┌────────────────┐  ┌────────────────┐  ┌────────────────┐
│                │  │                │  │                │
│       4        │  │      100       │  │    🔥 3 days   │
│                │  │                │  │                │
│   Sessions     │  │    Minutes     │  │     Streak     │
│                │  │                │  │                │
└────────────────┘  └────────────────┘  └────────────────┘

Card Specifications:
- Width: ~170px each
- Height: ~80px
- Background: #3B4252 (background_secondary)
- Border: 1px solid #4C566A
- Border radius: 6px
- Spacing between cards: 12px
- Number: 32pt bold, #ECEFF4
- Label: 11pt regular, #D8DEE9
```

---

### 2. General Settings View
```
╔═══════════════════════════════════════════════════════════════════╗
║  PomodoMore                                                [X]    ║
╠════════════════╦══════════════════════════════════════════════════╣
║                ║                                                  ║
║  📊 Dashboard  ║  General                                         ║
║                ║                                                  ║
║  ────────────  ║                                                  ║
║                ║  Startup                                         ║
║  ⚙️ Settings    ║                                                  ║
║                ║  [✓] Start on login                              ║
║  General      ◀║      Launch PomodoMore when you log in           ║
║  Pomodoro      ║                                                  ║
║  Sound         ║                                                  ║
║  Appearance    ║                                                  ║
║                ║  About                                           ║
║                ║                                                  ║
║                ║  🍅 PomodoMore                                   ║
║                ║  Version 1.0.0                                   ║
║                ║                                                  ║
║                ║  A focused Pomodoro timer for macOS              ║
║                ║                                                  ║
║                ║  © 2026                                          ║
║                ║                                                  ║
║                ║  [Documentation]    [GitHub]                     ║
║                ║                                                  ║
║                ║                                                  ║
║                ║                                                  ║
║                ║                                                  ║
║                ║                                                  ║
║                ║                                                  ║
║                ║                                                  ║
║                ║                                                  ║
║                ║                      [Cancel]        [Save]      ║
║                ║                                                  ║
╚════════════════╩══════════════════════════════════════════════════╝

General settings (flat layout):
- Startup section with login toggle
- About section with app info
- Links to documentation and GitHub
- Cancel/Save buttons at bottom
```

---

### 3. Pomodoro Settings View
```
╔═══════════════════════════════════════════════════════════════════╗
║  PomodoMore                                                [X]    ║
╠════════════════╦══════════════════════════════════════════════════╣
║                ║                                                  ║
║  📊 Dashboard  ║  Pomodoro                                        ║
║                ║                                                  ║
║  ────────────  ║                                                  ║
║                ║  Session Durations                               ║
║  ⚙️ Settings    ║                                                  ║
║                ║  Pomodoro session:                               ║
║  General       ║  [25] minutes  ▲▼                                ║
║  Pomodoro     ◀║                                                  ║
║  Sound         ║  Short break:                                    ║
║  Appearance    ║  [ 5] minutes  ▲▼                                ║
║                ║                                                  ║
║                ║  Long break:                                     ║
║                ║  [15] minutes  ▲▼                                ║
║                ║                                                  ║
║                ║  Long break interval:                            ║
║                ║  [ 4] sessions  ▲▼                               ║
║                ║  Take long break after N pomodoros               ║
║                ║                                                  ║
║                ║                                                  ║
║                ║  Auto-Start                                      ║
║                ║                                                  ║
║                ║  [✓] Auto-start next session                     ║
║                ║      Automatically begin breaks and pomodoros    ║
║                ║      when timer completes                        ║
║                ║                                                  ║
║                ║                                                  ║
║                ║                                                  ║
║                ║                                                  ║
║                ║                                                  ║
║                ║                      [Cancel]        [Save]      ║
║                ║                                                  ║
╚════════════════╩══════════════════════════════════════════════════╝

Pomodoro settings (flat layout):
- Session Durations section
- Auto-Start section
- Steppers (▲▼) for numeric inputs
- Helper text in muted color
- Cancel/Save buttons
```

---

### 4. Sound & Notification Settings View
```
╔═══════════════════════════════════════════════════════════════════╗
║  PomodoMore                                                [X]    ║
╠════════════════╦══════════════════════════════════════════════════╣
║                ║                                                  ║
║  📊 Dashboard  ║  Sound & Notification                            ║
║                ║                                                  ║
║  ────────────  ║                                                  ║
║                ║  Notifications                                   ║
║  ⚙️ Settings    ║                                                  ║
║                ║  [✓] Enable notifications                        ║
║  General       ║      Show macOS notification when sessions       ║
║  Pomodoro      ║      complete                                    ║
║  Sound        ◀║                                                  ║
║  Appearance    ║                                                  ║
║                ║  Sounds                                          ║
║                ║                                                  ║
║                ║  Tick sound:                                     ║
║                ║  [None                             ▼]            ║
║                ║  Plays every second during active timer          ║
║                ║                                                  ║
║                ║  Ambient sound:                                  ║
║                ║  [None                             ▼]            ║
║                ║  Background audio during work sessions           ║
║                ║                                                  ║
║                ║                                                  ║
║                ║  Note: Volume is controlled by macOS system      ║
║                ║  settings                                        ║
║                ║                                                  ║
║                ║                                                  ║
║                ║                                                  ║
║                ║                                                  ║
║                ║                      [Cancel]        [Save]      ║
║                ║                                                  ║
╚════════════════╩══════════════════════════════════════════════════╝

Sound settings (flat layout):
- Notifications section
- Sounds section with dropdowns
- Note about system volume
- Cancel/Save buttons
```

#### Tick Sound Dropdown Expanded
```
║  Tick sound:                                     ║
║  [None                             ▼]            ║
║  ┌────────────────────────────────┐              ║
║  │ None                           │ ◄ Selected   ║
║  │ Tick 1                         │              ║
║  │ Tick 2                         │              ║
║  │ Tick 3                         │              ║
║  │ Glass                          │              ║
║  │ Tink                           │              ║
║  │ Pop                            │              ║
║  └────────────────────────────────┘              ║

System sounds for tick sound
Plays every second during active timer
```

#### Ambient Sound Dropdown Expanded
```
║  Ambient sound:                                  ║
║  [None                             ▼]            ║
║  ┌────────────────────────────────┐              ║
║  │ None                           │ ◄ Selected   ║
║  │ White Noise                    │              ║
║  │ Rain                           │              ║
║  │ Cafe                           │              ║
║  │ Forest                         │              ║
║  │ Ocean                          │              ║
║  └────────────────────────────────┘              ║

Ambient sounds loop during Pomodoro sessions
Stop during breaks
```

---

### 5. Appearance Settings View
```
╔═══════════════════════════════════════════════════════════════════╗
║  PomodoMore                                                [X]    ║
╠════════════════╦══════════════════════════════════════════════════╣
║                ║                                                  ║
║  📊 Dashboard  ║  Appearance                                      ║
║                ║                                                  ║
║  ────────────  ║                                                  ║
║                ║  Themes                                          ║
║  ⚙️ Settings    ║                                                  ║
║                ║  Light theme:                                    ║
║  General       ║  [Nord Light                       ▼]            ║
║  Pomodoro      ║  Used when macOS is in Light mode                ║
║  Sound         ║                                                  ║
║  Appearance   ◀║  Dark theme:                                     ║
║                ║  [Nord Dark                        ▼]            ║
║                ║  Used when macOS is in Dark mode                 ║
║                ║                                                  ║
║                ║  [+ Add Custom Theme...]                         ║
║                ║  Import theme from JSON file                     ║
║                ║                                                  ║
║                ║                                                  ║
║                ║  Typography                                      ║
║                ║                                                  ║
║                ║  Font:                                           ║
║                ║  [SF Mono                          ▼]            ║
║                ║  Monospace font used throughout app              ║
║                ║                                                  ║
║                ║                                                  ║
║                ║  Menubar                                         ║
║                ║                                                  ║
║                ║  [✓] Show timer in menubar                       ║
║                ║      Display countdown (MM:SS) in menubar        ║
║                ║                                                  ║
║                ║                                                  ║
║                ║                      [Cancel]        [Save]      ║
║                ║                                                  ║
╚════════════════╩══════════════════════════════════════════════════╝

Appearance settings (flat layout):
- Themes section (light/dark themes + custom import)
- Typography section (font selection)
- Menubar section (visibility toggle)
- Cancel/Save buttons
```

#### Light Theme Dropdown Expanded
```
║  Light theme:                                    ║
║  [Nord Light                       ▼]            ║
║  ┌────────────────────────────────┐              ║
║  │ ███ Nord Light                 │ ◄ Selected   ║
║  │ ███ Solarized Light            │              ║
║  │ ███ GitHub Light               │              ║
║  │ ███ Atom One Light             │              ║
║  └────────────────────────────────┘              ║

Color preview squares (███) show theme accent
Used when macOS is in Light mode
```

#### Dark Theme Dropdown Expanded
```
║  Dark theme:                                     ║
║  [Nord Dark                        ▼]            ║
║  ┌────────────────────────────────┐              ║
║  │ ███ Nord Dark                  │ ◄ Selected   ║
║  │ ███ Monokai                    │              ║
║  │ ███ Dracula                    │              ║
║  │ ███ Tokyo Night                │              ║
║  │ ███ Gruvbox Dark               │              ║
║  │ ███ One Dark                   │              ║
║  │ ███ Catppuccin Mocha           │              ║
║  │ ███ Solarized Dark             │              ║
║  └────────────────────────────────┘              ║

More dark themes available
Each with color preview
Used when macOS is in Dark mode
```

#### Font Dropdown Expanded
```
║  Font:                                           ║
║  [SF Mono                          ▼]            ║
║  ┌────────────────────────────────┐              ║
║  │ SF Mono                        │ ◄ Selected   ║
║  │ Menlo                          │              ║
║  │ Monaco                         │              ║
║  │ JetBrains Mono                 │              ║
║  │ Fira Code                      │              ║
║  │ Source Code Pro                │              ║
║  │ IBM Plex Mono                  │              ║
║  └────────────────────────────────┘              ║

Each font name rendered in its typeface
Only shows installed fonts
```

---

### Sidebar States & Interactions

#### Sidebar Normal State
```
║                ║
║  📊 Dashboard  ║
║                ║
║  ────────────  ║
║                ║
║  ⚙️ Settings    ║
║                ║
║  General       ║
║  Pomodoro      ║
║  Sound         ║
║  Appearance    ║
║                ║

Sidebar sections:
- Dashboard (with 📊 icon)
- Separator line
- Settings header (with ⚙️ icon)
- General, Pomodoro, Sound, Appearance
```

#### Sidebar Active States
```
Dashboard Active:
║  📊 Dashboard ◀║  ← Arrow indicator
║                ║  ← Background highlight (#88C0D0 20% opacity)

General Active:
║  General      ◀║  ← Arrow indicator
║                ║  ← Background highlight

Pomodoro Active:
║  Pomodoro     ◀║  ← Arrow indicator
║                ║  ← Background highlight

Sound Active:
║  Sound        ◀║  ← Arrow indicator
║                ║  ← Background highlight

Appearance Active:
║  Appearance   ◀║  ← Arrow indicator
║                ║  ← Background highlight
```

#### Sidebar Hover State
```
║  Pomodoro  ←  ║  ← Subtle background on hover
║                ║  ← Cursor changes to pointer

Hover background: #3B4252 (background_secondary)
```

---

### Validation Error Example
```
║  Pomodoro session:                               ║
║  [0] minutes  ▲▼                                  ║
║  ⚠ Duration must be between 1-60 minutes         ║

Error message in warning color (#EBCB8B)
Appears below invalid field
Save remains enabled (validates on save attempt)
```

---

## Statistics / Dashboard

**NOTE:** Statistics are now integrated into the Dashboard + Settings Window (see above).
Access statistics by clicking "Settings..." in the menubar, which opens the Dashboard view by default.

The Dashboard view shows:
- **Today section:** 3 cards with Sessions, Minutes, and Streak
- **This Week section:** Bar chart with week navigation

### Dashboard Reference
See **Dashboard + Settings Window → Dashboard View** section above for complete mockup.

---

## About Information

**NOTE:** About information is now integrated into the General settings view.
Access by opening Settings and navigating to the General section.

The About section shows:
- App name and icon (🍅 PomodoMore)
- Version number
- Description
- Copyright
- Links to Documentation and GitHub

### About Reference
See **Dashboard + Settings Window → General Settings View** section above for complete mockup.

---

## Notifications

### macOS Notification - Pomodoro Complete
```
┌─────────────────────────────────────────┐
│  🍅 Pomodoro Timer         [x]  [⚙]    │
├─────────────────────────────────────────┤
│  Pomodoro Complete!                     │
│  Time for a 5 minute break.            │
│                                         │
│  [Skip Break]        [Start Break]     │
└─────────────────────────────────────────┘

macOS native notification style
Appears top-right of screen
Actions available (if auto-start disabled)
```

### macOS Notification - Break Complete
```
┌─────────────────────────────────────────┐
│  🍅 Pomodoro Timer         [x]  [⚙]    │
├─────────────────────────────────────────┤
│  Break Complete!                        │
│  Ready to start another Pomodoro?       │
│                                         │
│  [Skip]              [Start Pomodoro]  │
└─────────────────────────────────────────┘

Notification for break ending
Prompts user to continue working
```

### macOS Notification - Long Break
```
┌─────────────────────────────────────────┐
│  🍅 Pomodoro Timer         [x]  [⚙]    │
├─────────────────────────────────────────┤
│  4 Pomodoros Complete! 🎉               │
│  Time for a 15 minute long break.      │
│                                         │
│  [Skip Break]      [Start Long Break]  │
└─────────────────────────────────────────┘

Special notification for long break
Celebration emoji for achievement
```

---

## Interactive States

### Button States

#### Normal State
```
┌─────────┐
│  Start  │
└─────────┘
Background: accent_primary (#88C0D0)
Text: text_primary (#ECEFF4)
```

#### Hover State
```
┌─────────┐
│  Start  │  ← cursor here
└─────────┘
Background: accent_secondary (#81A1C1)
Text: text_primary (#ECEFF4)
Slight brightness increase
```

#### Pressed State
```
┌─────────┐
│  Start  │
└─────────┘
Background: darker accent_primary
Inset shadow effect
```

#### Disabled State
```
┌─────────┐
│  Start  │
└─────────┘
Background: background_tertiary (#434C5E)
Text: text_muted (#616E88)
No cursor interaction
```

### Checkbox States

#### Unchecked
```
[ ] Show Timer on System Tray
```

#### Checked
```
[✓] Show Timer on System Tray
Checkmark in accent_primary color
```

#### Hover
```
[▪] Show Timer on System Tray
   ↑ cursor
Border highlights in accent_secondary
```

### Session Indicator Dots

#### States
```
Empty:     ○  (border: session_incomplete #4C566A)
Filled:    ●  (fill: session_complete #A3BE8C)
Current:   ◉  (pulsing animation, accent_primary)
```

#### Animation Sequence
```
Starting:   ○ ○ ○ ○
1st Done:   ● ○ ○ ○
2nd Done:   ● ● ○ ○
3rd Done:   ● ● ● ○
4th Done:   ● ● ● ●
After Long Break: ○ ○ ○ ○  (reset)
```

---

## Responsive Sizing

### Timer Window Size Variations

#### Standard Size (320×200)
```
╔═══════════════════════════════════════╗
║                              [X]      ║
║                                       ║
║            24:35                      ║
║                                       ║
║    [Pause]          [Reset]           ║
║                                       ║
║    Completed: ● ● ○ ○                 ║
║                                       ║
╚═══════════════════════════════════════╝
```

#### Compact Size (280×180)
```
╔═════════════════════════════╗
║                     [X]     ║
║                             ║
║        24:35                ║
║                             ║
║  [Pause]     [Reset]        ║
║                             ║
║  ● ● ○ ○                    ║
╚═════════════════════════════╝
```

#### Minimal Size (240×150) - Smallest allowed
```
╔═══════════════════════╗
║               [X]     ║
║      24:35            ║
║  [Pause] [Reset]      ║
║  ● ● ○ ○              ║
╚═══════════════════════╝
```

---

## Special States & Transitions

### Loading State (App Launch)
```
╔═══════════════════════════════════════╗
║                              [X]      ║
║                                       ║
║                                       ║
║          Loading...                   ║
║            ⚙️                          ║
║                                       ║
║                                       ║
║                                       ║
╚═══════════════════════════════════════╝

Brief loading screen if needed
Spinning gear animation
```

### System Sleep Warning
```
╔═══════════════════════════════════════╗
║  Pomodoro Timer                       ║
║                                       ║
║  Your Mac went to sleep during        ║
║  an active Pomodoro session.          ║
║                                       ║
║  What would you like to do?           ║
║                                       ║
║  [Continue Session]  [Reset Session]  ║
║                                       ║
╚═══════════════════════════════════════╝

Alert appears on wake from sleep
User chooses how to proceed
```

### Settings Changed During Session
```
╔═══════════════════════════════════════╗
║  Pomodoro Timer                       ║
║                                       ║
║  Settings have been updated.          ║
║                                       ║
║  New settings will apply to the       ║
║  next session.                        ║
║                                       ║
║               [OK]                    ║
║                                       ║
╚═══════════════════════════════════════╝

Info dialog
Non-disruptive
Auto-closes after 3 seconds
```

---

## Color Reference Card

### Nord Colors (Default)
```
┌────────────────────────────────────────┐
│ Background Primary:    ████ #2E3440    │
│ Background Secondary:  ████ #3B4252    │
│ Text Primary:          ████ #ECEFF4    │
│ Accent Primary:        ████ #88C0D0    │
│ Success/Timer Active:  ████ #A3BE8C    │
│ Warning/Timer Paused:  ████ #EBCB8B    │
│ Break Timer:           ████ #88C0D0    │
└────────────────────────────────────────┘
```

### Monokai Colors
```
┌────────────────────────────────────────┐
│ Background Primary:    ████ #272822    │
│ Background Secondary:  ████ #3E3D32    │
│ Text Primary:          ████ #F8F8F2    │
│ Accent Primary:        ████ #F92672    │
│ Success/Timer Active:  ████ #A6E22E    │
│ Warning/Timer Paused:  ████ #FD971F    │
│ Break Timer:           ████ #66D9EF    │
└────────────────────────────────────────┘
```

### Dracula Colors
```
┌────────────────────────────────────────┐
│ Background Primary:    ████ #282A36    │
│ Background Secondary:  ████ #44475A    │
│ Text Primary:          ████ #F8F8F2    │
│ Accent Primary:        ████ #FF79C6    │
│ Success/Timer Active:  ████ #50FA7B    │
│ Warning/Timer Paused:  ████ #FFB86C    │
│ Break Timer:           ████ #8BE9FD    │
└────────────────────────────────────────┘
```

---

## Animation Notes

### Timer Countdown Animation
```
Frame 1:  25:00
Frame 2:  24:59
Frame 3:  24:58
...
Updates every second
Smooth transition
```

### Session Completion Animation
```
Frame 1:  ● ● ○ ○
Frame 2:  ● ● ◉ ○  (pulse)
Frame 3:  ● ● ● ○  (filled)
Duration: ~0.5 seconds
```

### Button Hover Transition
```
Normal → Hover: 150ms ease-in-out
Color shift smooth
No jarring changes
```

---

## Edge Cases Visual Reference

### Very Long Duration Display
```
╔═══════════════════════════════════════╗
║            99:59                      ║
╚═══════════════════════════════════════╝
Maximum timer display: 99:59
Font size may need to adjust if >99 min
```

### Empty Statistics (First Use)
```
║   No sessions recorded yet            ║
║                                       ║
║   Start your first Pomodoro to        ║
║   begin tracking your productivity!   ║
```

### All Themes Selected State
```
Theme Preview:
[Monokai     ] ← Selected
[Dracula     ]
[Nord        ]
...
Highlights selected with accent color border
```

---

## Window States Summary

### Possible Timer Window States
1. ✅ Pomodoro - Active (running) → [Pause] [Reset]
2. ⏸️ Pomodoro - Paused → [Start] [Reset]
3. ✅ Short Break - Active (running) → [Stop]
4. ✅ Long Break - Active (running) → [Stop]
5. ✅ Pomodoro Completion (00:00) → [Start Break] [Skip Break]
6. ✅ Break Completion (00:00) → [Start Pomodoro]
7. ⏹️ Pomodoro - Ready to Start → [Start]

### Button Logic Rules
**During Pomodoro Sessions:**
- Active: Pause and Reset buttons
- Paused: Start and Reset buttons
- Allows full control over work session

**During Break Sessions:**
- Active: Stop button only
- No pause or reset during breaks
- Stop returns to Pomodoro ready state
- Simpler, less disruptive break experience

**At Completion:**
- Pomodoro complete: Choose to start break or skip
- Break complete: Start next Pomodoro
- Clear action prompts

### Window Behavior Rules
- Window appears: On Start/Pause/Reset/Stop action
- Window closes: User clicks [X]
- Window hides: User clicks [X] (timer continues in background)
- Window shows: User triggers from menu
- Always on Top: Only when checkbox enabled

---

## Implementation Notes for Developers

### Z-Index Layers
```
Layer 4: Modal dialogs (Settings, About)
Layer 3: Timer window (when "Always on Top" enabled)
Layer 2: Timer window (normal)
Layer 1: Background windows
Layer 0: Desktop
```

### Window Shadow
```
All windows have subtle shadow:
- X offset: 0px
- Y offset: 4px
- Blur: 12px
- Color: rgba(0, 0, 0, 0.3)
```

### Corner Radius
```
All windows:        8px
Buttons:            6px
Input fields:       4px
Dropdowns:          6px
Session dots:       50% (perfect circles)
```

### Spacing Units
```
xs:   4px   (tight spacing)
sm:   8px   (compact spacing)
md:   16px  (standard spacing)
lg:   24px  (section spacing)
xl:   32px  (major separation)
```

---

## End of UI Mockups Document

**Version:** 2.0
**Last Updated:** January 2, 2026
**Total Changes:**
- Combined Statistics and Settings into single Dashboard + Settings window
- Added sidebar navigation (Dashboard, General, Pomodoro, Sound, Appearance)
- Updated Today section with 3 horizontal cards
- Flat layout for all settings sections (removed boxes)
- Integrated About information into General settings

For implementation questions, refer to the main PRD.md document.
