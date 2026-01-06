//
//  SoundSettingsView.swift
//  pomodomore
//
//  Created on 01/02/26.
//

import SwiftUI

// MARK: - Sound Settings View

/// Sound and notification configuration settings
struct SoundSettingsView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var fontManager: FontManager
    private let soundManager = SoundManager.shared

    private var tickSoundOptions: [String] {
        SoundManager.availableTickSounds
    }

    private var completionSoundOptions: [BundledSound] {
        SoundManager.availableCompletionSounds
    }

    private var ambientSoundOptions: [AmbientSoundItem] {
        SoundManager.availableAmbientSounds
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Notifications Section
                SettingsSectionHeader(title: "Notifications")

                SettingsToggleRow(
                    label: "Enable completion notifications",
                    isOn: $settingsManager.settings.sound.notificationsEnabled
                )

                // Completion Sound Section
                SettingsSectionHeader(title: "Completion Sound")

                SettingsPickerRow(
                    label: "Sound",
                    selection: $settingsManager.settings.sound.completionSound,
                    options: completionSoundOptions,
                    optionLabel: { $0.name }
                )
                .onChange(of: settingsManager.settings.sound.completionSound) { _, newValue in
                    soundManager.playCompletionSound(newValue)
                }

                Text("Sound played when timer completes")
                    .appFont(size: 11)
                    .foregroundColor(themeManager.currentTheme.colors.textSecondary)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)

                // Tick Sound Section
                SettingsSectionHeader(title: "Tick Sound")

                SettingsPickerRow(
                    label: "Sound",
                    selection: $settingsManager.settings.sound.tickSound,
                    options: tickSoundOptions,
                    optionLabel: { $0 }
                )
                .onChange(of: settingsManager.settings.sound.tickSound) { _, newValue in
                    // Preview the selected tick sound (cancels any existing preview)
                    soundManager.previewTickSound(soundName: newValue)
                }

                Text("Play a looping tick sound during Pomodoro sessions")
                    .appFont(size: 11)
                    .foregroundColor(themeManager.currentTheme.colors.textSecondary)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)

                // Ambient Sound Section
                SettingsSectionHeader(title: "Ambient Sound")

                SettingsPickerRow(
                    label: "Sound",
                    selection: $settingsManager.settings.sound.ambientSound,
                    options: ambientSoundOptions,
                    optionLabel: { $0.displayName }
                )

                Text("Play ambient sound during Pomodoro sessions")
                    .appFont(size: 11)
                    .foregroundColor(themeManager.currentTheme.colors.textSecondary)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)

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
    SoundSettingsView()
        .frame(width: 560, height: 520)
        .environmentObject(ThemeManager.shared)
        .environmentObject(FontManager.shared)
}
