
# Product Requirements Document (PRD)
## macOS Pomodoro Timer Application

**Version:** 1.0  
**Date:** December 30, 2025  
**Status:** Draft

---

## 1. Executive Summary

A lightweight macOS menubar application implementing the Pomodoro Technique for time management. The app lives in the system tray, provides customizable work/break intervals, tracks productivity statistics, and offers ambient sound support.

---

## 2. Product Overview

### 2.1 Product Vision
Create a non-intrusive, native macOS Pomodoro timer that helps users maintain focus and track productivity without cluttering their workspace.

### 2.2 Target Users
- Knowledge workers
- Students
- Remote workers
- Anyone using the Pomodoro Technique for time management

### 2.3 Key Value Propositions
- Lives in menubar - minimal screen real estate
- Native macOS experience
- Privacy-focused (local data storage)
- Customizable to individual work styles

---

## 3. System Architecture

### 3.1 Platform
- **OS:** macOS 12.0+
- **Framework:** SwiftUI + AppKit
- **Language:** Swift 5.5+

### 3.2 App Type
- Menubar application (LSUIElement = YES)
- No dock icon
- Runs in background

---

## 4. Core Features

### 4.1 System Tray Integration

#### 4.1.1 Menubar Icon
- **Display:** Tomato icon as base icon
- **Timer Display:** When "Show timer on system tray" enabled, display countdown (MM:SS format)
- **States:** Icon remains consistent (no visual state changes for running/paused)
- **Note:** Icon design can be updated in future iterations

#### 4.1.2 Menubar Menu Structure
```
When Idle:
[Icon] ▼
├── Start
├── Reset
├── ───────────── (separator)
├── Statistics...
├── ☐ Always on Top
├── Settings...
├── ───────────── (separator)
├── About
└── Quit

When Pomodoro Running:
[Icon] ▼
├── Pause
├── Reset
├── ───────────── (separator)
├── Statistics...
├── ☐ Always on Top
├── Settings...
├── ───────────── (separator)
├── About
└── Quit

When Break Running:
[Icon] ▼
├── Stop
├── ───────────── (separator)
├── Statistics...
├── ☐ Always on Top
├── Settings...
├── ───────────── (separator)
├── About
└── Quit
```

**Menu Behaviors:**
- **Start/Pause/Stop:** 
  - Idle: "Start" - begins Pomodoro session
  - Pomodoro Running: "Pause" - pauses current Pomodoro
  - Break Running: "Stop" - ends break, returns to Pomodoro ready state
- **Reset:** Only available during Pomodoro sessions (not during breaks)
- **Always on Top:** Checkbox that keeps timer window on top when enabled
- **Menu Click:** Does NOT automatically open timer window
- **Timer Window Opens:** Only via Start/Pause/Stop/Reset actions

---

### 4.2 Timer Window

#### 4.2.1 Window Specifications
- **Size:** Small, compact (approximately 280x180 pixels)
- **Position:** User-draggable, remembers last position
- **Style:** Borderless with close button
- **Always on Top:** Controlled by menu checkbox
- **Auto-show:** Automatically appears when timer starts

#### 4.2.2 Timer Display Components
```
Pomodoro Session:
┌─────────────────────────────┐
│                       [X]   │
│                             │
│       25:00                 │
│     (countdown)             │
│                             │
│  [Pause]        [Reset]     │
│                             │
│  Completed: ○ ○ ○ ○         │
└─────────────────────────────┘

Break Session:
┌─────────────────────────────┐
│  [Session Type]       [X]   │
│                             │
│       05:00                 │
│     (countdown)             │
│                             │
│       [Stop]                │
│                             │
│  Completed: ● ○ ○ ○         │
└─────────────────────────────┘
```

**Elements:**
1. **Session Type Label**
   - Display: Only shown for breaks → "Short Break" or "Long Break"
   - Not shown during Pomodoro sessions
   
2. **Countdown Timer**
   - Format: MM:SS
   - Large, readable font
   - Updates every second
   - Color changes based on state:
     * Active Pomodoro: timer_active (green)
     * Paused Pomodoro: timer_paused (orange)
     * Active Break: timer_break (cyan)

