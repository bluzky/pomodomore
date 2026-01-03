//
//  SessionTag.swift
//  pomodomore
//
//  Created on 01/09/25.
//

import SwiftUI

/// Represents a tag/category for Pomodoro sessions (e.g., Study, Work, Research)
/// Only stores ID reference - name and color are looked up from predefined tags
struct SessionTag: Identifiable, Codable, Equatable, Hashable {
    /// Unique identifier for the tag
    let id: String

    /// Display name of the tag (e.g., "Study", "Work") - looked up from predefined tags
    var name: String {
        TagMetadata.name(for: id)
    }

    /// Color for the tag - looked up from predefined tags
    var color: Color {
        TagMetadata.color(for: id)
    }

    /// Initialize with just an ID (recommended for storage)
    init(id: String) {
        self.id = id
    }

    /// Full initialization (for predefined tags)
    init(id: String, name: String, colorHex: String) {
        self.id = id
    }

    // MARK: - Predefined Tags

    /// Predefined tag: Study (blue)
    static let study = SessionTag(id: "study")

    /// Predefined tag: Work (green)
    static let work = SessionTag(id: "work")

    /// Predefined tag: Research (purple)
    static let research = SessionTag(id: "research")

    /// Predefined tag: Personal (orange)
    static let personal = SessionTag(id: "personal")

    /// Predefined tag: Meeting (red)
    static let meeting = SessionTag(id: "meeting")

    /// Predefined tag: Deep Work (cyan)
    static let deepWork = SessionTag(id: "deep-work")

    /// Predefined tag: Other (gray)
    static let other = SessionTag(id: "other")

    /// Array of all predefined tags
    static let predefinedTags: [SessionTag] = [
        .study,
        .work,
        .research,
        .personal,
        .meeting,
        .deepWork,
        .other
    ]

    /// Default tag (first in predefined list)
    static let defaultTag: SessionTag = study
}

// MARK: - Tag Metadata

/// Private helper for tag metadata lookup
private enum TagMetadata {
    static let tagInfo: [String: (name: String, colorHex: String)] = [
        "study": ("Study", "#3B82F6"),
        "work": ("Work", "#10B981"),
        "research": ("Research", "#8B5CF6"),
        "personal": ("Personal", "#F59E0B"),
        "meeting": ("Meeting", "#EF4444"),
        "deep-work": ("Deep Work", "#45B7D1"),
        "other": ("Other", "#6B7280")
    ]

    static func name(for id: String) -> String {
        tagInfo[id]?.name ?? id.capitalized
    }

    static func color(for id: String) -> Color {
        guard let hex = tagInfo[id]?.colorHex else { return .gray }
        return Color(hex: hex)
    }
}

// MARK: - Color Extension for Hex Support

extension Color {
    /// Initialize Color from hex string (e.g., "#3B82F6")
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 6: // RGB (e.g., "3B82F6")
            (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (0, 0, 0) // Fallback to black for invalid hex
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: 1
        )
    }
}
