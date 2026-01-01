//
//  ConfigManager.swift
//  pomodomore
//
//  Created on 01/08/25.
//

import Foundation
import Combine

/// Manages application configuration and settings
@MainActor
class ConfigManager: ObservableObject {
    /// Shared singleton instance
    static let shared = ConfigManager()

    // MARK: - Session Duration Settings

    /// Duration for Pomodoro sessions in seconds (default: 25 minutes)
    @Published var pomodoroDuration: Int = 1500

    /// Duration for short break sessions in seconds (default: 5 minutes)
    @Published var shortBreakDuration: Int = 300

    /// Duration for long break sessions in seconds (default: 15 minutes)
    @Published var longBreakDuration: Int = 900

    // MARK: - Initialization

    private init() {
        // Private initializer to enforce singleton pattern
    }

    // MARK: - Convenience Methods

    /// Get duration for a specific session type
    func duration(for sessionType: SessionType) -> Int {
        switch sessionType {
        case .pomodoro:
            return pomodoroDuration
        case .shortBreak:
            return shortBreakDuration
        case .longBreak:
            return longBreakDuration
        }
    }

    /// Reset all durations to default values
    func resetToDefaults() {
        pomodoroDuration = 1500  // 25 minutes
        shortBreakDuration = 300  // 5 minutes
        longBreakDuration = 900   // 15 minutes
    }

    // MARK: - Testing Support

    /// Set test durations for faster testing (all values in seconds)
    func setTestDurations(pomodoro: Int = 10, shortBreak: Int = 5, longBreak: Int = 8) {
        pomodoroDuration = pomodoro
        shortBreakDuration = shortBreak
        longBreakDuration = longBreak
    }
}