3. **Control Buttons**
   
   **During Pomodoro:**
   - Pause: Pause current session (changes to "Start" when paused)
   - Reset: Reset current session to beginning
   
   **During Break:**
   - Stop: Stop break and return to Pomodoro ready state
   - No pause or reset during breaks (simpler break experience)

4. **Session Indicators**
   - Visual circles representing completed sessions
   - Empty circle (○): Upcoming session
   - Filled circle (●): Completed session
   - Shows up to 4 circles (one per Pomodoro before long break)
   - Reset after long break cycle

5. **Close Button [X]**
   - Closes window
   - Automatically unchecks "Always on Top" when clicked
   - Timer continues running in background

---

### 4.3 Settings Dialog

#### 4.3.1 Window Specifications
- Modal dialog window
- Organized in sections
- Save/Cancel buttons

#### 4.3.2 Timer Settings Section
```
Timer Settings
├── Pomodoro Duration: [25] minutes
├── Short Break Duration: [5] minutes
├── Long Break Duration: [15] minutes
└── Long Break Interval: [4] sessions
```

**Field Specifications:**
- Input: Number spinners or text fields
- Validation: Minimum 1 minute, maximum 60 minutes
- Default values as shown above

#### 4.3.3 Sound Settings Section
```
Sound Settings
├── ☑ Tick Sound (on/off toggle)
├── Pomodoro End Sound: [Glass ▼]
├── Break End Sound: [Glass ▼]
└── Ambient Sound: [None ▼]
```

**Sound Options:**
- **System Sounds Available:**
  - None
  - Glass
  - Ping
  - Pop
  - Sosumi
  - Tink
  - (Additional macOS system sounds)

**Sound Behaviors:**
- Tick Sound: Plays every second during active timer
- End Sounds: Play when session completes
- Ambient Sound: Loops continuously during Pomodoro sessions (work time only)
- Volume: Uses system volume settings

#### 4.3.4 Display Settings Section
```
Display Settings
├── ☑ Show Timer on System Tray
├── ☑ Auto-start Next Session
├── Theme: [Nord ▼]
└── Font: [SF Mono ▼]
```

**Behaviors:**
- Show Timer on System Tray: Displays MM:SS countdown in menubar icon
- Auto-start Next Session: Automatically begins next session after completion
- Theme: Color scheme selector with preview
  - Available themes: Nord, Monokai, Dracula, Solarized Dark, Tokyo Night, etc.
  - Default: Nord
  - Changes apply immediately
  - Dropdown shows theme name with small color preview
- Font: Monospace font selector
  - Available fonts: SF Mono, Menlo, Monaco, JetBrains Mono, Fira Code, Source Code Pro, IBM Plex Mono
  - Changes apply immediately to all text in the app
  - Preview shows font rendering in dropdown

---

### 4.4 Statistics Dialog

#### 4.4.1 Window Layout
```
┌─────────────────────────────────┐
│  Statistics                  [X]│
│                                  │
│  [◄ Prev]  Dec 23-29  [Next ►]  │
│                                  │
│  Sessions │                      │
│   20 ┤     ▄                     │
│   15 ┤     █   ▄                 │
│   10 ┤ ▄   █   █   ▄             │
│    5 ┤ █   █   █   █   ▄   ▄     │
│    0 └─┴───┴───┴───┴───┴───┴───  │
│      M   T   W   T   F   S   S   │
│                                  │
│  Total Sessions This Week: 42    │
└─────────────────────────────────┘
```

#### 4.4.2 Features
- **Bar Chart:** Shows completed sessions per day
- **Time Period:** Weekly view (Monday to Sunday)
- **Navigation:** Previous/Next week buttons
- **Current Week:** Highlighted or indicated
- **Data Display:**
  - Count of completed sessions per day
  - Total sessions for displayed week
  - X-axis: Days of week (M/T/W/T/F/S/S)
  - Y-axis: Session count

#### 4.4.3 Data Tracked
- Only completed sessions are recorded
- Incomplete or skipped sessions are NOT tracked
- Each session type recorded separately but displayed as total
- Data stored with timestamp (date + time)
- Local timezone used for day boundaries

---

### 4.5 About Dialog

Simple modal window containing:
- App name and version
- Brief description
- Copyright information
- Optional: Link to documentation/support

---

## 5. Session Flow Logic

