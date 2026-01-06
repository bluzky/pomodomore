//
//  AppearanceSettingsView.swift
//  pomodomore
//
//  Created on January 14, 2026.
//  Week 5, Day 2: Appearance settings with theme picker
//

import SwiftUI

// MARK: - Appearance Settings View

/// Appearance customization settings (themes, fonts, window size)
struct AppearanceSettingsView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @EnvironmentObject var themeManager: ThemeManager

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
    }
}

// MARK: - Preview

#Preview {
    AppearanceSettingsView()
        .environmentObject(SettingsManager.shared)
        .frame(width: 560, height: 520)
}
