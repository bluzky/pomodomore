//
//  Theme.swift
//  pomodomore
//
//  Created on January 13, 2026.
//  Theme system with 10 code editor-inspired themes
//

import SwiftUI

// MARK: - Theme Colors

struct ThemeColors {
    // Backgrounds
    let backgroundPrimary: Color       // Main window background
    let backgroundSecondary: Color     // Cards, panels
    let backgroundTertiary: Color      // Hover states

    // Text
    let textPrimary: Color            // Main text
    let textSecondary: Color          // Secondary text
    let textMuted: Color              // Disabled text

    // Accents
    let accentPrimary: Color          // Primary buttons
    let accentSecondary: Color        // Secondary highlights

    // Borders
    let borderPrimary: Color          // Main borders
    let borderSecondary: Color        // Secondary borders

    // Status
    let success: Color                // Success states
    let warning: Color                // Warnings
    let error: Color                  // Errors

    // Timer States
    let timerActive: Color            // Active timer (green)
    let timerPaused: Color            // Paused timer (yellow)
    let timerBreak: Color             // Break timer (cyan)

    // Session Indicators
    let sessionComplete: Color        // Filled circle
    let sessionIncomplete: Color      // Empty circle

    // Effects
    let shadow: Color                 // Drop shadows

    // Additional UI colors
    let sidebarBackground: Color      // Sidebar background
    let sidebarSelected: Color        // Selected sidebar item
    let buttonHover: Color            // Button hover state
}

// MARK: - Theme

struct Theme {
    let name: String
    let colors: ThemeColors

    // MARK: - Nord Theme (Default)

    static let nord = Theme(
        name: "Nord",
        colors: ThemeColors(
            backgroundPrimary: Color(hex: "#2E3440"),
            backgroundSecondary: Color(hex: "#3B4252"),
            backgroundTertiary: Color(hex: "#434C5E"),
            textPrimary: Color(hex: "#ECEFF4"),
            textSecondary: Color(hex: "#D8DEE9"),
            textMuted: Color(hex: "#4C566A"),
            accentPrimary: Color(hex: "#88C0D0"),
            accentSecondary: Color(hex: "#81A1C1"),
            borderPrimary: Color(hex: "#4C566A"),
            borderSecondary: Color(hex: "#3B4252"),
            success: Color(hex: "#A3BE8C"),
            warning: Color(hex: "#EBCB8B"),
            error: Color(hex: "#BF616A"),
            timerActive: Color(hex: "#A3BE8C"),
            timerPaused: Color(hex: "#EBCB8B"),
            timerBreak: Color(hex: "#88C0D0"),
            sessionComplete: Color(hex: "#88C0D0"),
            sessionIncomplete: Color(hex: "#4C566A"),
            shadow: Color(hex: "#000000").opacity(0.3),
            sidebarBackground: Color(hex: "#2E3440"),
            sidebarSelected: Color(hex: "#434C5E"),
            buttonHover: Color(hex: "#434C5E")
        )
    )

    // MARK: - Monokai Theme

    static let monokai = Theme(
        name: "Monokai",
        colors: ThemeColors(
            backgroundPrimary: Color(hex: "#272822"),
            backgroundSecondary: Color(hex: "#3E3D32"),
            backgroundTertiary: Color(hex: "#49483E"),
            textPrimary: Color(hex: "#F8F8F2"),
            textSecondary: Color(hex: "#CFCFC2"),
            textMuted: Color(hex: "#75715E"),
            accentPrimary: Color(hex: "#66D9EF"),
            accentSecondary: Color(hex: "#AE81FF"),
            borderPrimary: Color(hex: "#49483E"),
            borderSecondary: Color(hex: "#3E3D32"),
            success: Color(hex: "#A6E22E"),
            warning: Color(hex: "#E6DB74"),
            error: Color(hex: "#F92672"),
            timerActive: Color(hex: "#A6E22E"),
            timerPaused: Color(hex: "#E6DB74"),
            timerBreak: Color(hex: "#66D9EF"),
            sessionComplete: Color(hex: "#66D9EF"),
            sessionIncomplete: Color(hex: "#75715E"),
            shadow: Color(hex: "#000000").opacity(0.4),
            sidebarBackground: Color(hex: "#272822"),
            sidebarSelected: Color(hex: "#49483E"),
            buttonHover: Color(hex: "#49483E")
        )
    )