### 5.1 Pomodoro Cycle

**Standard Flow:**
1. Pomodoro Session (25 min) → Complete
2. Short Break (5 min) → Complete
3. Pomodoro Session (25 min) → Complete
4. Short Break (5 min) → Complete
5. Pomodoro Session (25 min) → Complete
6. Short Break (5 min) → Complete
7. Pomodoro Session (25 min) → Complete
8. Long Break (15 min) → Complete
9. **Cycle Resets** → Back to step 1

### 5.2 Session Completion Behavior

**When Pomodoro Session Completes:**
- Play "Pomodoro End Sound"
- Stop ambient sound (if playing)
- Record completed session to storage
- Update session indicator circles
- Show completion message with action buttons: [Start Break] [Skip Break]
- IF "Auto-start Next Session" is ON:
  - Automatically start appropriate break
  - Show timer window if closed
- IF "Auto-start Next Session" is OFF:
  - Show notification/alert
  - Wait for user to manually start break or skip

**When Break Session Completes:**
- Play "Break End Sound"
- Record completed session to storage
- Update session indicator circles
- IF Long Break just completed:
  - Reset session counter
  - Clear session indicator circles
- Show completion message with action button: [Start Pomodoro]
- IF "Auto-start Next Session" is ON:
  - Automatically start next Pomodoro
  - Show timer window if closed
- IF "Auto-start Next Session" is OFF:
  - Show notification/alert
  - Wait for user to manually start Pomodoro

**When Stop is Pressed During Break:**
- Stop the current break timer
- Do NOT record as completed session
- Return to Pomodoro ready state (shows [Start] button)
- Timer resets to Pomodoro duration
- Session indicators remain unchanged
- User can start next Pomodoro whenever ready

### 5.3 Break Type Determination

```
Session Counter % Long Break Interval:
- If counter = 4, 8, 12, etc. → Long Break
- Otherwise → Short Break
```

**Example with Long Break Interval = 4:**
- Pomodoro 1 → Short Break
- Pomodoro 2 → Short Break
- Pomodoro 3 → Short Break
- Pomodoro 4 → **Long Break** → Counter resets
- Pomodoro 5 → Short Break
- (continues...)

### 5.4 Session Counting Rules

**What Counts as Completed:**
- ✅ Pomodoro sessions that run to 00:00
- ✅ Short break sessions that run to 00:00
- ✅ Long break sessions that run to 00:00

**What Does NOT Count:**
- ❌ Sessions manually reset before completion (Reset button during Pomodoro)
- ❌ Break sessions stopped early (Stop button during break)
- ❌ Sessions paused and never resumed
- ❌ App quit during active session

**Session Circles:**
- Display up to 4 circles (one per Pomodoro before long break)
- Break sessions that complete DO count and fill circles
- Break sessions that are stopped early do NOT fill circles
- Circles reset after long break completes

---

## 6. Data Storage

### 6.1 Storage Location
```
~/Library/Application Support/PomodoroApp/
├── settings.json
└── sessions.json
```

### 6.2 Settings File Format (settings.json)
```json
{
  "pomodoroDuration": 25,
  "shortBreakDuration": 5,
  "longBreakDuration": 15,
  "longBreakInterval": 4,
  "tickSoundEnabled": true,
  "pomodoroEndSound": "Glass",
  "breakEndSound": "Glass",
  "ambientSound": "None",
  "showTimerInTray": true,
  "autoStartNextSession": false,
  "theme": "Nord",
  "font": "SF Mono"
}
```

### 6.3 Sessions File Format (sessions.json)
```json
[
  {
    "id": "uuid-string",
    "date": "2025-12-30T14:30:00Z",
    "type": "pomodoro",
    "duration": 25
  },
  {
    "id": "uuid-string",
    "date": "2025-12-30T15:00:00Z",
    "type": "shortBreak",
    "duration": 5
  }
]
```

### 6.4 Data Privacy
- All data stored locally
- No cloud sync
- No analytics or tracking
- No network requests

---

## 7. User Interface Specifications

### 7.1 Design Principles
- **Minimalist:** Clean, distraction-free interface
- **Developer-Focused:** Code editor aesthetic with monospace typography
- **Non-intrusive:** Small footprint, optional always-on-top
- **Accessible:** Clear typography, sufficient contrast
- **Themeable:** Customizable color schemes

