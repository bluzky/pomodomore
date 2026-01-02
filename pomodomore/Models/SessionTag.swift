//
//  SessionTag.swift
//  pomodomore
//
//  Created on 01/09/25.
//

import SwiftUI

/// Represents a tag/category for Pomodoro sessions (e.g., Study, Work, Research)
/// Allows users to categorize their work sessions with a name and color
struct SessionTag: Identifiable, Codable, Equatable, Hashable {
    /// Unique identifier for the tag
    let id: String

    /// Display name of the tag (e.g., "Study", "Work")
    let name: String

    /// Color hex string for Codable storage (e.g., "#3B82F6")
    private let colorHex: String

    /// Computed SwiftUI Color from hex string
    var color: Color {
        Color(hex: colorHex)
    }

    /// Initialize a session tag with name and hex color
    init(id: String, name: String, colorHex: String) {
        self.id = id
        self.name = name
        self.colorHex = colorHex
    }

    // MARK: - Predefined Tags

    /// Predefined tag: Study (blue)
    static let study = SessionTag(id: "study", name: "Study", colorHex: "#3B82F6")

    /// Predefined tag: Work (green)
    static let work = SessionTag(id: "work", name: "Work", colorHex: "#10B981")

    /// Predefined tag: Research (purple)
    static let research = SessionTag(id: "research", name: "Research", colorHex: "#8B5CF6")

    /// Predefined tag: Personal (orange)
    static let personal = SessionTag(id: "personal", name: "Personal", colorHex: "#F59E0B")

    /// Predefined tag: Meeting (red)
    static let meeting = SessionTag(id: "meeting", name: "Meeting", colorHex: "#EF4444")

    /// Predefined tag: Other (gray)
    static let other = SessionTag(id: "other", name: "Other", colorHex: "#6B7280")

    /// Array of all predefined tags
    static let predefinedTags: [SessionTag] = [
        .study,
        .work,
        .research,
        .personal,
        .meeting,
        .other
    ]

    /// Default tag (first in predefined list)
    static let defaultTag: SessionTag = study
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