    // MARK: - Dracula Theme

    static let dracula = Theme(
        name: "Dracula",
        colors: ThemeColors(
            backgroundPrimary: Color(hex: "#282A36"),
            backgroundSecondary: Color(hex: "#44475A"),
            backgroundTertiary: Color(hex: "#6272A4"),
            textPrimary: Color(hex: "#F8F8F2"),
            textSecondary: Color(hex: "#E6E6E6"),
            textMuted: Color(hex: "#6272A4"),
            accentPrimary: Color(hex: "#BD93F9"),
            accentSecondary: Color(hex: "#FF79C6"),
            borderPrimary: Color(hex: "#6272A4"),
            borderSecondary: Color(hex: "#44475A"),
            success: Color(hex: "#50FA7B"),
            warning: Color(hex: "#F1FA8C"),
            error: Color(hex: "#FF5555"),
            timerActive: Color(hex: "#50FA7B"),
            timerPaused: Color(hex: "#F1FA8C"),
            timerBreak: Color(hex: "#8BE9FD"),
            sessionComplete: Color(hex: "#BD93F9"),
            sessionIncomplete: Color(hex: "#6272A4"),
            shadow: Color(hex: "#000000").opacity(0.5),
            sidebarBackground: Color(hex: "#282A36"),
            sidebarSelected: Color(hex: "#44475A"),
            buttonHover: Color(hex: "#44475A")
        )
    )

    // MARK: - Solarized Dark Theme

    static let solarizedDark = Theme(
        name: "Solarized Dark",
        colors: ThemeColors(
            backgroundPrimary: Color(hex: "#002B36"),
            backgroundSecondary: Color(hex: "#073642"),
            backgroundTertiary: Color(hex: "#586E75"),
            textPrimary: Color(hex: "#FDF6E3"),
            textSecondary: Color(hex: "#EEE8D5"),
            textMuted: Color(hex: "#586E75"),
            accentPrimary: Color(hex: "#268BD2"),
            accentSecondary: Color(hex: "#2AA198"),
            borderPrimary: Color(hex: "#586E75"),
            borderSecondary: Color(hex: "#073642"),
            success: Color(hex: "#859900"),
            warning: Color(hex: "#B58900"),
            error: Color(hex: "#DC322F"),
            timerActive: Color(hex: "#859900"),
            timerPaused: Color(hex: "#B58900"),
            timerBreak: Color(hex: "#2AA198"),
            sessionComplete: Color(hex: "#268BD2"),
            sessionIncomplete: Color(hex: "#586E75"),
            shadow: Color(hex: "#000000").opacity(0.4),
            sidebarBackground: Color(hex: "#002B36"),
            sidebarSelected: Color(hex: "#073642"),
            buttonHover: Color(hex: "#073642")
        )
    )

    // MARK: - Tokyo Night Theme

    static let tokyoNight = Theme(
        name: "Tokyo Night",
        colors: ThemeColors(
            backgroundPrimary: Color(hex: "#1A1B26"),
            backgroundSecondary: Color(hex: "#24283B"),
            backgroundTertiary: Color(hex: "#414868"),
            textPrimary: Color(hex: "#C0CAF5"),
            textSecondary: Color(hex: "#A9B1D6"),
            textMuted: Color(hex: "#565F89"),
            accentPrimary: Color(hex: "#7AA2F7"),
            accentSecondary: Color(hex: "#BB9AF7"),
            borderPrimary: Color(hex: "#414868"),
            borderSecondary: Color(hex: "#24283B"),
            success: Color(hex: "#9ECE6A"),
            warning: Color(hex: "#E0AF68"),
            error: Color(hex: "#F7768E"),
            timerActive: Color(hex: "#9ECE6A"),
            timerPaused: Color(hex: "#E0AF68"),
            timerBreak: Color(hex: "#7DCFFF"),
            sessionComplete: Color(hex: "#7AA2F7"),
            sessionIncomplete: Color(hex: "#565F89"),
            shadow: Color(hex: "#000000").opacity(0.5),
            sidebarBackground: Color(hex: "#1A1B26"),
            sidebarSelected: Color(hex: "#24283B"),
            buttonHover: Color(hex: "#24283B")
        )
    )