### 7.2 Typography

#### 7.2.1 Font Philosophy
- **Global Font:** Monospace font for entire application
- **Customizable:** User can select preferred monospace font from settings
- **Consistent:** Selected font applies to all UI elements

#### 7.2.2 Available Fonts
The app supports the following monospace fonts:

1. **SF Mono** (default) - Apple's system monospace font
   - Clean, modern design
   - Excellent readability
   - Native macOS font

2. **Menlo** - Classic macOS monospace font
   - Based on DejaVu Sans Mono
   - Slightly wider character spacing
   - Highly legible

3. **Monaco** - Traditional Mac font
   - Bitmap-like appearance
   - Compact and dense
   - Nostalgic feel

4. **JetBrains Mono** - Developer-focused font
   - Increased height for better readability
   - Distinct character shapes
   - Modern coding font

5. **Fira Code** - Monospace with programming ligatures
   - Clean, professional appearance
   - Good for long reading sessions
   - Modern design

6. **Source Code Pro** - Adobe's open-source monospace
   - Optimized for coding
   - Excellent clarity
   - Wide language support

7. **IBM Plex Mono** - IBM's corporate monospace
   - Neutral and professional
   - Great legibility
   - Corporate aesthetic

**Font Installation:**
- SF Mono, Menlo, Monaco: Built into macOS
- JetBrains Mono, Fira Code, Source Code Pro, IBM Plex Mono: 
  - If installed on system, available in dropdown
  - If not installed, greyed out with "(Not Installed)" label
  - Dropdown only shows installed fonts
  - User can install additional fonts system-wide

#### 7.2.3 Font Sizes
- Timer Display: 48pt (bold)
- Section Headers: 14pt (semibold)
- Body Text/Labels: 12pt (regular)
- Button Text: 12pt (medium)
- Menu Items: 13pt (regular)
- Menubar Timer: 12pt (regular)

#### 7.2.4 Font Weight Usage
- Regular: Body text, labels, standard UI
- Medium: Buttons, emphasized text
- Semibold: Section headers, titles
- Bold: Timer display, critical information

### 7.3 Theme System

#### 7.3.1 Available Themes
The app includes code editor-inspired themes:
1. **Nord** (default)
2. **Monokai**
3. **Dracula**
4. **Solarized Dark**
5. **Tokyo Night**
6. **Gruvbox Dark**
7. **One Dark**
8. **Catppuccin Mocha**
9. **GitHub Dark**
10. **Solarized Light** (light theme option)

#### 7.3.2 Theme Color Variables

Each theme defines the following color variables:

```
Theme Color Variables:
├── background_primary       // Main window background
├── background_secondary     // Secondary elements (cards, panels)
├── background_tertiary      // Hover states, subtle backgrounds
├── text_primary            // Main text color
├── text_secondary          // Secondary text, labels
├── text_muted              // Disabled or de-emphasized text
├── accent_primary          // Primary accent (buttons, highlights)
├── accent_secondary        // Secondary accent
├── border_primary          // Main borders
├── border_secondary        // Subtle borders, dividers
├── success                 // Completed sessions, success states
├── warning                 // Warnings, break indicators
├── error                   // Errors, destructive actions
├── timer_active            // Active timer color
├── timer_paused            // Paused timer color
├── timer_break             // Break session timer color
├── session_complete        // Completed session circle fill
├── session_incomplete      // Incomplete session circle outline
└── shadow                  // Drop shadows, elevation
```

#### 7.3.3 Theme Definitions

**Monokai Theme (Default):**
```
background_primary:      #272822
background_secondary:    #3E3D32
background_tertiary:     #49483E
text_primary:            #F8F8F2
text_secondary:          #CFCFC2
text_muted:              #75715E
accent_primary:          #F92672
accent_secondary:        #66D9EF
border_primary:          #49483E
border_secondary:        #3E3D32
success:                 #A6E22E
warning:                 #FD971F
error:                   #F92672
timer_active:            #A6E22E
timer_paused:            #FD971F
timer_break:             #66D9EF
session_complete:        #A6E22E
session_incomplete:      #75715E
shadow:                  #00000040
```

