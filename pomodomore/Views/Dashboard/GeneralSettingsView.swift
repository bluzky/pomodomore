//
//  GeneralSettingsView.swift
//  pomodomore
//
//  Created on 01/02/26.
//

import SwiftUI

// MARK: - General Settings View

/// General application settings
struct GeneralSettingsView: View {
    @EnvironmentObject var settingsManager: SettingsManager

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Startup Section
                SettingsSectionHeader(title: "Startup")

                 SettingsToggleRow(
                     label: "Launch on start",
                     isOn: $settingsManager.settings.general.startOnLogin
                 )
                 .onChange(of: settingsManager.settings.general.startOnLogin) { _, newValue in
                     LoginItemsManager.shared.setLoginItem(enabled: newValue)
                 }

                // Session Durations Section
                SettingsSectionHeader(title: "Session Durations")

                SettingsStepperRow(
                    label: "Pomodoro",
                    value: Binding(
                        get: { settingsManager.settings.pomodoro.pomodoroDuration / 60 },
                        set: { settingsManager.settings.pomodoro.pomodoroDuration = $0 * 60 }
                    ),
                    range: 1...60,
                    valueFormatter: { "\($0) min" }
                )

                SettingsStepperRow(
                    label: "Short Break",
                    value: Binding(
                        get: { settingsManager.settings.pomodoro.shortBreakDuration / 60 },
                        set: { settingsManager.settings.pomodoro.shortBreakDuration = $0 * 60 }
                    ),
                    range: 1...30,
                    valueFormatter: { "\($0) min" }
                )

                SettingsStepperRow(
                    label: "Long Break",
                    value: Binding(
                        get: { settingsManager.settings.pomodoro.longBreakDuration / 60 },
                        set: { settingsManager.settings.pomodoro.longBreakDuration = $0 * 60 }
                    ),
                    range: 1...60,
                    valueFormatter: { "\($0) min" }
                )

                SettingsStepperRow(
                    label: "Long Break Interval",
                    value: $settingsManager.settings.pomodoro.longBreakInterval,
                    range: 2...10,
                    valueFormatter: { "\($0) sessions" }
                )

                // Auto-Start Section
                SettingsSectionHeader(title: "Auto-Start")

                SettingsToggleRow(
                    label: "Automatically start next session",
                    isOn: $settingsManager.settings.pomodoro.autoStartNextSession
                )

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 12)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(NSColor.windowBackgroundColor))
    }
}



// MARK: - Preview

#Preview {
    GeneralSettingsView()
        .frame(width: 560, height: 520)
}