    // MARK: - Gruvbox Dark Theme

    static let gruvboxDark = Theme(
        name: "Gruvbox Dark",
        colors: ThemeColors(
            backgroundPrimary: Color(hex: "#282828"),
            backgroundSecondary: Color(hex: "#3C3836"),
            backgroundTertiary: Color(hex: "#504945"),
            textPrimary: Color(hex: "#EBDBB2"),
            textSecondary: Color(hex: "#D5C4A1"),
            textMuted: Color(hex: "#928374"),
            accentPrimary: Color(hex: "#83A598"),
            accentSecondary: Color(hex: "#D3869B"),
            borderPrimary: Color(hex: "#504945"),
            borderSecondary: Color(hex: "#3C3836"),
            success: Color(hex: "#B8BB26"),
            warning: Color(hex: "#FABD2F"),
            error: Color(hex: "#FB4934"),
            timerActive: Color(hex: "#B8BB26"),
            timerPaused: Color(hex: "#FABD2F"),
            timerBreak: Color(hex: "#8EC07C"),
            sessionComplete: Color(hex: "#83A598"),
            sessionIncomplete: Color(hex: "#928374"),
            shadow: Color(hex: "#000000").opacity(0.4),
            sidebarBackground: Color(hex: "#282828"),
            sidebarSelected: Color(hex: "#3C3836"),
            buttonHover: Color(hex: "#3C3836")
        )
    )

    // MARK: - One Dark Theme

    static let oneDark = Theme(
        name: "One Dark",
        colors: ThemeColors(
            backgroundPrimary: Color(hex: "#282C34"),
            backgroundSecondary: Color(hex: "#21252B"),
            backgroundTertiary: Color(hex: "#2C323C"),
            textPrimary: Color(hex: "#ABB2BF"),
            textSecondary: Color(hex: "#9DA5B4"),
            textMuted: Color(hex: "#5C6370"),
            accentPrimary: Color(hex: "#61AFEF"),
            accentSecondary: Color(hex: "#C678DD"),
            borderPrimary: Color(hex: "#3E4451"),
            borderSecondary: Color(hex: "#2C323C"),
            success: Color(hex: "#98C379"),
            warning: Color(hex: "#E5C07B"),
            error: Color(hex: "#E06C75"),
            timerActive: Color(hex: "#98C379"),
            timerPaused: Color(hex: "#E5C07B"),
            timerBreak: Color(hex: "#56B6C2"),
            sessionComplete: Color(hex: "#61AFEF"),
            sessionIncomplete: Color(hex: "#5C6370"),
            shadow: Color(hex: "#000000").opacity(0.3),
            sidebarBackground: Color(hex: "#21252B"),
            sidebarSelected: Color(hex: "#2C323C"),
            buttonHover: Color(hex: "#2C323C")
        )
    )

    // MARK: - Catppuccin Mocha Theme