**Dracula Theme:**
```
background_primary:      #282A36
background_secondary:    #44475A
background_tertiary:     #6272A4
text_primary:            #F8F8F2
text_secondary:          #BFBFBF
text_muted:              #6272A4
accent_primary:          #FF79C6
accent_secondary:        #BD93F9
border_primary:          #44475A
border_secondary:        #6272A4
success:                 #50FA7B
warning:                 #FFB86C
error:                   #FF5555
timer_active:            #50FA7B
timer_paused:            #FFB86C
timer_break:             #8BE9FD
session_complete:        #50FA7B
session_incomplete:      #6272A4
shadow:                  #00000050
```

**Nord Theme:**
```
background_primary:      #2E3440
background_secondary:    #3B4252
background_tertiary:     #434C5E
text_primary:            #ECEFF4
text_secondary:          #D8DEE9
text_muted:              #616E88
accent_primary:          #88C0D0
accent_secondary:        #81A1C1
border_primary:          #434C5E
border_secondary:        #3B4252
success:                 #A3BE8C
warning:                 #EBCB8B
error:                   #BF616A
timer_active:            #A3BE8C
timer_paused:            #EBCB8B
timer_break:             #88C0D0
session_complete:        #A3BE8C
session_incomplete:      #4C566A
shadow:                  #00000040
```

**Solarized Dark Theme:**
```
background_primary:      #002B36
background_secondary:    #073642
background_tertiary:     #094149
text_primary:            #FDF6E3
text_secondary:          #EEE8D5
text_muted:              #586E75
accent_primary:          #268BD2
accent_secondary:        #2AA198
border_primary:          #073642
border_secondary:        #094149
success:                 #859900
warning:                 #B58900
error:                   #DC322F
timer_active:            #859900
timer_paused:            #B58900
timer_break:             #2AA198
session_complete:        #859900
session_incomplete:      #586E75
shadow:                  #00000030
```

**Tokyo Night Theme:**
```
background_primary:      #1A1B26
background_secondary:    #24283B
background_tertiary:     #414868
text_primary:            #C0CAF5
text_secondary:          #A9B1D6
text_muted:              #565F89
accent_primary:          #7AA2F7
accent_secondary:        #BB9AF7
border_primary:          #24283B
border_secondary:        #414868
success:                 #9ECE6A
warning:                 #E0AF68
error:                   #F7768E
timer_active:            #9ECE6A
timer_paused:            #E0AF68
timer_break:             #7DCFFF
session_complete:        #9ECE6A
session_incomplete:      #565F89
shadow:                  #00000050
```

**Gruvbox Dark Theme:**
```
background_primary:      #282828
background_secondary:    #3C3836
background_tertiary:     #504945
text_primary:            #EBDBB2
text_secondary:          #D5C4A1
text_muted:              #928374
accent_primary:          #FB4934
accent_secondary:        #B16286
border_primary:          #3C3836
border_secondary:        #504945
success:                 #B8BB26
warning:                 #FABD2F
error:                   #FB4934
timer_active:            #B8BB26
timer_paused:            #FABD2F
timer_break:             #83A598
session_complete:        #B8BB26
session_incomplete:      #665C54
shadow:                  #00000040
```

**One Dark Theme:**
```
background_primary:      #282C34
background_secondary:    #21252B
background_tertiary:     #2C313C
text_primary:            #ABB2BF
text_secondary:          #828997
text_muted:              #5C6370
accent_primary:          #61AFEF
accent_secondary:        #C678DD
border_primary:          #181A1F
border_secondary:        #2C313C
success:                 #98C379
warning:                 #E5C07B
error:                   #E06C75
timer_active:            #98C379
timer_paused:            #E5C07B
timer_break:             #56B6C2
session_complete:        #98C379
session_incomplete:      #5C6370
shadow:                  #00000050
```

**Catppuccin Mocha Theme:**
```
background_primary:      #1E1E2E
background_secondary:    #313244
background_tertiary:     #45475A
text_primary:            #CDD6F4
text_secondary:          #BAC2DE
text_muted:              #6C7086
accent_primary:          #F5C2E7
accent_secondary:        #CBA6F7
border_primary:          #313244
border_secondary:        #45475A
success:                 #A6E3A1
warning:                 #F9E2AF
error:                   #F38BA8
timer_active:            #A6E3A1
timer_paused:            #FAB387
timer_break:             #89DCEB
session_complete:        #A6E3A1
session_incomplete:      #6C7086
shadow:                  #00000060
```

