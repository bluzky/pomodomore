//
//  FontManager.swift
//  pomodomore
//
//  Created on January 15, 2026.
//  Week 5, Day 3: Font selection system with system fonts
//

import SwiftUI
import Combine

// MARK: - Font Manager

/// Manages font selection and application throughout the app
@MainActor
class FontManager: ObservableObject {
    /// Shared singleton instance
    static let shared = FontManager()

    /// Current font name to use for rendering (regular variation)
    @Published var currentFontName: String = "Monaco"

    /// Current font family
    @Published var currentFont: AppFont

    /// All available font families from the system
    @Published private(set) var availableFonts: [AppFont] = []

    /// Font to use when selected font is unavailable
    private let fallbackFamilyName = "Monaco"

    /// Track if fonts have been loaded to avoid redundant loading
    private var fontsLoaded = false

    // MARK: - Initialization

    private init() {
        // Initialize with default font family
        currentFont = AppFont(id: "Monaco", familyName: "Monaco", displayName: "Monaco")
        currentFontName = "Monaco"

        // Don't load all fonts at startup - load lazily when needed
        print("FontManager initialized with font: \(currentFontName)")
    }

    // MARK: - Public Methods

    /// Load available font families from the system (lazy loading - only loads once)
    func loadAvailableFontsIfNeeded() {
        guard !fontsLoaded else { return }

        print("Loading font families from system...")
        availableFonts = FontAvailabilityChecker.getAvailableFontFamilies()

        // Ensure fallback font is available
        if !availableFonts.contains(where: { $0.familyName == fallbackFamilyName }) {
            availableFonts.insert(AppFont(
                id: fallbackFamilyName,
                familyName: fallbackFamilyName,
                displayName: fallbackFamilyName
            ), at: 0)
        }

        fontsLoaded = true
        print("Found \(availableFonts.count) font families on system")
    }

    /// Load available font families from the system (force reload)
    private func loadAvailableFonts() {
        availableFonts = FontAvailabilityChecker.getAvailableFontFamilies()

        // Ensure fallback font is available
        if !availableFonts.contains(where: { $0.familyName == fallbackFamilyName }) {
            availableFonts.insert(AppFont(
                id: fallbackFamilyName,
                familyName: fallbackFamilyName,
                displayName: fallbackFamilyName
            ), at: 0)
        }
    }

    /// Load a font family and apply the regular variation
    func loadFont(named fontFamilyName: String) {
        let normalizedName = fontFamilyName.trimmingCharacters(in: .whitespaces)

        // Check if font family exists in available fonts
        if let font = availableFonts.first(where: { $0.familyName == normalizedName }) {
            currentFont = font
            currentFontName = font.regularFontName
            print("Font loaded: \(font.familyName) (regular: \(currentFontName))")
            return
        }

        // Fallback to SF Mono if font not found
        currentFont = AppFont(id: fallbackFamilyName, familyName: fallbackFamilyName, displayName: fallbackFamilyName)
        currentFontName = fallbackFamilyName
        print("⚠️ Font '\(fontFamilyName)' not found, falling back to \(fallbackFamilyName)")
    }

    /// Set the current font directly from an AppFont object
    func setFont(_ font: AppFont) {
        let regularFontName = font.regularFontName
        if NSFont(name: regularFontName, size: 12) != nil {
            currentFont = font
            currentFontName = regularFontName
            print("Font set to: \(font.familyName)")
        } else {
            print("⚠️ Cannot set unavailable font: \(font.familyName)")
        }
    }

    /// Get the current font family name for font descriptors
    var currentFontFamilyName: String {
        currentFontName
    }

    /// Create a SwiftUI Font with the current font
    func swiftUIFont(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .custom(currentFontName, size: size).weight(weight)
    }
}

// MARK: - App Font Modifier

/// View modifier for applying the app's custom font
struct AppFontModifier: ViewModifier {
    let size: CGFloat
    let weight: Font.Weight

    @EnvironmentObject private var fontManager: FontManager

    func body(content: Content) -> some View {
        // Observe fontManager.currentFontName so view updates when font changes
        content.font(.custom(fontManager.currentFontName, size: size))
            .fontWeight(weight)
    }
}

// MARK: - View Extension

extension View {
    /// Apply the app's custom font with specified size and weight
    func appFont(size: CGFloat, weight: Font.Weight = .regular) -> some View {
        modifier(AppFontModifier(size: size, weight: weight))
            .environmentObject(FontManager.shared)
    }

    /// Apply the app's custom font at a small size (12pt)
    func appFontSmall(weight: Font.Weight = .regular) -> some View {
        modifier(AppFontModifier(size: 12, weight: weight))
            .environmentObject(FontManager.shared)
    }

    /// Apply the app's custom font at a medium size (14pt)
    func appFontMedium(weight: Font.Weight = .regular) -> some View {
        modifier(AppFontModifier(size: 14, weight: weight))
            .environmentObject(FontManager.shared)
    }

    /// Apply the app's custom font at a large size (16pt)
    func appFontLarge(weight: Font.Weight = .regular) -> some View {
        modifier(AppFontModifier(size: 16, weight: weight))
            .environmentObject(FontManager.shared)
    }
}
