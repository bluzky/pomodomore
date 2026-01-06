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
                // Theme Section
                SettingsSectionHeader(title: "Theme")

                // Theme Picker with color previews
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(Theme.allThemes, id: \.name) { theme in
                        ThemePickerRow(
                            theme: theme,
                            isSelected: settingsManager.settings.appearance.theme == theme.name,
                            onSelect: {
                                settingsManager.updateTheme(theme.name)
                            }
                        )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 16)

                // Window Size Section
                SettingsSectionHeader(title: "Window Size")

                SettingsPickerRow(
                    label: "Timer window",
                    selection: $settingsManager.settings.appearance.windowSize,
                    options: WindowSize.allCases,
                    optionLabel: { $0.displayName }
                )

                // Menubar Section
                SettingsSectionHeader(title: "Menubar")

                SettingsToggleRow(
                    label: "Show timer in menubar",
                    isOn: $settingsManager.settings.appearance.showTimerInMenubar
                )

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 0)
            .padding(.bottom, 12)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(themeManager.currentTheme.colors.backgroundPrimary)
    }
}

// MARK: - Theme Picker Row

/// Individual theme row with name and color preview
struct ThemePickerRow: View {
    let theme: Theme
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 12) {
                // Theme name
                Text(theme.name)
                    .font(.system(size: 13))
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                // Color preview circles
                HStack(spacing: 6) {
                    Circle()
                        .fill(theme.colors.accentPrimary)
                        .frame(width: 14, height: 14)

                    Circle()
                        .fill(theme.colors.timerActive)
                        .frame(width: 14, height: 14)

                    Circle()
                        .fill(theme.colors.textPrimary)
                        .frame(width: 14, height: 14)
                }

                // Selection indicator
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.accentColor)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(isSelected ? Color.accentColor.opacity(0.1) : Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(isSelected ? Color.accentColor : Color.clear, lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    AppearanceSettingsView()
        .environmentObject(SettingsManager.shared)
        .frame(width: 560, height: 520)
}
