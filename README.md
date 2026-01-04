# PomodoMore

A lightweight, privacy-focused macOS menubar application for the Pomodoro Technique. Built with SwiftUI and designed for developers who want a non-intrusive, customizable time management tool.

## Application

### Features
- **Core Timer**: 25-minute Pomodoro sessions with configurable breaks (5 min short, 15 min long)
- **10 Developer Themes**: Nord, Monokai, Dracula, Tokyo Night, Gruvbox, One Dark, Catppuccin, GitHub Dark, Solarized Dark/Light
- **Monospace Fonts**: SF Mono, Menlo, Monaco, JetBrains Mono, Fira Code, Source Code Pro, IBM Plex Mono
- **Productivity Tracking**: Weekly statistics with bar charts, local-only session history
- **Sound & Notifications**: Tick sound, customizable completion sounds, ambient sound support
- **Privacy First**: All data stored locally, no cloud sync, no analytics, no network requests

### Requirements
- macOS 12.0 (Monterey) or later
- Apple Silicon or Intel Mac

### Usage
1. Click the PomodoMore icon in your menubar
2. Select "Start" to begin a Pomodoro session
3. Timer window appears with countdown
4. At completion, choose to start break or continue working
5. Access Statistics and Settings from menubar menu

Session flow: Work (25m) → Short Break (5m) × 3 → Work (25m) → Long Break (15m) → Repeat

## Development

### Project Structure
```
pomodomore/
├── App/                    # Application entry point and lifecycle
├── Models/                 # Data models (Session, Settings, TimerState)
├── Views/                  # SwiftUI views (Timer, Dashboard, Settings)
├── ViewModels/             # Business logic (TimerViewModel)
├── Services/               # App services (Storage, Sound, Window, Settings)
└── Assets.xcassets/        # Images and colors
```

### Architecture
- **Pattern**: MVVM (Model-View-ViewModel)
- **Framework**: SwiftUI + AppKit (hybrid for menubar)
- **State Management**: Combine with @Published properties
- **Persistence**: JSON files (~/Library/Application Support/PomodoMore/)
- **Audio**: AVFoundation

### Building
Requirements: Xcode 14.0+, Swift 5.5+, macOS 12.0+ deployment target

```bash
# Clone and build
git clone https://github.com/yourusername/pomodomore.git
cd pomodomore
open pomodomore.xcodeproj

# Run tests
xcodebuild test -scheme pomodomore

# Build for release
xcodebuild -scheme pomodomore -configuration Release
```

### Contributing
This project follows the Solo Dev + AI methodology (see [dev_start.md](./dev_start.md)).

Guidelines:
- Follow existing code style and architecture
- Add tests for new features
- Ensure build has 0 errors and 0 warnings
- Test on macOS 12.0+ before submitting

See [pomodomore/README.md](./pomodomore/README.md) for detailed architecture documentation.

---

**Made with focus by developers, for developers.**
