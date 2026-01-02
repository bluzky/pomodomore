//
//  ConfigManager.swift
//  pomodomore
//
//  Created on 01/08/25.
//

import Foundation
import Combine

// MARK: - Session Durations Configuration

/// Non-isolated configuration for session durations
struct SessionDurations: Sendable {
    let pomodoroDuration: Int
    let shortBreakDuration: Int
    let longBreakDuration: Int

    /// Default production durations
    static let defaultDurations = SessionDurations(
        pomodoroDuration: 1500,   // 25 minutes
        shortBreakDuration: 300,   // 5 minutes
        longBreakDuration: 900     // 15 minutes
    )

    /// Test durations for faster manual/automated testing
    static let testDurations = SessionDurations(
        pomodoroDuration: 10,   // 10 seconds
        shortBreakDuration: 5,   // 5 seconds
        longBreakDuration: 8     // 8 seconds
    )

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
}

// MARK: - Configuration Manager

/// Manages application configuration and settings
@MainActor
class ConfigManager: ObservableObject {
    /// Shared singleton instance
    static let shared = ConfigManager()

    // MARK: - Published Configuration

    /// Current session durations (observable for UI updates)
    @Published private(set) var durations: SessionDurations = .defaultDurations

    // MARK: - Initialization

    private init() {
        // Private initializer to enforce singleton pattern
    }

    // MARK: - Configuration Methods

    /// Update session durations
    func setDurations(_ newDurations: SessionDurations) {
        durations = newDurations
    }

    /// Reset all durations to default values
    func resetToDefaults() {
        durations = .defaultDurations
    }

    /// Set test durations for faster testing
    func setTestDurations() {
        durations = .testDurations
    }

    /// Set custom durations (all values in seconds)
    func setCustomDurations(pomodoro: Int, shortBreak: Int, longBreak: Int) {
        durations = SessionDurations(
            pomodoroDuration: pomodoro,
            shortBreakDuration: shortBreak,
            longBreakDuration: longBreak
        )
    }
}
