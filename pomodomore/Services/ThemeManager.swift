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
        currentTheme = .nord
        // Apply window appearance on launch (may not have windows yet, but will apply when they open)
        DispatchQueue.main.async {
            self.updateWindowAppearance()
        }
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
        updateWindowAppearance()
        print("🎨 Theme changed to: \(theme.name)")
    }

    /// Update all window appearances to match the current theme (light/dark)
    private func updateWindowAppearance() {
        let appearance: NSAppearance?
        if currentTheme.isDark {
            appearance = NSAppearance(named: .darkAqua)
        } else {
            appearance = NSAppearance(named: .aqua)
        }

        // Update all application windows
        for window in NSApplication.shared.windows {
            window.appearance = appearance
        }
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
