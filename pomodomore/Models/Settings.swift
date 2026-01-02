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

    /// Automatically start next session when current completes
    var autoStartNextSession: Bool = false

    init(
        pomodoroDuration: Int = 1500,
        shortBreakDuration: Int = 300,
        longBreakDuration: Int = 900,
        longBreakInterval: Int = 4,
        autoStartNextSession: Bool = false
    ) {
        self.pomodoroDuration = pomodoroDuration
        self.shortBreakDuration = shortBreakDuration
        self.longBreakDuration = longBreakDuration
        self.longBreakInterval = longBreakInterval
        self.autoStartNextSession = autoStartNextSession
    }
}

// MARK: - Sound Settings

/// Sound and notification configuration
struct SoundSettings: Codable {
    /// Enable completion notifications
    var notificationsEnabled: Bool = true

    /// Tick sound option (e.g., "None", "Tick 1", "Tick 2")
    var tickSound: String = "None"

    /// Ambient sound option (e.g., "None", "Rain", "Forest")
    var ambientSound: String = "None"

    init(
        notificationsEnabled: Bool = true,
        tickSound: String = "None",
        ambientSound: String = "None"
    ) {
        self.notificationsEnabled = notificationsEnabled
        self.tickSound = tickSound
        self.ambientSound = ambientSound
    }
}

// MARK: - Appearance Settings

/// UI appearance and theme configuration (Week 4)
struct AppearanceSettings: Codable {
    /// Light mode theme name
    var lightTheme: String = "Nord Light"

    /// Dark mode theme name
    var darkTheme: String = "Nord Dark"

    /// Font family name
    var font: String = "SF Mono"

    /// Show timer countdown in menubar
    var showTimerInMenubar: Bool = true

    init(
        lightTheme: String = "Nord Light",
        darkTheme: String = "Nord Dark",
        font: String = "SF Mono",
        showTimerInMenubar: Bool = true
    ) {
        self.lightTheme = lightTheme
        self.darkTheme = darkTheme
        self.font = font
        self.showTimerInMenubar = showTimerInMenubar
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
