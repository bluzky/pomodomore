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
