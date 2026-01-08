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
    let isDark: Bool  // Indicates if this is a dark theme (affects system control appearance)
    let colors: ThemeColors

    // MARK: - Nord Theme (Default)

    static let nord = Theme(
        name: "Nord",
        isDark: true,
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

    // MARK: - Dracula Theme

    static let dracula = Theme(
        name: "Dracula",
        isDark: true,
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
        isDark: true,
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

    // MARK: - Catppuccin Mocha Theme

    static let catppuccinMocha = Theme(
        name: "Catppuccin Mocha",
        isDark: true,
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

    // MARK: - Solarized Light Theme

    static let solarizedLight = Theme(
        name: "Solarized Light",
        isDark: false,
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

    // MARK: - Nord Light Theme

    static let nordLight = Theme(
        name: "Nord Light",
        isDark: false,
        colors: ThemeColors(
            backgroundPrimary: Color(hex: "#ECEFF4"),
            backgroundSecondary: Color(hex: "#E5E9F0"),
            backgroundTertiary: Color(hex: "#D8DEE9"),
            textPrimary: Color(hex: "#2E3440"),
            textSecondary: Color(hex: "#3B4252"),
            textMuted: Color(hex: "#4C566A"),
            accentPrimary: Color(hex: "#5E81AC"),
            accentSecondary: Color(hex: "#81A1C1"),
            borderPrimary: Color(hex: "#D8DEE9"),
            borderSecondary: Color(hex: "#E5E9F0"),
            success: Color(hex: "#A3BE8C"),
            warning: Color(hex: "#EBCB8B"),
            error: Color(hex: "#BF616A"),
            timerActive: Color(hex: "#A3BE8C"),
            timerPaused: Color(hex: "#EBCB8B"),
            timerBreak: Color(hex: "#88C0D0"),
            sessionComplete: Color(hex: "#5E81AC"),
            sessionIncomplete: Color(hex: "#D8DEE9"),
            shadow: Color(hex: "#000000").opacity(0.1),
            sidebarBackground: Color(hex: "#E5E9F0"),
            sidebarSelected: Color(hex: "#ECEFF4"),
            buttonHover: Color(hex: "#ECEFF4")
        )
    )

    // MARK: - Ayu Dark Theme

    static let ayuDark = Theme(
        name: "Ayu Dark",
        isDark: true,
        colors: ThemeColors(
            backgroundPrimary: Color(hex: "#0A0E14"),
            backgroundSecondary: Color(hex: "#0D1017"),
            backgroundTertiary: Color(hex: "#151A1E"),
            textPrimary: Color(hex: "#B3B1AD"),
            textSecondary: Color(hex: "#8A8986"),
            textMuted: Color(hex: "#4D5566"),
            accentPrimary: Color(hex: "#59C2FF"),
            accentSecondary: Color(hex: "#FFB454"),
            borderPrimary: Color(hex: "#151A1E"),
            borderSecondary: Color(hex: "#0D1017"),
            success: Color(hex: "#91B362"),
            warning: Color(hex: "#E6B450"),
            error: Color(hex: "#D95757"),
            timerActive: Color(hex: "#91B362"),
            timerPaused: Color(hex: "#E6B450"),
            timerBreak: Color(hex: "#59C2FF"),
            sessionComplete: Color(hex: "#59C2FF"),
            sessionIncomplete: Color(hex: "#4D5566"),
            shadow: Color(hex: "#000000").opacity(0.4),
            sidebarBackground: Color(hex: "#0A0E14"),
            sidebarSelected: Color(hex: "#0D1017"),
            buttonHover: Color(hex: "#0D1017")
        )
    )

    // MARK: - Ayu Light Theme

    static let ayuLight = Theme(
        name: "Ayu Light",
        isDark: false,
        colors: ThemeColors(
            backgroundPrimary: Color(hex: "#FAFAFA"),
            backgroundSecondary: Color(hex: "#F3F4F5"),
            backgroundTertiary: Color(hex: "#E7E8E9"),
            textPrimary: Color(hex: "#5C6166"),
            textSecondary: Color(hex: "#828C99"),
            textMuted: Color(hex: "#ABB0B6"),
            accentPrimary: Color(hex: "#399EE6"),
            accentSecondary: Color(hex: "#FA8D3E"),
            borderPrimary: Color(hex: "#E7E8E9"),
            borderSecondary: Color(hex: "#F3F4F5"),
            success: Color(hex: "#86B300"),
            warning: Color(hex: "#F2AE49"),
            error: Color(hex: "#F07171"),
            timerActive: Color(hex: "#86B300"),
            timerPaused: Color(hex: "#F2AE49"),
            timerBreak: Color(hex: "#399EE6"),
            sessionComplete: Color(hex: "#399EE6"),
            sessionIncomplete: Color(hex: "#E7E8E9"),
            shadow: Color(hex: "#000000").opacity(0.1),
            sidebarBackground: Color(hex: "#F3F4F5"),
            sidebarSelected: Color(hex: "#FAFAFA"),
            buttonHover: Color(hex: "#FAFAFA")
        )
    )

    // MARK: - Everforest Dark Theme

    static let everforestDark = Theme(
        name: "Everforest Dark",
        isDark: true,
        colors: ThemeColors(
            backgroundPrimary: Color(hex: "#2B3339"),
            backgroundSecondary: Color(hex: "#323D43"),
            backgroundTertiary: Color(hex: "#3A464C"),
            textPrimary: Color(hex: "#D3C6AA"),
            textSecondary: Color(hex: "#9DA9A0"),
            textMuted: Color(hex: "#7A8478"),
            accentPrimary: Color(hex: "#A7C080"),
            accentSecondary: Color(hex: "#E69875"),
            borderPrimary: Color(hex: "#3A464C"),
            borderSecondary: Color(hex: "#323D43"),
            success: Color(hex: "#A7C080"),
            warning: Color(hex: "#DBBC7F"),
            error: Color(hex: "#E67E80"),
            timerActive: Color(hex: "#A7C080"),
            timerPaused: Color(hex: "#DBBC7F"),
            timerBreak: Color(hex: "#83C092"),
            sessionComplete: Color(hex: "#7FBBB3"),
            sessionIncomplete: Color(hex: "#7A8478"),
            shadow: Color(hex: "#000000").opacity(0.4),
            sidebarBackground: Color(hex: "#2B3339"),
            sidebarSelected: Color(hex: "#323D43"),
            buttonHover: Color(hex: "#323D43")
        )
    )

    // MARK: - Everforest Light Theme

    static let everforestLight = Theme(
        name: "Everforest Light",
        isDark: false,
        colors: ThemeColors(
            backgroundPrimary: Color(hex: "#FDF6E3"),
            backgroundSecondary: Color(hex: "#F3EFDA"),
            backgroundTertiary: Color(hex: "#E6E2CC"),
            textPrimary: Color(hex: "#5C6A72"),
            textSecondary: Color(hex: "#829181"),
            textMuted: Color(hex: "#A6B0A0"),
            accentPrimary: Color(hex: "#8DA101"),
            accentSecondary: Color(hex: "#F85552"),
            borderPrimary: Color(hex: "#E6E2CC"),
            borderSecondary: Color(hex: "#F3EFDA"),
            success: Color(hex: "#93B259"),
            warning: Color(hex: "#DFA000"),
            error: Color(hex: "#F85552"),
            timerActive: Color(hex: "#93B259"),
            timerPaused: Color(hex: "#DFA000"),
            timerBreak: Color(hex: "#35A77C"),
            sessionComplete: Color(hex: "#3A94C5"),
            sessionIncomplete: Color(hex: "#E6E2CC"),
            shadow: Color(hex: "#000000").opacity(0.1),
            sidebarBackground: Color(hex: "#F3EFDA"),
            sidebarSelected: Color(hex: "#FDF6E3"),
            buttonHover: Color(hex: "#FDF6E3")
        )
    )

    // MARK: - Catppuccin Latte Theme

    static let catppuccinLatte = Theme(
        name: "Catppuccin Latte",
        isDark: false,
        colors: ThemeColors(
            backgroundPrimary: Color(hex: "#EFF1F5"),
            backgroundSecondary: Color(hex: "#E6E9EF"),
            backgroundTertiary: Color(hex: "#DCE0E8"),
            textPrimary: Color(hex: "#4C4F69"),
            textSecondary: Color(hex: "#5C5F77"),
            textMuted: Color(hex: "#9CA0B0"),
            accentPrimary: Color(hex: "#1E66F5"),
            accentSecondary: Color(hex: "#8839EF"),
            borderPrimary: Color(hex: "#DCE0E8"),
            borderSecondary: Color(hex: "#E6E9EF"),
            success: Color(hex: "#40A02B"),
            warning: Color(hex: "#DF8E1D"),
            error: Color(hex: "#D20F39"),
            timerActive: Color(hex: "#40A02B"),
            timerPaused: Color(hex: "#DF8E1D"),
            timerBreak: Color(hex: "#04A5E5"),
            sessionComplete: Color(hex: "#1E66F5"),
            sessionIncomplete: Color(hex: "#DCE0E8"),
            shadow: Color(hex: "#000000").opacity(0.1),
            sidebarBackground: Color(hex: "#E6E9EF"),
            sidebarSelected: Color(hex: "#EFF1F5"),
            buttonHover: Color(hex: "#EFF1F5")
        )
    )

    // MARK: - All Themes

    static let allThemes: [Theme] = [
        nord,
        nordLight,
        dracula,
        solarizedDark,
        solarizedLight,
        catppuccinMocha,
        catppuccinLatte,
        ayuDark,
        ayuLight,
        everforestDark,
        everforestLight
    ]
}
