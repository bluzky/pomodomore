//
//  AppFont.swift
//  pomodomore
//
//  Created on January 15, 2026.
//  Week 5, Day 3: Font system with system fonts
//

import Foundation
import AppKit

// MARK: - App Font Model

/// Represents a font family
struct AppFont: Identifiable, Equatable {
    let id: String
    let familyName: String
    let displayName: String

    /// Get the regular font name for this family
    var regularFontName: String {
        // Just return the family name - SwiftUI's .custom() will handle finding the regular variation
        // This works because .custom(familyName, size:) uses the regular weight by default
        return familyName
    }

    // MARK: - Equatable

    static func == (lhs: AppFont, rhs: AppFont) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Font Availability Checker

/// Provides methods to get available font families from the system
enum FontAvailabilityChecker {

    /// Get all available font families from the system
    static func getAvailableFontFamilies() -> [AppFont] {
        var fonts: [AppFont] = []

        // Get all available font families
        let fontFamilies = NSFontManager.shared.availableFontFamilies

        for familyName in fontFamilies {
            let appFont = AppFont(
                id: familyName,
                familyName: familyName,
                displayName: familyName
            )
            fonts.append(appFont)
        }

        return fonts.sorted { $0.displayName.lowercased() < $1.displayName.lowercased() }
    }

    /// Check if a specific font is installed
    static func isFontInstalled(_ fontName: String) -> Bool {
        NSFont(name: fontName, size: 12) != nil
    }
}
