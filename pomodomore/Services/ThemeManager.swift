//
//  ThemeManager.swift
//  pomodomore
//
//  Created on January 13, 2026.
//  Manages theme loading and application
//

import SwiftUI
import Combine

@MainActor
class ThemeManager: ObservableObject {
    static let shared = ThemeManager()

    @Published var currentTheme: Theme = .nord

    private init() {
        // Initialize with default theme (Nord)
        print("ThemeManager initialized with theme: \(currentTheme.name)")
    }

    // MARK: - Public Methods

    /// Load a theme by name (case-insensitive)
    func loadTheme(named name: String) {
        let normalizedName = name.trimmingCharacters(in: .whitespaces).lowercased()

        guard let theme = Theme.allThemes.first(where: { $0.name.lowercased() == normalizedName }) else {
            print("⚠️ Theme '\(name)' not found, falling back to Nord")
            setTheme(.nord)
            return
        }

        setTheme(theme)
    }

    /// Set the current theme
    func setTheme(_ theme: Theme) {
        currentTheme = theme
        print("🎨 Theme changed to: \(theme.name)")
    }

    /// Get theme by name (returns nil if not found)
    func getTheme(named name: String) -> Theme? {
        let normalizedName = name.trimmingCharacters(in: .whitespaces).lowercased()
        return Theme.allThemes.first(where: { $0.name.lowercased() == normalizedName })
    }

    /// Get all available theme names
    func getAllThemeNames() -> [String] {
        Theme.allThemes.map { $0.name }
    }
}
