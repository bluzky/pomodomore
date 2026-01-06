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

    /// Storage manager for file operations
    private let storage = StorageManager.shared

    /// Cancellables for Combine subscriptions
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Published Settings

    /// Current application settings (observable for UI updates)
    @Published var settings: Settings

    // MARK: - Initialization

    private init() {
        // Initialize with default settings
        self.settings = Settings()

        // Load settings from disk
        load()

        // Auto-save when settings change (debounced 500ms)
        $settings
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] newSettings in
                guard let self = self else { return }
                self.storage.saveSettings(newSettings)
                ConfigManager.shared.updateFromSettings(newSettings)
            }
            .store(in: &cancellables)
    }

    // MARK: - Persistence Methods

    /// Loads settings from disk
    func load() {
        if let loadedSettings = storage.loadSettings() {
            settings = loadedSettings
            // Apply settings to ConfigManager
            ConfigManager.shared.updateFromSettings(settings)
            // Load theme into ThemeManager
            ThemeManager.shared.loadTheme(named: settings.appearance.theme)
        }
    }

    // MARK: - Settings Methods

    /// Reset all settings to default values
    func resetToDefaults() {
        settings = Settings()
    }

    /// Update theme (called from AppearanceSettingsView)
    func updateTheme(_ themeName: String) {
        settings.appearance.theme = themeName
        ThemeManager.shared.loadTheme(named: themeName)
        // Settings will auto-save due to @Published binding
    }
}
