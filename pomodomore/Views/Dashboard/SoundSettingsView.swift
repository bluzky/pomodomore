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
    @StateObject private var soundManager = SoundManager.shared

    private let tickSoundOptions = ["None", "Tick 1", "Tick 2", "Tick 3", "Glass", "Tink", "Pop"]
    private let ambientSoundOptions = ["None", "White Noise", "Rain", "Cafe", "Forest", "Ocean"]

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
                    options: SoundType.allCases,
                    optionLabel: { $0.displayName }
                )
                .onChange(of: settingsManager.settings.sound.completionSound) { _, newValue in
                    soundManager.play(newValue)
                }

                Text("Sound played when timer completes")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
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

                Text("Play a tick sound every second during Pomodoro sessions")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)

                // Ambient Sound Section
                SettingsSectionHeader(title: "Ambient Sound")

                SettingsPickerRow(
                    label: "Sound",
                    selection: $settingsManager.settings.sound.ambientSound,
                    options: ambientSoundOptions,
                    optionLabel: { $0 }
                )

                Text("Play ambient sound during Pomodoro sessions")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 12)
        }
        .frame(width: 520, alignment: .leading)
        .frame(maxHeight: .infinity)
        .background(Color(NSColor.windowBackgroundColor))
    }
}

// MARK: - Preview

#Preview {
    SoundSettingsView()
        .frame(width: 560, height: 520)
}
