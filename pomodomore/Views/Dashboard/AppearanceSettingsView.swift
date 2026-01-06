//
//  AppearanceSettingsView.swift
//  pomodomore
//
//  Created on January 14, 2026.
//  Week 5, Day 2: Appearance settings with theme picker
//  Updated Day 3: Added font picker with system fonts
//

import SwiftUI

// MARK: - Appearance Settings View

/// Appearance customization settings (themes, fonts, window size)
struct AppearanceSettingsView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var fontManager: FontManager

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Theme Picker with dropdown
                SettingsPickerRow(
                    label: "Theme",
                    selection: $settingsManager.settings.appearance.theme,
                    options: Theme.allThemes.map { $0.name },
                    optionLabel: { $0 }
                )
                .onChange(of: settingsManager.settings.appearance.theme) { _, newValue in
                    settingsManager.updateTheme(newValue)
                }

                // Font Picker with system fonts (Day 3) - with font preview
                FontPickerRow(
                    label: "Font",
                    selection: $settingsManager.settings.appearance.font,
                    options: fontManager.availableFonts.map { $0.familyName }
                )
                .onChange(of: settingsManager.settings.appearance.font) { _, newValue in
                    settingsManager.updateFont(newValue)
                }

                SettingsPickerRow(
                    label: "Timer window",
                    selection: $settingsManager.settings.appearance.windowSize,
                    options: WindowSize.allCases,
                    optionLabel: { $0.displayName }
                )

                SettingsToggleRow(
                    label: "Show timer in menubar",
                    isOn: $settingsManager.settings.appearance.showTimerInMenubar
                )

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 12)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(themeManager.currentTheme.colors.backgroundPrimary)
        .onAppear {
            // Lazy load fonts only when Appearance view is opened
            fontManager.loadAvailableFontsIfNeeded()
        }
    }
}

// MARK: - Font Picker Row

/// Font picker row (memory optimized - no font preview)
struct FontPickerRow: View {
    let label: String
    @Binding var selection: String
    let options: [String]

    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var fontManager: FontManager

    var body: some View {
        HStack {
            Text(label)
                .appFont(size: 13)
                .foregroundColor(themeManager.currentTheme.colors.textPrimary)

            Spacer()

            Picker("", selection: $selection) {
                ForEach(options, id: \.self) { fontName in
                    Text(fontName)  // System font only - prevents loading fonts
                        .tag(fontName)
                }
            }
            .pickerStyle(.menu)
            .fixedSize()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

// MARK: - Preview

#Preview {
    AppearanceSettingsView()
        .environmentObject(SettingsManager.shared)
        .environmentObject(ThemeManager.shared)
        .environmentObject(FontManager.shared)
        .frame(width: 560, height: 520)
}
