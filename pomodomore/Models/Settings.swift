//
//  Settings.swift
//  pomodomore
//
//  Created on 01/02/26.
//

import Foundation

// MARK: - Main Settings Model

/// Application settings with all configuration options
struct Settings: Codable {
    var version: String = "1.0"
    var general: GeneralSettings = GeneralSettings()
    var pomodoro: PomodoroSettings = PomodoroSettings()
    var sound: SoundSettings = SoundSettings()
    var appearance: AppearanceSettings = AppearanceSettings()
    var session: SessionSettings = SessionSettings()

    init(
        version: String = "1.0",
        general: GeneralSettings = GeneralSettings(),
        pomodoro: PomodoroSettings = PomodoroSettings(),
        sound: SoundSettings = SoundSettings(),
        appearance: AppearanceSettings = AppearanceSettings(),
        session: SessionSettings = SessionSettings()
    ) {
        self.version = version
        self.general = general
        self.pomodoro = pomodoro
        self.sound = sound
        self.appearance = appearance
        self.session = session
    }
}

// MARK: - General Settings

/// General application settings
struct GeneralSettings: Codable {
    var startOnLogin: Bool = false

    init(startOnLogin: Bool = false) {
        self.startOnLogin = startOnLogin
    }
}

// MARK: - Pomodoro Settings

/// Pomodoro timer configuration
struct PomodoroSettings: Codable {
    /// Pomodoro duration in seconds (default: 1500 = 25 minutes)
    var pomodoroDuration: Int = 1500

    /// Short break duration in seconds (default: 300 = 5 minutes)
    var shortBreakDuration: Int = 300

    /// Long break duration in seconds (default: 900 = 15 minutes)
    var longBreakDuration: Int = 900

    /// Number of Pomodoros before long break (default: 4)
    var longBreakInterval: Int = 4

    /// Automatically start break timer when Pomodoro completes
    var autoStartBreak: Bool = false

    /// Show completion view after sessions complete
    var showCompletionView: Bool = true

    init(
        pomodoroDuration: Int = 1500,
        shortBreakDuration: Int = 300,
        longBreakDuration: Int = 900,
        longBreakInterval: Int = 4,
        autoStartBreak: Bool = false,
        showCompletionView: Bool = true
    ) {
        self.pomodoroDuration = pomodoroDuration
        self.shortBreakDuration = shortBreakDuration
        self.longBreakDuration = longBreakDuration
        self.longBreakInterval = longBreakInterval
        self.autoStartBreak = autoStartBreak
        self.showCompletionView = showCompletionView
    }
}

// MARK: - Sound Settings

/// Sound and notification configuration
struct SoundSettings: Codable {
    /// Enable completion notifications
    var notificationsEnabled: Bool = true

    /// Completion sound from bundled resources
    var completionSound: BundledSound

    /// Tick sound option (e.g., "None", "tick 1", "tick 2")
    var tickSound: String

    /// Ambient sound option
    var ambientSound: AmbientSoundItem

    /// Enable sound button on timer to toggle tick sound
    var soundButtonEnabled: Bool = true

    init(
        notificationsEnabled: Bool = true,
        completionSound: BundledSound? = nil,
        tickSound: String = "None",
        ambientSound: AmbientSoundItem? = nil,
        soundButtonEnabled: Bool = true
    ) {
        self.notificationsEnabled = notificationsEnabled
        self.completionSound = completionSound ?? BundledSound(name: "Bell 1", fileExtension: "mp3")
        self.tickSound = tickSound
        self.ambientSound = ambientSound ?? AmbientSoundItem.none
        self.soundButtonEnabled = soundButtonEnabled
    }
}

// MARK: - Appearance Settings

/// UI appearance and theme configuration (Week 4)
/// Window size options
enum WindowSize: String, Codable, CaseIterable {
    case small = "Small"
    case tiny = "Tiny"

    var displayName: String { rawValue }
}

struct AppearanceSettings: Codable {
    /// Current theme name (Day 2 implementation - single theme for both light/dark)
    var theme: String = "Nord"

    /// Light mode theme name (Week 5 Day 5 - for future system appearance support)
    var lightTheme: String = "Nord Light"

    /// Dark mode theme name (Week 5 Day 5 - for future system appearance support)
    var darkTheme: String = "Nord Dark"

    /// Font family name
    var font: String = "Monaco"

    /// Show timer countdown in menubar
    var showTimerInMenubar: Bool = true

    /// Window size mode
    var windowSize: WindowSize = .small

    init(
        theme: String = "Nord",
        lightTheme: String = "Nord Light",
        darkTheme: String = "Nord Dark",
        font: String = "Monaco",
        showTimerInMenubar: Bool = true,
        windowSize: WindowSize = .small
    ) {
        self.theme = theme
        self.lightTheme = lightTheme
        self.darkTheme = darkTheme
        self.font = font
        self.showTimerInMenubar = showTimerInMenubar
        self.windowSize = windowSize
    }
}

// MARK: - Session Settings

/// Session-specific internal settings
struct SessionSettings: Codable {
    /// Last selected tag for quick access
    var lastSelectedTag: String = "Work"

    init(lastSelectedTag: String = "Work") {
        self.lastSelectedTag = lastSelectedTag
    }
}