**GitHub Dark Theme:**
```
background_primary:      #0D1117
background_secondary:    #161B22
background_tertiary:     #21262D
text_primary:            #C9D1D9
text_secondary:          #8B949E
text_muted:              #6E7681
accent_primary:          #58A6FF
accent_secondary:        #1F6FEB
border_primary:          #30363D
border_secondary:        #21262D
success:                 #3FB950
warning:                 #D29922
error:                   #F85149
timer_active:            #3FB950
timer_paused:            #D29922
timer_break:             #79C0FF
session_complete:        #3FB950
session_incomplete:      #484F58
shadow:                  #00000070
```

**Solarized Light Theme:**
```
background_primary:      #FDF6E3
background_secondary:    #EEE8D5
background_tertiary:     #E4DCC5
text_primary:            #002B36
text_secondary:          #073642
text_muted:              #93A1A1
accent_primary:          #268BD2
accent_secondary:        #2AA198
border_primary:          #EEE8D5
border_secondary:        #E4DCC5
success:                 #859900
warning:                 #B58900
error:                   #DC322F
timer_active:            #859900
timer_paused:            #B58900
timer_break:             #2AA198
session_complete:        #859900
session_incomplete:      #93A1A1
shadow:                  #00000015
```

#### 7.3.4 Theme Selection
- Available in Settings dialog
- Dropdown menu with theme previews
- Changes apply immediately (no restart required)
- Theme preference persists across app restarts

#### 7.3.5 Theme Application
```
UI Element Mapping:
├── Timer Window Background → background_primary
├── Settings Dialog Background → background_primary
├── Statistics Window Background → background_primary
├── Panel/Card Backgrounds → background_secondary
├── Hover Effects → background_tertiary
├── Timer Display → timer_active/timer_paused/timer_break
├── Control Buttons → accent_primary (with hover: accent_secondary)
├── Session Circles (filled) → session_complete
├── Session Circles (empty) → session_incomplete
├── Window Borders → border_primary
├── Dividers → border_secondary
├── Statistics Bars → accent_primary
└── Success Messages → success
```

### 7.4 Dark/Light Mode
- All themes are designed for dark mode aesthetics
- Solarized Light can be added as a light theme option
- System appearance switching: Not applicable (fixed theme-based approach)
- Users explicitly choose their preferred theme

### 7.5 UI Mockups with Theming

#### 7.5.1 Timer Window (Nord Theme)
```
╔═══════════════════════════════════╗
║ Short Break              [X]      ║
║                                   ║
║          05:00                    ║
║     (timer_break color)           ║
║                                   ║
║  [Start] [Pause] [Reset]          ║
║  (accent_primary buttons)         ║
║                                   ║
║  Completed: ● ● ● ○               ║
║  (session_complete/incomplete)    ║
╚═══════════════════════════════════╝
Colors: #2E3440 bg, #88C0D0 timer, #ECEFF4 text
Font: SF Mono 12pt (body), 48pt (timer)
```

#### 7.5.2 Settings Dialog (Nord Theme)
```
╔═════════════════════════════════════════╗
║ Settings                        [X]     ║
║                                         ║
║ Timer Settings                          ║
║ ┌─────────────────────────────────────┐ ║
║ │ Pomodoro Duration:    [25] min      │ ║
║ │ Short Break:          [5] min       │ ║
║ │ Long Break:           [15] min      │ ║
║ │ Long Break Interval:  [4] sessions  │ ║
║ └─────────────────────────────────────┘ ║
║                                         ║
║ Sound Settings                          ║
║ ┌─────────────────────────────────────┐ ║
║ │ [✓] Tick Sound                      │ ║
║ │ Pomodoro End:    [Glass      ▼]    │ ║
║ │ Break End:       [Glass      ▼]    │ ║
║ │ Ambient Sound:   [None       ▼]    │ ║
║ └─────────────────────────────────────┘ ║
║                                         ║
║ Display Settings                        ║
║ ┌─────────────────────────────────────┐ ║
║ │ [✓] Show Timer on System Tray       │ ║
║ │ [ ] Auto-start Next Session         │ ║
║ │ Theme:           [Nord       ▼]    │ ║
║ │ Font:            [SF Mono    ▼]    │ ║
║ └─────────────────────────────────────┘ ║
║                                         ║
║              [Cancel]  [Save]           ║
╚═════════════════════════════════════════╝
Colors: #2E3440 bg, #3B4252 panels, #ECEFF4 text
Font: SF Mono 12pt throughout
```

