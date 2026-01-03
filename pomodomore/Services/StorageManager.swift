//
//  StorageManager.swift
//  pomodomore
//
//  Created on 01/14/26.
//

import Foundation

// MARK: - Storage Manager

/// Handles JSON file operations for settings persistence
class StorageManager {
    /// Shared singleton instance
    static let shared = StorageManager()

    private let fileManager = FileManager.default
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    // MARK: - File URLs

    /// URL for the settings JSON file
    var settingsURL: URL {
        let appSupport = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let appFolder = appSupport.appendingPathComponent("PomodoMore", isDirectory: true)
        return appFolder.appendingPathComponent("settings.json")
    }

    /// URL for the sessions JSON file
    var sessionsURL: URL {
        let appSupport = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let appFolder = appSupport.appendingPathComponent("PomodoMore", isDirectory: true)
        return appFolder.appendingPathComponent("sessions.json")
    }

    // MARK: - Initialization

    private init() {
        // Ensure app support directory exists
        ensureDirectoryExists()
    }

    // MARK: - Directory Management

    /// Creates the application support directory if it doesn't exist
    private func ensureDirectoryExists() {
        let appSupport = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let appFolder = appSupport.appendingPathComponent("PomodoMore", isDirectory: true)

        if !fileManager.fileExists(atPath: appFolder.path) {
            do {
                try fileManager.createDirectory(at: appFolder, withIntermediateDirectories: true)
            } catch {
                print("StorageManager: Failed to create app directory: \(error)")
            }
        }
    }

    // MARK: - Settings Operations

    /// Saves settings to the settings.json file
    /// - Parameter settings: The settings to save
    func saveSettings(_ settings: Settings) {
        do {
            let data = try encoder.encode(settings)
            try data.write(to: settingsURL, options: .atomic)
            print("StorageManager: Settings saved to \(settingsURL.path)")
        } catch {
            print("StorageManager: Failed to save settings: \(error)")
        }
    }

    /// Loads settings from the settings.json file
    /// - Returns: The loaded settings, or nil if loading failed
    func loadSettings() -> Settings? {
        guard fileManager.fileExists(atPath: settingsURL.path) else {
            print("StorageManager: Settings file does not exist")
            return nil
        }

        do {
            let data = try Data(contentsOf: settingsURL)
            let settings = try decoder.decode(Settings.self, from: data)
            print("StorageManager: Settings loaded successfully")
            return settings
        } catch {
            print("StorageManager: Failed to load settings: \(error)")
            return nil
        }
    }

    // MARK: - Session Operations

    /// Saves sessions to the sessions.json file
    /// - Parameter sessions: The array of sessions to save
    func saveSessions(_ sessions: [Session]) {
        do {
            let data = try encoder.encode(sessions)
            try data.write(to: sessionsURL, options: .atomic)
            print("StorageManager: Sessions saved to \(sessionsURL.path)")
        } catch {
            print("StorageManager: Failed to save sessions: \(error)")
        }
    }

    /// Loads sessions from the sessions.json file
    /// - Returns: The loaded sessions array, or empty array if file doesn't exist
    func loadSessions() -> [Session] {
        guard fileManager.fileExists(atPath: sessionsURL.path) else {
            // File doesn't exist on first launch - this is normal
            return []
        }

        do {
            let data = try Data(contentsOf: sessionsURL)
            let sessions = try decoder.decode([Session].self, from: data)
            print("StorageManager: Loaded \(sessions.count) sessions")
            return sessions
        } catch {
            print("StorageManager: Failed to load sessions: \(error)")
            return []
        }
    }
}
