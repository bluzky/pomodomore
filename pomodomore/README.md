# PomodoMore - Source Code Structure

Clean and maintainable folder organization for the PomodoMore codebase.

## 📁 Directory Structure

```
pomodomore/
├── App/                        # Application entry point and lifecycle
│   ├── AppDelegate.swift       # macOS app delegate (menubar, window management)
│   └── PomodomoreApp.swift     # SwiftUI app entry point
│
├── Models/                     # Data models and types
│   ├── Session.swift           # Completed Pomodoro session model
│   ├── SessionTag.swift        # Session categorization (Work, Study, etc.)
│   ├── SessionType.swift       # Session types (Pomodoro, Short/Long Break)
│   ├── Settings.swift          # Application settings model (Codable)
│   └── TimerState.swift        # Timer state enum (idle, running, paused, completed)
│
├── Views/                      # SwiftUI views
│   ├── Timer/                  # Timer-related views
│   │   ├── TimerView.swift         # Main timer display with controls
│   │   ├── TimerWindow.swift       # Timer window configuration
│   │   └── SessionIndicatorsView.swift  # Session progress dots (○○○●)
│   │
│   └── Dashboard/              # Dashboard and Settings views
│       ├── DashboardSettingsView.swift  # Main window with sidebar navigation
│       ├── DashboardView.swift          # Today stats + weekly chart
│       ├── GeneralSettingsView.swift    # General settings (startup, about)
│       ├── PomodoroSettingsView.swift   # Pomodoro timer configuration
│       └── SoundSettingsView.swift      # Sound and notification settings
│
├── ViewModels/                 # View models and business logic
│   └── TimerViewModel.swift    # Timer state management and logic
│
├── Services/                   # Application services and managers
│   ├── ConfigManager.swift     # Session duration configuration
│   ├── SettingsManager.swift   # Settings state management (ObservableObject)
│   └── WindowManager.swift     # Window lifecycle and positioning
│
├── Assets.xcassets/            # Images, colors, and other assets
└── Info.plist                  # Application configuration
```

## 🏗️ Architecture

### Models
Pure Swift structs and enums representing data. All models conform to `Codable` for persistence.

### Views
SwiftUI views organized by feature:
- **Timer**: Core Pomodoro timer interface
- **Dashboard**: Statistics dashboard and settings panels

### ViewModels
`@MainActor` classes that manage state and business logic for views. Follow the `ObservableObject` pattern.

### Services
Singleton services that manage app-wide concerns:
- **ConfigManager**: Global timer configuration
- **SettingsManager**: User preferences state
- **WindowManager**: Window positioning and lifecycle

### App
Application entry point and macOS-specific lifecycle management.

## 📝 Naming Conventions

- **Models**: Singular nouns (`Session`, `Settings`)
- **Views**: Descriptive + "View" suffix (`TimerView`, `DashboardView`)
- **ViewModels**: Descriptive + "ViewModel" suffix (`TimerViewModel`)
- **Services**: Descriptive + "Manager" suffix (`SettingsManager`, `WindowManager`)

## 🔄 Data Flow

```
User Interaction → View → ViewModel → Service/Manager → Model
                    ↑                                      ↓
                    └──────── @Published updates ─────────┘
```

## 📦 Dependencies

- **SwiftUI**: UI framework
- **Combine**: Reactive state management
- **AppKit/Cocoa**: macOS-specific features (menubar, windows)

---

**Last Updated**: January 2, 2026