    static let catppuccinMocha = Theme(
        name: "Catppuccin Mocha",
        colors: ThemeColors(
            backgroundPrimary: Color(hex: "#1E1E2E"),
            backgroundSecondary: Color(hex: "#313244"),
            backgroundTertiary: Color(hex: "#45475A"),
            textPrimary: Color(hex: "#CDD6F4"),
            textSecondary: Color(hex: "#BAC2DE"),
            textMuted: Color(hex: "#6C7086"),
            accentPrimary: Color(hex: "#89B4FA"),
            accentSecondary: Color(hex: "#CBA6F7"),
            borderPrimary: Color(hex: "#45475A"),
            borderSecondary: Color(hex: "#313244"),
            success: Color(hex: "#A6E3A1"),
            warning: Color(hex: "#F9E2AF"),
            error: Color(hex: "#F38BA8"),
            timerActive: Color(hex: "#A6E3A1"),
            timerPaused: Color(hex: "#F9E2AF"),
            timerBreak: Color(hex: "#94E2D5"),
            sessionComplete: Color(hex: "#89B4FA"),
            sessionIncomplete: Color(hex: "#6C7086"),
            shadow: Color(hex: "#000000").opacity(0.4),
            sidebarBackground: Color(hex: "#1E1E2E"),
            sidebarSelected: Color(hex: "#313244"),
            buttonHover: Color(hex: "#313244")
        )
    )

    // MARK: - GitHub Dark Theme

    static let githubDark = Theme(
        name: "GitHub Dark",
        colors: ThemeColors(
            backgroundPrimary: Color(hex: "#0D1117"),
            backgroundSecondary: Color(hex: "#161B22"),
            backgroundTertiary: Color(hex: "#21262D"),
            textPrimary: Color(hex: "#C9D1D9"),
            textSecondary: Color(hex: "#8B949E"),
            textMuted: Color(hex: "#6E7681"),
            accentPrimary: Color(hex: "#58A6FF"),
            accentSecondary: Color(hex: "#A371F7"),
            borderPrimary: Color(hex: "#30363D"),
            borderSecondary: Color(hex: "#21262D"),
            success: Color(hex: "#3FB950"),
            warning: Color(hex: "#D29922"),
            error: Color(hex: "#F85149"),
            timerActive: Color(hex: "#3FB950"),
            timerPaused: Color(hex: "#D29922"),
            timerBreak: Color(hex: "#56D4DD"),
            sessionComplete: Color(hex: "#58A6FF"),
            sessionIncomplete: Color(hex: "#6E7681"),
            shadow: Color(hex: "#000000").opacity(0.5),
            sidebarBackground: Color(hex: "#0D1117"),
            sidebarSelected: Color(hex: "#161B22"),
            buttonHover: Color(hex: "#161B22")
        )
    )

    // MARK: - Solarized Light Theme

    static let solarizedLight = Theme(
        name: "Solarized Light",
        colors: ThemeColors(
            backgroundPrimary: Color(hex: "#FDF6E3"),
            backgroundSecondary: Color(hex: "#EEE8D5"),
            backgroundTertiary: Color(hex: "#93A1A1"),
            textPrimary: Color(hex: "#073642"),
            textSecondary: Color(hex: "#586E75"),
            textMuted: Color(hex: "#93A1A1"),
            accentPrimary: Color(hex: "#268BD2"),
            accentSecondary: Color(hex: "#2AA198"),
            borderPrimary: Color(hex: "#93A1A1"),
            borderSecondary: Color(hex: "#EEE8D5"),
            success: Color(hex: "#859900"),
            warning: Color(hex: "#B58900"),
            error: Color(hex: "#DC322F"),
            timerActive: Color(hex: "#859900"),
            timerPaused: Color(hex: "#B58900"),
            timerBreak: Color(hex: "#2AA198"),
            sessionComplete: Color(hex: "#268BD2"),
            sessionIncomplete: Color(hex: "#93A1A1"),
            shadow: Color(hex: "#000000").opacity(0.1),
            sidebarBackground: Color(hex: "#EEE8D5"),
            sidebarSelected: Color(hex: "#FDF6E3"),
            buttonHover: Color(hex: "#FDF6E3")
        )
    )

    // MARK: - All Themes

    static let allThemes: [Theme] = [
        nord,
        monokai,
        dracula,
        solarizedDark,
        tokyoNight,
        gruvboxDark,
        oneDark,
        catppuccinMocha,
        githubDark,
        solarizedLight
    ]
}
