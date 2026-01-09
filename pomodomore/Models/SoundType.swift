//
//  SoundType.swift
//  pomodomore
//
//  Created on 01/15/26.
//

import Foundation

// MARK: - Dynamic Bundled Sound

/// A completion/notification sound loaded from bundled resources
struct BundledSound: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let fileName: String
    let fileExtension: String

    init(name: String, fileExtension: String) {
        self.id = name
        self.name = name
        self.fileName = name
        self.fileExtension = fileExtension
    }
}

// MARK: - Dynamic Ambient Sound

/// An ambient sound loaded from bundled resources
struct AmbientSoundItem: Identifiable, Codable, Hashable {
    let id: String
    let displayName: String
    let fileName: String

    init(displayName: String, fileName: String) {
        self.id = displayName
        self.displayName = displayName
        self.fileName = fileName
    }

    static let none = AmbientSoundItem(displayName: "None", fileName: "")
}

// MARK: - Dynamic Sound Loader

/// Loads available sounds from the app bundle
enum SoundLoader {
    /// Load all completion sounds from Sounds/notification/
    static func loadCompletionSounds() -> [BundledSound] {
        let fileManager = FileManager.default
        guard let bundlePath = Bundle.main.path(forResource: "Sounds/notification", ofType: nil) else {
            return []
        }

        do {
            let files = try fileManager.contentsOfDirectory(atPath: bundlePath)
            return files
                .filter { file in
                    let ext = (file as NSString).pathExtension.lowercased()
                    return ext == "mp3" || ext == "wav"
                }
                .sorted()
                .map { file in
                    let nameWithoutExt = (file as NSString).deletingPathExtension
                    let ext = (file as NSString).pathExtension.lowercased()
                    return BundledSound(name: nameWithoutExt, fileExtension: ext)
                }
        } catch {
            print("⚠️ Failed to load completion sounds: \(error)")
            return []
        }
    }

    /// Load all ambient sounds from Sounds/ambient/
    static func loadAmbientSounds() -> [AmbientSoundItem] {
        let fileManager = FileManager.default
        guard let bundlePath = Bundle.main.path(forResource: "Sounds/ambient", ofType: nil) else {
            return []
        }

        do {
            let files = try fileManager.contentsOfDirectory(atPath: bundlePath)
            return files
                .filter { file in
                    let ext = (file as NSString).pathExtension.lowercased()
                    return ext == "mp3"
                }
                .sorted()
                .map { file in
                    let nameWithoutExt = (file as NSString).deletingPathExtension
                    return AmbientSoundItem(displayName: nameWithoutExt, fileName: nameWithoutExt)
                }
        } catch {
            print("⚠️ Failed to load ambient sounds: \(error)")
            return []
        }
    }

    /// Load all tick sounds from Sounds/ticks/
    static func loadTickSoundNames() -> [String] {
        let fileManager = FileManager.default
        guard let bundlePath = Bundle.main.path(forResource: "Sounds/ticks", ofType: nil) else {
            return []
        }

        do {
            let files = try fileManager.contentsOfDirectory(atPath: bundlePath)
            return files
                .filter { file in
                    let ext = (file as NSString).pathExtension.lowercased()
                    return ext == "mp3"
                }
                .sorted()
                .map { file in
                    (file as NSString).deletingPathExtension
                }
        } catch {
            print("⚠️ Failed to load tick sounds: \(error)")
            return []
        }
    }

    /// Import a sound file to the target directory
    static func importSound(from sourceURL: URL, to targetDir: String) -> Bool {
        let fileManager = FileManager.default
        guard let targetPath = Bundle.main.path(forResource: targetDir, ofType: nil) else {
            return false
        }

        let destinationURL = URL(fileURLWithPath: targetPath).appendingPathComponent(sourceURL.lastPathComponent)

        do {
            if fileManager.fileExists(atPath: destinationURL.path) {
                try fileManager.removeItem(at: destinationURL)
            }
            try fileManager.copyItem(at: sourceURL, to: destinationURL)
            return true
        } catch {
            print("⚠️ Failed to import sound: \(error)")
            return false
        }
    }
}
