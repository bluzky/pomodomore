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

    /// Loads settings from the settings.json file with migration support
    /// - Returns: The loaded settings, or nil if loading failed
    func loadSettings() -> Settings? {
        guard fileManager.fileExists(atPath: settingsURL.path) else {
            print("StorageManager: Settings file does not exist")
            return nil
        }

        do {
            let data = try Data(contentsOf: settingsURL)

            // First try normal decoding
            if let settings = try? decoder.decode(Settings.self, from: data) {
                print("StorageManager: Settings loaded successfully")
                return settings
            }

            // If normal decoding fails, try to migrate old settings
            print("StorageManager: Attempting to migrate old settings format...")
            if let migratedSettings = migrateSettings(data: data) {
                // Save migrated settings
                saveSettings(migratedSettings)
                print("StorageManager: Settings migrated successfully")
                return migratedSettings
            }

            print("StorageManager: Failed to load settings: migration failed")
            return nil
        } catch {
            print("StorageManager: Failed to load settings: \(error)")
            return nil
        }
    }

    /// Migrates old settings format to new format
    private func migrateSettings(data: Data) -> Settings? {
        // Create a decoder that handles the old format
        let decoder = JSONDecoder()

        // Try to decode with custom key path strategy for ambientSound
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data),
              var jsonDict = jsonObject as? [String: Any] else {
            return nil
        }

        // Migrate old ambient sound values to new enum values
        let ambientMigration: [String: String] = [
            "Rain": "Spring Rain",
            "White Noise": "Water Stream",
            "Cafe": "Morning Forest",
            "Forest": "Morning Forest",
            "Ocean": "Ocean Wave"
        ]

        if let oldAmbient = jsonDict["ambientSound"] as? String,
           let newAmbient = ambientMigration[oldAmbient] {
            jsonDict["ambientSound"] = newAmbient
            print("StorageManager: Migrated ambientSound from '\(oldAmbient)' to '\(newAmbient)'")
        }

        // Re-serialize and decode
        guard let newData = try? JSONSerialization.data(withJSONObject: jsonDict) else {
            return nil
        }

        return try? decoder.decode(Settings.self, from: newData)
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
        print("💾 StorageManager.loadSessions() - Looking for file at: \(sessionsURL.path)")

        guard fileManager.fileExists(atPath: sessionsURL.path) else {
            print("❌ StorageManager: Sessions file does not exist at path: \(sessionsURL.path)")

            // Check if file exists in other common locations
            let altPath = sessionsURL.deletingLastPathComponent().deletingLastPathComponent().appendingPathComponent("Pomodomore/sessions.json")
            if fileManager.fileExists(atPath: altPath.path) {
                print("⚠️ Found sessions at alternate path: \(altPath.path)")
            }

            return []
        }

        do {
            let data = try Data(contentsOf: sessionsURL)
            print("✅ StorageManager: Read \(data.count) bytes from file")

            let sessions = try decoder.decode([Session].self, from: data)
            print("✅ StorageManager: Successfully decoded \(sessions.count) sessions")
            return sessions
        } catch {
            print("❌ StorageManager: Failed to load sessions: \(error)")
            if let decodingError = error as? DecodingError {
                print("   Decoding error details: \(decodingError)")
            }
            return []
        }
    }
}
