//
//  SoundType.swift
//  pomodomore
//
//  Created on 01/15/26.
//

import Foundation
import AppKit

/// Sound types available for timer notifications
enum SoundType: String, CaseIterable, Identifiable, Codable {
    case blow
    case glass
    case hero
    case morse
    case ping
    case submarine
    case tink
    case typewriter

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .blow: return "Blow"
        case .glass: return "Glass"
        case .hero: return "Hero"
        case .morse: return "Morse"
        case .ping: return "Ping"
        case .submarine: return "Submarine"
        case .tink: return "Tink"
        case .typewriter: return "Typewriter"
        }
    }

    /// AppKit system sound name (works in sandbox)
    var systemSoundName: NSSound.Name {
        switch self {
        case .blow: return .blow
        case .glass: return .glass
        case .hero: return .hero
        case .morse: return .morse
        case .ping: return .ping
        case .submarine: return .submarine
        case .tink: return .tink
        case .typewriter: return .typewriter
        }
    }
}

extension NSSound.Name {
    static let blow = NSSound.Name("Blow")
    static let glass = NSSound.Name("Glass")
    static let hero = NSSound.Name("Hero")
    static let morse = NSSound.Name("Morse")
    static let ping = NSSound.Name("Ping")
    static let submarine = NSSound.Name("Submarine")
    static let tink = NSSound.Name("Tink")
    static let typewriter = NSSound.Name("Typewriter")
}

// MARK: - Bundled Sound Types

/// Completion sounds from bundled resources
enum BundledCompletionSound: String, CaseIterable, Identifiable, Codable {
    case sound1 = "Sound 1"
    case sound2 = "Sound 2"
    case sound3 = "Sound 3"
    case sound4 = "Sound 4"
    case sound5 = "Sound 5"
    case sound6 = "Sound 6"
    case sound7 = "Sound 7"
    case sound8 = "Sound 8"
    case sound9 = "Sound 9"
    case sound10 = "Sound 10"
    case sound11 = "Sound 11"

    var id: String { rawValue }

    var displayName: String {
        return rawValue
    }

    var fileName: String {
        return rawValue
    }

    var fileExtension: String {
        switch self {
        case .sound1, .sound2, .sound9, .sound10, .sound11:
            return "mp3"
        default:
            return "wav"
        }
    }
}

/// Ambient sounds from bundled resources
enum AmbientSound: String, CaseIterable, Identifiable, Codable {
    case none = "None"
    case waterStream = "Water Stream"
    case springRain = "Spring Rain"
    case oceanWave = "Ocean Wave"
    case morningForest = "Morning Forest"
    case campFire = "Camp Fire"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .none: return "None"
        case .waterStream: return "Water Stream"
        case .springRain: return "Spring Rain"
        case .oceanWave: return "Ocean Wave"
        case .morningForest: return "Morning Forest"
        case .campFire: return "Camp Fire"
        }
    }

    var fileName: String {
        switch self {
        case .none: return ""
        case .waterStream: return "water stream"
        case .springRain: return "spring rain"
        case .oceanWave: return "ocean wave"
        case .morningForest: return "morning forest"
        case .campFire: return "camp fire"
        }
    }
}

/// Lifecycle sounds (start, stop)
enum LifecycleSound: String, Codable {
    case start = "Start"
    case stop = "Stop"
}
