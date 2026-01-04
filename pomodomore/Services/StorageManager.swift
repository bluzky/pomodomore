//
//  StorageManager.swift
//  pomodomore
//
//  Created on 01/14/26.
//

import Foundation

#if DEBUG
private let isDebug = true
#else
private let isDebug = false
#endif

// MARK: - Storage Manager

/// Handles JSON file operations for settings persistence
class StorageManager {
    /// Shared singleton instance
    static let shared = StorageManager()

    private let fileManager = FileManager.default
    private let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return encoder
    }()
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()

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
                if isDebug { print("StorageManager: Failed to create app directory: \(error)") }
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
            if isDebug { print("StorageManager: Settings saved to \(settingsURL.path)") }
        } catch {
            if isDebug { print("StorageManager: Failed to save settings: \(error)") }
        }
    }

    /// Loads settings from the settings.json file
    /// - Returns: The loaded settings, or nil if loading failed
    func loadSettings() -> Settings? {
        guard fileManager.fileExists(atPath: settingsURL.path) else {
            if isDebug { print("StorageManager: Settings file does not exist") }
            return nil
        }

        do {
            let data = try Data(contentsOf: settingsURL)
            let settings = try decoder.decode(Settings.self, from: data)
            if isDebug { print("StorageManager: Settings loaded successfully") }
            return settings
        } catch {
            if isDebug { print("StorageManager: Failed to load settings: \(error)") }
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
            if isDebug { print("StorageManager: Sessions saved to \(sessionsURL.path)") }
        } catch {
            if isDebug { print("StorageManager: Failed to save sessions: \(error)") }
        }
    }

    /// Loads sessions from the sessions.json file
    /// - Returns: The loaded sessions array, or empty array if file doesn't exist
    func loadSessions() -> [Session] {
        if isDebug { print("💾 StorageManager.loadSessions() - Looking for file at: \(sessionsURL.path)") }

        guard fileManager.fileExists(atPath: sessionsURL.path) else {
            if isDebug { print("❌ StorageManager: Sessions file does not exist at path: \(sessionsURL.path)") }

            // Check if file exists in other common locations
            let altPath = sessionsURL.deletingLastPathComponent().deletingLastPathComponent().appendingPathComponent("Pomodomore/sessions.json")
            if fileManager.fileExists(atPath: altPath.path) {
                if isDebug { print("⚠️ Found sessions at alternate path: \(altPath.path)") }
            }

            return []
        }

        do {
            let data = try Data(contentsOf: sessionsURL)
            if isDebug { print("✅ StorageManager: Read \(data.count) bytes from file") }

            let sessions = try decoder.decode([Session].self, from: data)
            if isDebug { print("✅ StorageManager: Successfully decoded \(sessions.count) sessions") }
            return sessions
        } catch {
            if isDebug { print("❌ StorageManager: Failed to load sessions: \(error)") }
            if let decodingError = error as? DecodingError {
                if isDebug { print("   Decoding error details: \(decodingError)") }
            }
            return []
        }
    }
}
