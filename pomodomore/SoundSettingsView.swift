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
    @ObservedObject var settingsManager = SettingsManager.shared

    private let tickSoundOptions = ["None", "Tick 1", "Tick 2", "Tick 3", "Glass", "Tink", "Pop"]
    private let ambientSoundOptions = ["None", "White Noise", "Rain", "Cafe", "Forest", "Ocean"]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Notifications Section
                notificationsSection

                // Tick Sound Section
                tickSoundSection

                // Ambient Sound Section
                ambientSoundSection

                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(24)
        }
        .frame(width: 520, alignment: .leading)
        .frame(maxHeight: .infinity)
        .background(Color(NSColor.windowBackgroundColor))
    }

    // MARK: - Notifications Section

    private var notificationsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Notifications")
                .font(.system(size: 14, weight: .semibold))

            Toggle("Enable completion notifications", isOn: $settingsManager.settings.sound.notificationsEnabled)
                .toggleStyle(.switch)
        }
    }

    // MARK: - Tick Sound Section

    private var tickSoundSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Tick Sound")
                .font(.system(size: 14, weight: .semibold))

            HStack {
                Text("Sound")
                    .font(.system(size: 13))
                    .frame(width: 100, alignment: .leading)

                Picker("", selection: $settingsManager.settings.sound.tickSound) {
                    ForEach(tickSoundOptions, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
                .pickerStyle(.menu)
                .frame(width: 150)
            }

            Text("Play a tick sound every second during Pomodoro sessions")
                .font(.system(size: 11))
                .foregroundColor(.secondary)
        }
    }

    // MARK: - Ambient Sound Section

    private var ambientSoundSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Ambient Sound")
                .font(.system(size: 14, weight: .semibold))

            HStack {
                Text("Sound")
                    .font(.system(size: 13))
                    .frame(width: 100, alignment: .leading)

                Picker("", selection: $settingsManager.settings.sound.ambientSound) {
                    ForEach(ambientSoundOptions, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
                .pickerStyle(.menu)
                .frame(width: 150)
            }

            Text("Play ambient sound during Pomodoro sessions")
                .font(.system(size: 11))
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Preview

#Preview {
    SoundSettingsView()
        .frame(width: 560, height: 520)
}