#### 7.5.3 Statistics Window (Nord Theme)
```
╔═════════════════════════════════════════╗
║ Statistics                      [X]     ║
║                                         ║
║    [◄]    Dec 23 - 29, 2025    [►]     ║
║                                         ║
║  Sessions                               ║
║   20 │                                  ║
║   15 │        ███                       ║
║   10 │   ███  ███  ███                  ║
║    5 │   ███  ███  ███  ███  ███  ███   ║
║    0 └───┴────┴────┴────┴────┴────┴──── ║
║       Mon  Tue  Wed  Thu  Fri  Sat  Sun ║
║                                         ║
║  Total Sessions This Week: 42           ║
║                                         ║
║                           [Close]       ║
╚═════════════════════════════════════════╝
Colors: #2E3440 bg, #88C0D0 bars, #ECEFF4 text
Font: SF Mono 12pt throughout
```

#### 7.5.4 Menubar Display
```
System Tray: [🍅] 24:35 ▼

With Timer Hidden: [🍅] ▼

Menu Expanded:
┌─────────────────────┐
│ Start               │
│ Reset               │
│ ─────────────────── │
│ Statistics...       │
│ ☑ Always on Top     │
│ Settings...         │
│ ─────────────────── │
│ About               │
│ Quit                │
└─────────────────────┘
Font: SF Mono 12pt (timer), 13pt (menu)
```

#### 7.5.5 Font Selector Dropdown
```
Font: [SF Mono         ▼]

When expanded:
┌──────────────────────────┐
│ SF Mono                  │ ← Currently selected
│ Menlo                    │
│ Monaco                   │
│ JetBrains Mono           │
│ Fira Code                │
│ Source Code Pro          │
│ IBM Plex Mono            │
└──────────────────────────┘

Each font name rendered in its own font
Note: Only installed fonts appear in list
```

---

## 8. Technical Requirements

### 8.1 Performance
- **CPU Usage:** Minimal when idle, <1% average
- **Memory:** <50 MB footprint
- **Launch Time:** <2 seconds to menubar ready
- **Timer Accuracy:** Within 100ms per minute

### 8.2 Compatibility
- macOS 12.0 (Monterey) minimum
- Native Apple Silicon and Intel support
- Works across multiple displays

### 8.3 Notifications
- macOS notification when session completes
- Sound plays regardless of notification settings
- User can click notification to show timer window

### 8.4 Window Management
- Remembers last window position
- Gracefully handles display disconnection
- Window visible on current active space

---

## 9. User Scenarios

### 9.1 First Time User
1. App launches to menubar
2. Uses default settings: Nord theme, SF Mono font
3. User clicks icon → sees menu
4. User clicks "Start" → Timer window appears
5. Timer begins counting down from 25:00
6. At 00:00, sound plays, notification shows
7. User can start break or continue working
8. User may explore Settings to customize theme and font

### 9.2 Experienced User with Always-on-Top
1. User enables "Always on Top" from menu
2. Timer window stays above all other windows
3. User can work while glancing at timer
4. User closes window with [X] button when done
5. Always-on-top automatically disabled

### 9.3 Statistics Review
1. User clicks "Statistics..." from menu
2. Window shows current week's productivity
3. User navigates through previous weeks
4. User sees patterns in their work habits
5. User closes window

---

## 10. Edge Cases & Error Handling

### 10.1 System Sleep/Wake
- **Behavior:** Pause timer during sleep
- **Resume:** Ask user if they want to continue or reset

### 10.2 Date Change During Session
- **Behavior:** Complete session normally
- **Recording:** Use session start date for statistics

### 10.3 Settings Changed During Active Session
- **Behavior:** Apply new settings to next session
- **Current Session:** Complete with original duration

