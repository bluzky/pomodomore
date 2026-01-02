//
//  SettingsManager.swift
//  pomodomore
//
//  Created on 01/02/26.
//

import Foundation
import Combine

// MARK: - Settings Manager

/// Manages application settings with persistence and change notifications
@MainActor
class SettingsManager: ObservableObject {
    /// Shared singleton instance
    static let shared = SettingsManager()

    // MARK: - Published Settings

    /// Current application settings (observable for UI updates)
    @Published var settings: Settings

    // MARK: - Initialization

    private init() {
        // Initialize with default settings
        self.settings = Settings()
    }

    // MARK: - Settings Methods

    /// Reset all settings to default values
    func resetToDefaults() {
        settings = Settings()
    }

    /// Update settings (for future save/load implementation)
    func updateSettings(_ newSettings: Settings) {
        settings = newSettings
    }
}