### 10.4 Invalid Settings Input
- **Validation:** Prevent saving invalid values
- **User Feedback:** Show error message
- **Fallback:** Revert to last valid settings

### 10.5 Storage Errors
- **Cannot Read:** Use default settings
- **Cannot Write:** Show warning, continue in-memory
- **Corrupted Data:** Reset to defaults, backup old file

### 10.6 Font Availability
- **Saved Font Not Installed:** 
  - Fallback to SF Mono (default)
  - Show info message in settings: "Previously selected font '[Font Name]' not available. Using SF Mono."
  - Do not update settings file (preserve user preference)
- **No Monospace Fonts Available:** 
  - Use system monospace (fallback to Courier)
  - Should not occur on standard macOS installation

---

## 11. Future Enhancements (Out of Scope for v1.0)

### 11.1 Potential Features
- Custom timer durations per session
- Multiple pomodoro profiles
- Keyboard shortcuts
- Statistics export (CSV/PDF)
- Monthly/yearly statistics views
- Integration with calendar apps
- Custom sound file support
- **Custom theme creation/import**
- **Theme sharing/marketplace**
- **Font size customization per UI element**
- **Support for non-monospace fonts (optional)**
- **Font weight customization**
- Timer themes/skins
- Break reminders/stretching exercises
- Focus mode integration (macOS)
- iCloud sync across devices
- iOS companion app

### 11.2 Analytics (If Implemented)
- Opt-in only
- Anonymous usage statistics
- No personal data collection

---

## 12. Success Metrics

### 12.1 Key Performance Indicators (KPIs)
- Daily active users
- Average sessions per day per user
- User retention rate (7-day, 30-day)
- Average session duration adherence

### 12.2 User Satisfaction Metrics
- App crashes/bugs reported
- Feature requests
- User reviews/ratings
- Support ticket volume

---

## 13. Development Phases

### Phase 1: MVP (v1.0)
- ✅ All core features from this PRD
- ✅ Basic error handling
- ✅ Local storage
- ✅ Statistics (weekly view)

### Phase 2: Polish (v1.1)
- Enhanced UI/animations
- Additional system sounds
- Improved notification handling
- Bug fixes from user feedback

### Phase 3: Advanced Features (v2.0)
- Selected items from Future Enhancements
- Based on user feedback and demand

---

## 14. Acceptance Criteria

### 14.1 Core Functionality
- [ ] App launches and appears in menubar
- [ ] Timer counts down accurately
- [ ] Sessions complete and trigger sounds
- [ ] Settings persist across app restarts
- [ ] Statistics accurately reflect completed sessions
- [ ] Always-on-top works correctly
- [ ] Window position is remembered

### 14.2 User Experience
- [ ] UI is intuitive without documentation
- [ ] No crashes during normal operation
- [ ] Smooth transitions between sessions
- [ ] Clear visual feedback for all actions
- [ ] Monospace font renders correctly throughout app
- [ ] Font changes apply immediately without restart
- [ ] All available fonts render properly and are legible
- [ ] Font dropdown only shows installed fonts
- [ ] Theme changes apply immediately without restart
- [ ] All themes are visually distinct and readable
- [ ] Color contrast meets accessibility standards

### 14.3 Technical
- [ ] Works on macOS 12.0+
- [ ] No memory leaks
- [ ] Handles system sleep/wake
- [ ] Data persists correctly

---

## 15. Glossary

- **Pomodoro:** 25-minute focused work session (default)
- **Session:** Generic term for pomodoro or break period
- **Cycle:** Complete sequence ending with long break
- **Menubar/System Tray:** Top bar in macOS where app icon lives
- **Always on Top:** Window stays above all other windows
- **Session Indicator:** Visual circles showing completed sessions

---

## 16. Appendix

### 16.1 Design References
- macOS Human Interface Guidelines
- Existing Pomodoro apps (for feature comparison)
- User feedback from beta testing

### 16.2 Technical Resources
- SwiftUI documentation
- macOS AppKit integration
- UserDefaults/JSON storage patterns

---

**Document Approvals:**

| Role | Name | Date | Signature |
|------|------|------|-----------|
| Product Owner | | | |
| Technical Lead | | | |
| Designer | | | |

---

**Revision History:**

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2025-12-30 | Initial | Complete PRD created |
